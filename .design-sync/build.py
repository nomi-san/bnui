"""Build the claude.ai/design upload (ds-bundle/) from design-system/project/.

BNUI is a CSS-class design system (no React), so this follows the same flat-CSS
shape as Claude Design's built-in systems: styles.css @imports the token sheet
and the component layer; every component is an HTML card with a @dsCard first
line plus a <Name>.prompt.md usage file; _ds_bundle.js is an empty-bodied stub.

Run from the repo root:  python .design-sync/build.py
"""
import json, re, shutil, html
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
SRC = ROOT / 'design-system' / 'project'
OUT = ROOT / 'ds-bundle'
CONVENTIONS = ROOT / '.design-sync' / 'conventions.md'
FONT_IMPORT = 'https://fonts.googleapis.com/css2?family=Figtree:wght@500;700&family=Noto+Sans:wght@400;500;700&display=swap'
# Brand faces named in tokens.json that the bundle does not ship (licensed). Dropped from the uploaded font stacks:
# Claude Design flags any declared family without font files ("Missing brand font").
UNSHIPPED_FONTS = ('Object Sans',)
WIDE = {'Button': 820, 'HeroCarousel': 980, 'MediaCard': 900, 'ComparisonTable': 900, 'Dialog': 900, 'Lightbox': 900,
        'AnnouncementBanner': 1100, 'SettingsRow': 920, 'Panel': 900, 'GameTile': 860, 'MediaGallery': 820,
        'SideNav': 720, 'Select': 720, 'NewsRow': 900}
# Card viewport heights measured in Chrome (see card-heights.json); falls back to the artifact preview height + 40.
HEIGHTS = json.loads((ROOT / '.design-sync' / 'card-heights.json').read_text(encoding='utf-8'))['heights']

def esc_name(n): return n.replace('.', '\\.')

def build_tokens(t):
    themes = [th['id'] for th in t['color']['themes']]
    first = themes[0]
    root, per_theme = [], {th: [] for th in themes[1:]}
    def add(tok):
        v = tok['value']; n = esc_name(tok['name'])
        if isinstance(v, dict):
            root.append(f'  --{n}: {v.get(first)};')
            for th in themes[1:]:
                if th in v: per_theme[th].append(f'  --{n}: {v[th]};')
        else:
            root.append(f'  --{n}: {v};')
    for tok in t['color']['tokens']: add(tok)
    for tok in t.get('shadow', {}).get('tokens', []): add(tok)
    out = ['/* BNUI tokens - generated from design-system/project/tokens.json. Do not edit by hand. */',
           f'/* Default accent theme: {first}. Swap with data-theme="{"|".join(themes[1:])}" on <html> or any container. */',
           f':root, [data-theme="{first}"] {{', *root, '}']
    for th, lines in per_theme.items():
        out += [f'[data-theme="{th}"] {{', *lines, '}']
    scalars = []
    for fam in ('spacing', 'radius', 'duration', 'easing', 'size', 'zIndex'):
        for tok in t.get(fam, {}).get('tokens', []):
            scalars.append(f'  --{esc_name(tok["name"])}: {tok["value"]};')
    for key, stack in t['type']['families'].items():
        parts = [f for f in (x.strip() for x in stack.split(',')) if f.strip('"\'') not in UNSHIPPED_FONTS]
        scalars.append(f'  --font-{key}: {", ".join(parts)};')
    out += [':root {', *scalars, '}', '', '/* Type styles: each class sets the whole font. */']
    for g in t['type']['groups']:
        fam = g['family']
        for s in g['styles']:
            decl = f'font: {s["fontWeight"]} {s["fontSize"]}/{s["lineHeight"]} var(--font-{s.get("family", fam)});'
            if s.get('letterSpacing'): decl += f' letter-spacing: {s["letterSpacing"]};'
            out.append(f'.{s["name"]} {{ {decl} }}')
    return '\n'.join(out) + '\n'

