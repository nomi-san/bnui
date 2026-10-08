import { createSignal, Match, Switch, type JSX, type ParentProps } from 'solid-js';
import { createStore, reconcile } from 'solid-js/store';
import {
  Button, Checkbox, Dialog, DialogFrame, DialogLayout, DialogSection, IconBell, IconDocument,
  IconDownload, IconFlask, IconFriends, IconGame, IconGear, IconInfo, IconMic, Link, Select, SideNav, Slider,
  TextField, type SideNavItem,
} from '../components';

/* The Battle.net desktop app's Settings window (capture/app-settings/), rebuilt from BNUI parts.
   Labels and defaults come from the captures; option lists beyond the captured value are
   placeholders. Values are local state only. */

const VERSION = '2.53.4.17896';
/* Only the Clear Saved Login Info tooltip was captured (08-app-tooltip.png). */
const NOT_CAPTURED = 'Tooltip text not captured yet';

const pages: SideNavItem[] = [
  { id: 'app', label: 'App', icon: IconGear },
  { id: 'downloads', label: 'Downloads', icon: IconDownload },
  { id: 'game', label: 'Game Settings', icon: IconGame, disabled: true },
  { id: 'friends', label: 'Friends & Chat', icon: IconFriends },
  { id: 'voice', label: 'Voice Chat', icon: IconMic },
  { id: 'notifications', label: 'Notifications', icon: IconBell },
  { id: 'beta', label: 'Beta', icon: IconFlask },
  { id: 'about', label: 'About', icon: IconDocument },
];

const defaults = {
  language: 'English (US)',
  onGameLaunch: 'Keep Battle.net open',
  onClose: 'Minimize Battle.net to the system tray',
  launchOnStartup: false,
  startMinimized: false,
  startupView: 'Home Page',
  hardwareAcceleration: true,
  multipleInstances: false,
  scanInBackground: false,
  desktopIcon: true,
  desktopIconAllUsers: true,
  pauseUpdates: true,
  notifyUpdates: true,
  limitUpdates: false,
  updatesLimit: '',
  limitPrerelease: true,
  prereleaseLimit: '1000',
  outputDevice: 'System Default Device',
  outputVolume: 50,
  inputDevice: 'System Default Device',
  inputVolume: 80,
  transmission: 'Open Mic',
  taskbarCount: true,
  toasts: true,
  toastCorner: 'Bottom right of screen',
  toastMonitor: 'Monitor 1 (Primary)',
  hideToastsInGame: true,
  hideToastsFullscreen: true,
  sounds: true,
  soundVolume: 100,
  muteInGame: true,
};
type Settings = typeof defaults;

/* ⓘ hint. The real app opens a tooltip popup; until the Tooltip component lands this uses the
   native title. */
const Hint = (props: { text: string }) => (
  <span title={props.text} aria-label={props.text} tabIndex={0}
    class="inline-grid size-4 flex-none cursor-help place-items-center rounded-full text-tertiary transition-colors duration-fast hover:text-primary focus-visible:shadow-ring-focus focus-visible:outline-none">
    <IconInfo class="size-4" />
  </span>
);

const Row = (props: ParentProps<{ class?: string }>) => <div class={`flex items-center gap-3 ${props.class ?? ''}`}>{props.children}</div>;
const Field = (props: { children: JSX.Element }) => <div class="max-w-[412px]">{props.children}</div>;
/* A slider beside a select: its label lines up with the select's label, its track with the select. */
const SliderRow = (props: ParentProps<{ label: string }>) => (
  <div class="grid gap-2"><span class="label uppercase text-secondary">{props.label}</span><div class="flex h-control-md items-center">{props.children}</div></div>
);

