// Minimal CDP client for the Battle.net desktop app (Chrome 108), which chrome-devtools-mcp can't enumerate.
// Usage:
//   node cdp.mjs list
//   node cdp.mjs eval  <script.js> [urlPrefix]          -> prints JSON result of the script's last expression (async ok)
//   node cdp.mjs shot  <out.png>   [urlPrefix] [full]   -> screenshot (viewport, or full page with "full")
//   node cdp.mjs hover <x> <y>     [urlPrefix]          -> move the mouse to a point
import { readFileSync, writeFileSync } from 'node:fs';

const BASE = process.env.CDP_BASE || 'http://127.0.0.1:8888';
const [cmd, a1, a2, a3] = process.argv.slice(2);

const targets = await (await fetch(`${BASE}/json/list`)).json();
if (cmd === 'list') {
  for (const t of targets) console.log(`${t.type.padEnd(8)} ${t.id}  ${t.url}`);
  process.exit(0);
}

const prefix = (cmd === 'eval' || cmd === 'shot') ? (a2 || 'resources://home') : (a3 || 'resources://home');
const target = targets.find(t => t.url.startsWith(prefix) && t.webSocketDebuggerUrl);
if (!target) { console.error(`no target with url prefix ${prefix}`); process.exit(1); }

const ws = new WebSocket(target.webSocketDebuggerUrl);
let seq = 0; const pending = new Map();
ws.onmessage = (e) => { const m = JSON.parse(e.data); if (m.id && pending.has(m.id)) { pending.get(m.id)(m); pending.delete(m.id); } };
const send = (method, params = {}) => new Promise((res, rej) => {
  const i = ++seq; pending.set(i, (m) => m.error ? rej(new Error(`${method}: ${m.error.message}`)) : res(m.result));
  ws.send(JSON.stringify({ id: i, method, params }));
});
await new Promise(r => ws.onopen = r);

try {
  if (cmd === 'eval') {
    const src = readFileSync(a1, 'utf8');
    const r = await send('Runtime.evaluate', { expression: `(async () => { ${src} })()`, awaitPromise: true, returnByValue: true });
    if (r.exceptionDetails) { console.error(r.exceptionDetails.exception?.description || JSON.stringify(r.exceptionDetails)); process.exit(1); }
    const v = r.result.value;
    console.log(typeof v === 'string' ? v : JSON.stringify(v, null, 1));
  } else if (cmd === 'shot') {
    const params = { format: 'png' };
    if (a3 === 'full') {
      const m = await send('Page.getLayoutMetrics');
      const s = m.cssContentSize || m.contentSize;
      Object.assign(params, { captureBeyondViewport: true, clip: { x: 0, y: 0, width: s.width, height: s.height, scale: 1 } });
    }
    const r = await send('Page.captureScreenshot', params);
    writeFileSync(a1, Buffer.from(r.data, 'base64'));
    console.log(`saved ${a1}`);
  } else if (cmd === 'hover') {
    await send('Input.dispatchMouseEvent', { type: 'mouseMoved', x: Number(a1), y: Number(a2) });
    console.log(`mouse at ${a1},${a2}`);
  } else {
    console.error('unknown command'); process.exit(1);
  }
} finally { ws.close(); }