def split_bundle_css(css):
    css = re.sub(r'^@import[^\n]*\n', '', css)
    helpers = re.findall(r'^\.ds-[^\n]*\n', css, flags=re.M)
    comp = re.sub(r'^\.ds-[^\n]*\n', '', css, flags=re.M)
    comp = comp.replace('/* preview helpers */\n', '')
    comp += '\n::selection { background: var(--accent-fill); color: var(--on-accent); }\n'
    return comp, ''.join(helpers)

def preview_parts(path):
    txt = path.read_text(encoding='utf-8')
    first = txt.split('\n', 1)[0]
    m = re.search(r'group="([^"]*)"', first); group = m.group(1) if m else 'Components'
    h = re.search(r'height=(\d+)', first); height = int(h.group(1)) if h else 240
    head_style = re.search(r'<style>([\s\S]*?)</style>', txt.split('<body>')[0])
    body = re.search(r'<body>\s*([\s\S]*?)\s*</body>', txt).group(1)
    return group, height, body, head_style.group(1) if head_style else ''

def summary_of(readme):
    lines = [l for l in readme.splitlines() if l.strip() and not l.startswith('#')]
    s = re.sub(r'[`*]', '', lines[0]).strip()
    return s

def card(name, group, subtitle, w, h, body, helpers, depth, extra_style=''):
    rel = '../' * depth
    sub = html.escape(subtitle[:250], quote=True)
    return (f'<!-- @dsCard group="{group}" name="{name}" subtitle="{sub}" viewport="{w}x{h}" -->\n'
            '<!doctype html>\n<html lang="en">\n<head>\n<meta charset="utf-8">\n'
            '<meta name="viewport" content="width=device-width, initial-scale=1">\n'
            f'<title>BNUI - {name}</title>\n<link rel="stylesheet" href="{rel}styles.css">\n'
            f'<style>\n/* Demo scaffolding only - everything visual comes from styles.css. */\nhtml {{ scrollbar-width: none; }}\n{helpers}{extra_style}</style>\n'
            f'</head>\n<body>\n{body}\n</body>\n</html>\n')

def swatch_rows(tokens, names):
    cells = []
    for n in names:
        tok = next(x for x in tokens if x['name'] == n)
        v = tok['value'] if isinstance(tok['value'], str) else tok['value'].get('bnet')
        cells.append(f'<div class="sw"><div class="sw__chip" style="background:var(--{n})"></div><div class="sw__name">{n}</div><div class="sw__val">{v}</div></div>')
    return ''.join(cells)