function Pages(props: { page: string; s: Settings; set: <K extends keyof Settings>(k: K, v: Settings[K]) => void }) {
  const s = () => props.s;
  return (
    <Switch>
      <Match when={props.page === 'app'}>
        <DialogSection title="General">
          <Field><Select variant="filled" label="App language" value={s().language} onChange={(v) => props.set('language', v)}
            options={['English (US)', 'Deutsch', 'Español (AL)', 'Español (EU)', 'Français', 'Italiano', 'Polski', 'Português (BR)', 'Русский', '한국어', '日本語', '简体中文', '繁體中文']} /></Field>
          <Field><Select variant="filled" label="On game launch" value={s().onGameLaunch} onChange={(v) => props.set('onGameLaunch', v)}
            options={['Keep Battle.net open', 'Minimize Battle.net', 'Exit Battle.net completely']} /></Field>
          <Field><Select variant="filled" label="When clicking X (close window)" value={s().onClose} onChange={(v) => props.set('onClose', v)}
            options={['Minimize Battle.net to the system tray', 'Exit Battle.net completely']} /></Field>
          <Row><Button size="md">Reset Dismissed Dialogs</Button><Hint text={NOT_CAPTURED} /></Row>
        </DialogSection>
        <DialogSection title="Startup">
          <Checkbox label="Launch Battle.net when I start my computer" checked={s().launchOnStartup}
            onChange={(v) => { props.set('launchOnStartup', v); if (!v) props.set('startMinimized', false); }} />
          <Checkbox nested label="Launch Battle.net minimized to the system tray" disabled={!s().launchOnStartup}
            checked={s().startMinimized} onChange={(v) => props.set('startMinimized', v)} />
          <Row class="ml-6"><Button size="md">Clear Saved Login Info</Button><Hint text="Clears all remembered email addresses and phone numbers on the login screen." /></Row>
          <Field><Select variant="filled" label="On startup, view" value={s().startupView} onChange={(v) => props.set('startupView', v)}
            options={['Home Page', 'Last Viewed Game Page']} /></Field>
        </DialogSection>
        <DialogSection title="Advanced">
          <Row><Checkbox label="Use browser hardware acceleration" checked={s().hardwareAcceleration} onChange={(v) => props.set('hardwareAcceleration', v)} /><Hint text={NOT_CAPTURED} /></Row>
          <Row><Checkbox label="Allow multiple instances of Battle.net" checked={s().multipleInstances} onChange={(v) => props.set('multipleInstances', v)} /><Hint text={NOT_CAPTURED} /></Row>
        </DialogSection>
      </Match>

      <Match when={props.page === 'downloads'}>
        <DialogSection title="Game Installation">
          <div class="grid gap-2">
            <span class="label uppercase text-secondary">Default install directory</span>
            <Row class="max-w-[516px]">
              <TextField class="flex-1" size="md" readOnly value="C:\Program Files (x86)\" aria-label="Default install directory" />
              <Button size="md">Change</Button>
            </Row>
          </div>
          <div><Button size="md">Scan for Games</Button></div>
          <Checkbox label="Scan for Battle.net games in the background every time Battle.net launches" checked={s().scanInBackground} onChange={(v) => props.set('scanInBackground', v)} />
          <Checkbox label="Automatically create a desktop icon for games during installation" checked={s().desktopIcon}
            onChange={(v) => { props.set('desktopIcon', v); if (!v) props.set('desktopIconAllUsers', false); }} />
          <Checkbox nested label="Create desktop icon for all users on this machine" disabled={!s().desktopIcon}
            checked={s().desktopIconAllUsers} onChange={(v) => props.set('desktopIconAllUsers', v)} />
        </DialogSection>
        <DialogSection title="Game Updates">
          <Checkbox label="Pause updates when I launch a game" checked={s().pauseUpdates} onChange={(v) => props.set('pauseUpdates', v)} />
          <Checkbox label="Notify me when games automatically begin updating" checked={s().notifyUpdates} onChange={(v) => props.set('notifyUpdates', v)} />
        </DialogSection>
        <DialogSection title="Download Limits" class="gap-3">
          <Row>
            <Checkbox class="w-[168px]" label="Latest Updates:" checked={s().limitUpdates} onChange={(v) => props.set('limitUpdates', v)} />
            <TextField class="w-[76px]" inputClass="text-right" size="md" inputMode="numeric" aria-label="Latest updates limit in KB/s"
              disabled={!s().limitUpdates} value={s().updatesLimit} onChange={(v) => props.set('updatesLimit', v.replace(/\D/g, ''))} />
            <span class="body-sm text-secondary">KB/s</span><Hint text={NOT_CAPTURED} />
          </Row>
          <Row>
            <Checkbox class="w-[168px]" label="Pre-release Content:" checked={s().limitPrerelease} onChange={(v) => props.set('limitPrerelease', v)} />
            <TextField class="w-[76px]" inputClass="text-right" size="md" inputMode="numeric" aria-label="Pre-release content limit in KB/s"
              disabled={!s().limitPrerelease} value={s().prereleaseLimit} onChange={(v) => props.set('prereleaseLimit', v.replace(/\D/g, ''))} />
            <span class="body-sm text-secondary">KB/s</span><Hint text={NOT_CAPTURED} />
          </Row>
        </DialogSection>
      </Match>

      <Match when={props.page === 'friends'}>
        <DialogSection title="Friends & Chat">
          <p class="body-sm m-0 text-muted">Not captured yet: this page needs a capture before it can be rebuilt.</p>
        </DialogSection>
      </Match>

      <Match when={props.page === 'voice'}>
        <DialogSection title="Speakers & Headphones">
          <div class="grid max-w-[570px] grid-cols-[280px_minmax(0,1fr)] items-start gap-6">
            <Select variant="filled" label="Output device" value={s().outputDevice} onChange={(v) => props.set('outputDevice', v)}
              options={['System Default Device', 'Speakers (Realtek(R) Audio)', 'Headphones (USB Audio)']} />
            <SliderRow label="Volume"><Slider aria-label="Output volume" value={s().outputVolume} onChange={(v) => props.set('outputVolume', v)} /></SliderRow>
          </div>
        </DialogSection>
        <DialogSection title="Microphone">
          <div class="grid max-w-[570px] grid-cols-[280px_minmax(0,1fr)] items-start gap-6">
            <Select variant="filled" label="Input device" value={s().inputDevice} onChange={(v) => props.set('inputDevice', v)}
              options={['System Default Device', 'Microphone (USB Audio)']} />
            <SliderRow label="Volume"><Slider aria-label="Input volume" value={s().inputVolume} onChange={(v) => props.set('inputVolume', v)} /></SliderRow>
          </div>
          <div><Button size="md">Test Microphone</Button></div>
          <div class="grid max-w-[215px] gap-2">
            <span class="flex items-center gap-2"><span class="label uppercase text-secondary">Transmission mode</span><Hint text={NOT_CAPTURED} /></span>
            <Select variant="filled" aria-label="Transmission mode" value={s().transmission} onChange={(v) => props.set('transmission', v)}
              options={['Open Mic', 'Push to Talk']} />
          </div>
          <div class="grid justify-items-start gap-2">
            <span class="flex items-center gap-2"><span class="label uppercase text-secondary">Toggle mute key</span><Hint text={NOT_CAPTURED} /></span>
            <Button size="md" variant="tertiary" class="w-40">Click to set</Button>
          </div>
        </DialogSection>
      </Match>

      <Match when={props.page === 'notifications'}>
        <DialogSection title="Global Settings">
          <Checkbox label="Show Battle.net notification count in taskbar" checked={s().taskbarCount} onChange={(v) => props.set('taskbarCount', v)} />
          <Checkbox label="Show Battle.net notification toasts" checked={s().toasts} onChange={(v) => props.set('toasts', v)} />
          <div class="ml-6 grid max-w-[512px] grid-cols-2 gap-2">
            <Select variant="filled" aria-label="Toast position" disabled={!s().toasts} value={s().toastCorner} onChange={(v) => props.set('toastCorner', v)}
              options={['Bottom right of screen', 'Top right of screen', 'Bottom left of screen', 'Top left of screen']} />
            <Select variant="filled" aria-label="Toast monitor" disabled={!s().toasts} value={s().toastMonitor} onChange={(v) => props.set('toastMonitor', v)}
              options={['Monitor 1 (Primary)', 'Monitor 2']} />
          </div>
          <Checkbox nested label="Hide toasts when playing a Battle.net game" disabled={!s().toasts} checked={s().hideToastsInGame} onChange={(v) => props.set('hideToastsInGame', v)} />
          <Checkbox nested label="Hide toasts when using any app in full-screen mode" disabled={!s().toasts} checked={s().hideToastsFullscreen} onChange={(v) => props.set('hideToastsFullscreen', v)} />
          <Checkbox label="Play Battle.net notification sounds" checked={s().sounds} onChange={(v) => props.set('sounds', v)} />
          <div class="ml-6 max-w-[240px]"><Slider aria-label="Notification sound volume" disabled={!s().sounds} value={s().soundVolume} onChange={(v) => props.set('soundVolume', v)} /></div>
          <Checkbox nested label="Mute sounds for friend notifications and chats when playing a Battle.net game" checked={s().muteInGame} onChange={(v) => props.set('muteInGame', v)} />
        </DialogSection>
      </Match>

      <Match when={props.page === 'beta'}>
        <DialogSection title="Beta" class="gap-4">
          <p class="body-sm m-0 max-w-[640px]">In the beta, you can try out the latest features we've got in development. If you run into any issues or unexpected behaviors, you can revert to the standard version at any time.</p>
          <p class="body-sm m-0">You can always read the <Link href="#beta-notes">beta patch notes</Link> for a full list of changes</p>
          <div><Button size="md">Switch to Beta</Button></div>
        </DialogSection>
      </Match>

      <Match when={props.page === 'about'}>
        <DialogSection title="Battle.net Applications" class="gap-1">
          <p class="body-sm m-0">Battle.net Version {VERSION}</p>
          <p class="body-sm m-0">Battle.net Update Agent Version 2.41.1.9824</p>
        </DialogSection>
        <DialogSection title="Battle.net Privacy">
          <p class="body-sm m-0">Website: <Link href="#legal" external>Blizzard Legal</Link></p>
        </DialogSection>
      </Match>
    </Switch>
  );
}

