import { createEffect, createSignal, onCleanup, Show } from 'solid-js';
import { Button, Checkbox, Link, Select } from './components';
import { Gallery } from './demos/Gallery';
import { SettingsDialog, SettingsFrame } from './demos/SettingsWindow';

const THEMES = [
  ['bnet', 'Bnet Blue'], ['oc-blue', 'Open Color Blue'], ['oc-indigo', 'Open Color Indigo'], ['oc-violet', 'Open Color Violet'],
  ['oc-grape', 'Open Color Grape'], ['oc-pink', 'Open Color Pink'], ['oc-teal', 'Open Color Teal'], ['oc-orange', 'Open Color Orange'],
] as const;

/* Per-viewer conveniences only; the page renders the same without storage. */
const load = (key: string, fallback: string) => { try { return localStorage.getItem(key) ?? fallback; } catch { return fallback; } };
const save = (key: string, value: string) => { try { localStorage.setItem(key, value); } catch { /* private mode */ } };

export default function App() {
  const [theme, setTheme] = createSignal(load('bnui.theme', 'bnet'));
  const [instant, setInstant] = createSignal(load('bnui.motion', '') === 'instant');
  const [settingsOpen, setSettingsOpen] = createSignal(false);
  const [route, setRoute] = createSignal(location.hash);

  const onHash = () => setRoute(location.hash);
  window.addEventListener('hashchange', onHash);
  onCleanup(() => window.removeEventListener('hashchange', onHash));

  // Accent theme and motion live on <html>, exactly as the design system documents them.
  createEffect(() => {
    const root = document.documentElement;
    theme() === 'bnet' ? root.removeAttribute('data-theme') : root.setAttribute('data-theme', theme());
    instant() ? root.setAttribute('data-motion', 'instant') : root.removeAttribute('data-motion');
    save('bnui.theme', theme());
    save('bnui.motion', instant() ? 'instant' : '');
  });

  const themeName = () => THEMES.find(([id]) => id === theme())?.[1] ?? 'Bnet Blue';

  return (
    <Show when={route() !== '#/settings'} fallback={<div class="p-0"><SettingsFrame /></div>}>
      <header class="sticky top-0 z-sticky border-b border-line-subtle bg-surface-page">
        <div class="mx-auto flex max-w-content-max flex-wrap items-center gap-6 px-4 py-4">
          <h1 class="heading-lg m-0 text-primary">BNUI <span class="text-secondary">· SolidJS + Tailwind 3</span></h1>
          <div class="ml-auto flex flex-wrap items-center gap-6">
            <Select class="w-[220px]" variant="filled" aria-label="Accent theme" value={themeName()}
              onChange={(name) => setTheme(THEMES.find(([, n]) => n === name)?.[0] ?? 'bnet')}
              options={THEMES.map(([, name]) => name)} />
            <Checkbox label="Instant motion (native app)" checked={instant()} onChange={setInstant} />
            <Button variant="primary" size="md" onClick={() => setSettingsOpen(true)}>Open Settings</Button>
          </div>
        </div>
      </header>
      <main class="mx-auto grid max-w-content-max gap-16 px-4 py-10">
        <Gallery />
        <section class="grid gap-4 border-t border-line pt-8">
          <div class="grid gap-1">
            <h2 class="heading-lg m-0 text-primary">Settings window</h2>
            <p class="body-sm m-0 text-secondary">
              The desktop app's Settings dialog at its captured size (996×708), built from these components.
              <Link class="ml-1" href="#/settings">Open it alone</Link> for screenshot comparison.
            </p>
          </div>
          <div class="overflow-auto"><SettingsFrame /></div>
        </section>
      </main>
      <SettingsDialog open={settingsOpen()} onOpenChange={setSettingsOpen} />
    </Show>
  );
}