def foundations(t, helpers):
    ct = t['color']['tokens']
    groups = [('Surfaces', ['surface-sunken', 'surface-page', 'surface-raised', 'surface-strong', 'surface-highest', 'border-solid', 'neutral-muted']),
              ('Fills on surface-page', ['fill-subtle', 'fill', 'fill-strong', 'fill-dark', 'overlay-strong', 'scrim']),
              ('Lines', ['line-subtle', 'line', 'line-strong', 'line-hover']),
              ('Text', ['text-primary', 'text-body', 'text-secondary', 'text-tertiary', 'text-muted', 'text-disabled']),
              ('Accent (Bnet Blue)', ['accent-fill', 'accent-fill-pressed', 'accent', 'accent-ring', 'accent-soft', 'on-accent']),
              ('Status', ['success', 'warning', 'danger', 'info', 'success-strong', 'danger-strong', 'surface-inverse'])]
    sw_css = ('.sec{padding:var(--space-4) var(--space-6)}.sec h3{margin:0 0 var(--space-3);font:700 12px/16px var(--font-display);letter-spacing:.6px;text-transform:uppercase;color:var(--text-muted)}'
              '.sws{display:grid;grid-template-columns:repeat(auto-fill,minmax(120px,1fr));gap:var(--space-3)}'
              '.sw__chip{height:48px;border-radius:var(--radius-md);box-shadow:inset 0 0 0 1px var(--line-subtle)}'
              '.sw__name{margin-top:6px;font:700 12px/16px var(--font-display);color:var(--text-primary)}.sw__val{font:400 11px/16px var(--font-body);color:var(--text-muted)}\n')
    color_body = '\n'.join(f'<section class="sec"><h3>{g}</h3><div class="sws">{swatch_rows(ct, names)}</div></section>' for g, names in groups)
    cards = {'Color': ('Surfaces, white-alpha fills, lines, text, accent and status colours.', 900, 1080, color_body, sw_css)}
    rows = []
    for g in t['type']['groups']:
        for s in g['styles']:
            rows.append(f'<div class="tr"><div class="tr__meta">{s["name"]}<br><span>{s["fontSize"]}/{s["lineHeight"]} · {s["fontWeight"]}</span></div><div class="{s["name"]}" style="color:var(--text-primary)">{html.escape(s.get("sample", s["name"]))}</div></div>')
    ty_css = ('.tr{display:grid;grid-template-columns:150px 1fr;gap:var(--space-4);align-items:baseline;padding:var(--space-2) var(--space-6);border-top:1px solid var(--fill)}'
              '.tr__meta{font:700 12px/16px var(--font-display);color:var(--text-secondary)}.tr__meta span{font:400 11px/16px var(--font-body);color:var(--text-muted)}\n')
    cards['Type'] = ('Display face (headings, buttons, labels) and body face (text), every style at size.', 900, 1330, '<div style="padding-block:var(--space-4)">' + ''.join(rows) + '</div>', ty_css)
    sp = ''.join(f'<div class="bar"><span class="bar__name">{x["name"]}</span><span class="bar__fill" style="width:{x["value"]}"></span><span class="bar__val">{x["value"]}</span></div>' for x in t['spacing']['tokens'])
    rd = ''.join(f'<div class="rad"><div class="rad__box" style="border-radius:var(--{esc_name(x["name"])})"></div><div class="sw__name">{x["name"]}</div><div class="sw__val">{x["value"]}</div></div>' for x in t['radius']['tokens'])
    sh = ''.join(f'<div class="rad"><div class="rad__box" style="background:var(--surface-raised);box-shadow:var(--{x["name"]})"></div><div class="sw__name">{x["name"]}</div></div>' for x in t['shadow']['tokens'] if x['name'].startswith('shadow-') or x['name'].startswith('ring-'))
    lay_css = sw_css + ('.bar{display:grid;grid-template-columns:110px auto 1fr;align-items:center;gap:var(--space-3);margin-bottom:6px}.bar__name{font:700 12px/16px var(--font-display);color:var(--text-primary)}'
                        '.bar__fill{display:block;height:12px;background:var(--accent-fill);border-radius:var(--radius-xs)}.bar__val{font:400 11px/16px var(--font-body);color:var(--text-muted)}'
                        '.rads{display:grid;grid-template-columns:repeat(auto-fill,minmax(110px,1fr));gap:var(--space-4)}.rad__box{height:64px;background:var(--fill-strong)}\n')
    lay_body = (f'<section class="sec"><h3>Spacing</h3>{sp}</section><section class="sec"><h3>Radius</h3><div class="rads">{rd}</div></section>'
                f'<section class="sec"><h3>Elevation and hover rings</h3><div class="rads">{sh}</div></section>'
                '<section class="sec"><h3>Layout</h3><p class="body-sm" style="margin:0;color:var(--text-secondary)">Container: content max 1600px centred with 16px gutters. Product grids: 24px gaps, 5 columns. Cover grids: repeat(auto-fill, minmax(152px, 1fr)), raised to 176px from 1270px and 200px from 1774px. Side-header sections 320px + 1280px. Detail pages 1fr + 418px aside, 48px gap. Motion: 100ms colour-only hovers.</p></section>')
    cards['Layout'] = ('Spacing scale, radii, elevation and hover rings, layout rules.', 900, 1000, lay_body, lay_css)
    themes = t['color']['themes']
    acc_rows = ''.join(f'<div class="th" data-theme="{th["id"]}"><div class="th__name">{th["name"]}<br><span>data-theme="{th["id"]}"</span></div>'
                       '<button class="bn-btn bn-btn--primary bn-btn--md">Buy Now</button><button class="bn-btn bn-btn--primary bn-btn--md" style="box-shadow:var(--ring-primary-hover)">Hover</button>'
                       '<a class="bn-link" href="#">Link</a><div class="bn-dots"><span class="bn-dot"></span><span class="bn-dot" aria-current="true"></span><span class="bn-dot"></span></div>'
                       '<span class="body-sm" style="color:var(--accent-soft)">Online name</span></div>' for th in themes)
    acc_css = ('.th{display:grid;grid-template-columns:180px auto auto auto auto 1fr;align-items:center;gap:var(--space-4);padding:var(--space-3) var(--space-6);border-top:1px solid var(--fill)}'
               '.th__name{font:700 13px/17px var(--font-display);color:var(--text-primary)}.th__name span{font:400 11px/16px var(--font-body);color:var(--text-muted)}\n')
    cards['AccentThemes'] = ('Bnet Blue is the default; seven Open Color accents swap only the accent tokens via data-theme.', 900, 540, '<div style="padding-block:var(--space-4)">' + acc_rows + '</div>', acc_css)
    return cards