function Window(props: { onDone: () => void }) {
  const [page, setPage] = createSignal('app');
  const [s, setS] = createStore<Settings>({ ...defaults });
  const set = <K extends keyof Settings>(k: K, v: Settings[K]) => setS(k, v as never);
  return (
    <>
      <DialogLayout
        nav={<SideNav aria-label="Settings pages" density="dialog" items={pages} current={page()} onSelect={setPage} />}
        navFooter={<span class="body-xs text-muted">{VERSION}</span>}
        footer={<>
          <Button variant="primary" size="md" class="w-24" onClick={props.onDone}>Done</Button>
          <Button size="md" onClick={() => setS(reconcile({ ...defaults }))}>Reset to Defaults</Button>
        </>}
      >
        <Pages page={page()} s={s} set={set} />
      </DialogLayout>
    </>
  );
}

/* Inline at the capture's window size (996×708), for side-by-side comparison. */
export function SettingsFrame() {
  return (
    <DialogFrame title="Settings" class="h-[708px] w-[996px] max-w-full">
      <Window onDone={() => {}} />
    </DialogFrame>
  );
}

export function SettingsDialog(props: { open: boolean; onOpenChange: (open: boolean) => void }) {
  return (
    <Dialog open={props.open} onOpenChange={props.onOpenChange} title="Settings" class="h-[708px] w-[996px] max-w-full">
      <Window onDone={() => props.onOpenChange(false)} />
    </Dialog>
  );
}