def main():
    t = json.loads((SRC / 'tokens.json').read_text(encoding='utf-8'))
    if OUT.exists():  # clear contents, keep the dir (a local preview server may hold it open)
        for c in OUT.iterdir(): shutil.rmtree(c) if c.is_dir() else c.unlink()
    (OUT / 'tokens').mkdir(parents=True)
    (OUT / 'tokens' / 'bnui-tokens.css').write_text(build_tokens(t), encoding='utf-8')
    comp_css, helpers = split_bundle_css((SRC / 'components' / 'bundle.css').read_text(encoding='utf-8'))
    (OUT / '_ds_bundle.css').write_text('/* BNUI component layer: every bn- class. Generated from design-system/project/components/bundle.css. */\n' + comp_css, encoding='utf-8')
    (OUT / 'styles.css').write_text(f'@import url("{FONT_IMPORT}");\n@import "./tokens/bnui-tokens.css";\n@import "./_ds_bundle.css";\n', encoding='utf-8')
    (OUT / '_ds_bundle.js').write_text('/* @ds-bundle: {"format":4,"namespace":"BNUI","components":[],"sourceHashes":{},"inlinedExternals":[],"unexposedExports":[]} */\n\n(() => {\n\nconst __ds_ns = (window.BNUI = window.BNUI || {});\n\nconst __ds_scope = {};\n\n(__ds_ns.__errors = __ds_ns.__errors || []);\n\n})();\n', encoding='utf-8')
    (OUT / '_ds_needs_recompile').write_text('{"by":"design-sync-cli"}', encoding='utf-8')

    table = []
    cards_meta = []
    comp_dirs = sorted(d for d in (SRC / 'components').iterdir() if d.is_dir() and d.name != 'Cover')
    for d in comp_dirs:
        name = d.name
        group, height, body, _ = preview_parts(d / 'preview.html')
        readme = (d / 'README.md').read_text(encoding='utf-8')
        summary = summary_of(readme)
        dest = OUT / 'components' / group / name; dest.mkdir(parents=True)
        card_body = re.sub(r'(class="bn-backdrop bn-backdrop--inline" style=")height:\d+px', r'\g<1>height:100vh', body, count=1)  # scrim fills the card
        (dest / f'{name}.html').write_text(card(name, group, summary, WIDE.get(name, 760), HEIGHTS.get(name, height + 40), card_body, helpers, 3), encoding='utf-8')
        rest = re.sub(r'^# .*\n', '', readme).strip().split('\n', 1)
        rest = rest[1].strip() if len(rest) > 1 else ''
        (dest / f'{name}.prompt.md').write_text(
            f'{summary}\n\n{rest}\n\n## Markup\n\nCopy this structure; `bn-` classes come from `styles.css`. Classes starting with `ds-` '
            '(`ds-row`, `ds-col`, `ds-grid`, `ds-media`) only lay out this example card and stand in for real images: replace them with your '
            'own layout using `--space-*` tokens and real `<img>` media.\n\n'
            f'```html\n{body}\n```\n', encoding='utf-8')
        cards_meta.append((f'components/{group}/{name}/{name}.html', WIDE.get(name, 760), HEIGHTS.get(name, height + 40)))
        classes = sorted({c for c in re.findall(r'\bbn-[a-z0-9-]+(?:--[a-z0-9-]+)?\b', body) if '__' not in c})
        table.append(f'| {name} | {group} | {", ".join(f"`{c}`" for c in classes)} | components/{group}/{name}/{name}.html |')

    for name, (sub, w, h, body, css) in foundations(t, helpers).items():
        dest = OUT / 'components' / 'Foundations' / name; dest.mkdir(parents=True)
        (dest / f'{name}.html').write_text(card(name, 'Foundations', sub, w, HEIGHTS.get(name, h), body, helpers, 3, css), encoding='utf-8')
        (dest / f'{name}.prompt.md').write_text(f'{sub}\n\nReference card generated from tokens.json; use the variables it shows, never raw values.\n', encoding='utf-8')
        cards_meta.append((f'components/Foundations/{name}/{name}.html', w, HEIGHTS.get(name, h)))

    _, _, cbody, cstyle = preview_parts(SRC / 'components' / 'Cover' / 'preview.html')
    (OUT / 'thumbnail.html').write_text('<!doctype html>\n<html lang="en">\n<head>\n<meta charset="utf-8">\n<title>BNUI</title>\n<link rel="stylesheet" href="styles.css">\n'
                                        f'<style>{cstyle}</style>\n</head>\n<body>\n{cbody}\n</body>\n</html>\n', encoding='utf-8')

    brand = (SRC / 'README.md').read_text(encoding='utf-8')
    brand = re.sub(r'\n## Components\n[\s\S]*$', '\n', brand).strip()
    brand = brand.replace('The display face is the licensed **Object Sans**; when it is not installed the stack falls back to **Figtree** (Google Fonts), then Noto Sans.',
                          'The display face ships as **Figtree** (Google Fonts), standing in for the licensed Object Sans that Battle.net uses; Noto Sans is its fallback.')
    readme = (CONVENTIONS.read_text(encoding='utf-8').strip() + '\n\n## Components\n\n| Component | Group | Classes | Card |\n|---|---|---|---|\n' + '\n'.join(table) +
              '\n\nFoundations cards: `components/Foundations/{Color,Type,Layout,AccentThemes}`. The cover is `thumbnail.html`.\n\n---\n\n# Brand book\n\n' + brand + '\n')
    (OUT / 'README.md').write_text(readme, encoding='utf-8')
    cards_meta.append(('thumbnail.html', 960, 288))
    frames = ''.join(f'<figure><figcaption>{p} ({w}x{h})</figcaption><iframe src="{p}" width="{w}" height="{h}" loading="eager"></iframe></figure>' for p, w, h in cards_meta)
    (OUT / '.review.html').write_text('<!doctype html><meta charset="utf-8"><title>BNUI review</title><style>body{margin:0;padding:16px;background:#0b0c10;color:#ccc;font:12px system-ui}figure{margin:0 0 24px}iframe{display:block;border:1px solid #333;background:#15171e}</style>' + frames, encoding='utf-8')
    n = sum(1 for _ in (OUT / 'components').rglob('*.html'))
    # Local-only metadata the validator reads; never uploaded.
    (OUT / '.ds-build-meta.json').write_text(json.dumps({'namespace': 'BNUI', 'source': 'bnui@0.0.0 (css-only)', 'shape': 'package', 'provider': None,
                                                         'componentCount': n, 'skippedStoryIds': [], 'runtimeFontPrefixes': []}, indent=2) + '\n', encoding='utf-8')
    print(f'built {OUT}: {n} cards, README {len(readme)} chars')

if __name__ == '__main__':
    main()
