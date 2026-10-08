import { createSignal, type ParentProps } from 'solid-js';
import {
  Button, Checkbox, IconButton, IconClose, IconDownload, IconGear, IconPlay, IconSearch, Link, RadioGroup, Select,
  SideNav, Slider, TextField, IconBell, IconFriends, IconGame,
} from '../components';

const Section = (props: ParentProps<{ title: string; note?: string }>) => (
  <section class="grid gap-4 border-t border-line pt-8 first:border-t-0 first:pt-0">
    <div class="grid gap-1">
      <h2 class="heading-lg m-0 text-primary">{props.title}</h2>
      {props.note && <p class="body-sm m-0 text-secondary">{props.note}</p>}
    </div>
    {props.children}
  </section>
);
const Cap = (props: ParentProps) => <span class="eyebrow uppercase text-muted">{props.children}</span>;
const Row = (props: ParentProps<{ class?: string }>) => <div class={`flex flex-wrap items-center gap-4 ${props.class ?? ''}`}>{props.children}</div>;

export function Gallery() {
  const [nav, setNav] = createSignal('downloads');
  const [volume, setVolume] = createSignal(50);
  return (
    <div class="grid gap-10">
      <Section title="Button" note="Hover adds an inset ring (100ms); focus ring and press snap.">
        <Row>
          <Button variant="primary">Buy Now</Button>
          <Button>Learn More</Button>
          <Button variant="tertiary">Visit Shop</Button>
          <Button variant="ghost">Compare</Button>
          <Button variant="primary" disabled>Purchased</Button>
          <Button disabled>Unavailable</Button>
        </Row>
        <Row>
          <Button variant="primary" size="sm">Small</Button>
          <Button variant="primary" size="md">Done</Button>
          <Button size="md">Reset to Defaults</Button>
          <Button variant="primary" size="xl"><IconPlay /> Install</Button>
          <Button href="#store" size="md"><IconDownload /> Link button</Button>
        </Row>
      </Section>

      <Section title="IconButton">
        <Row>
          <IconButton aria-label="Settings"><IconGear /></IconButton>
          <IconButton size="lg" aria-label="Friends"><IconFriends /></IconButton>
          <IconButton size="pill" aria-label="Search"><IconSearch /></IconButton>
          <IconButton variant="ghost" aria-label="Notifications"><IconBell /></IconButton>
          <IconButton variant="ghost" size="sm" aria-label="Close"><IconClose /></IconButton>
          <IconButton disabled aria-label="Disabled"><IconGear /></IconButton>
        </Row>
      </Section>

      <Section title="Link">
        <p class="body-md m-0 max-w-[640px]">
          By continuing, you acknowledge our <Link href="#privacy" external>Privacy Policy</Link>. Lost access?{' '}
          <Link href="#recover" variant="plain">Forgot password?</Link>{' '}
          <Link href="#legal" variant="subtle">Legal</Link>
        </p>
      </Section>

      <Section title="TextField">
        <div class="grid max-w-[880px] grid-cols-2 gap-6">
          <TextField label="Email or phone" placeholder="Email or Phone" />
          <TextField label="Authenticator code" placeholder="XXXX-XXXX-XXXX-XXXX" description="Find it in the Battle.net Authenticator app." />
          <TextField label="BattleTag" defaultValue="Player#0000" error="That BattleTag is already in use." />
          <TextField label="Disabled" placeholder="Not available" disabled />
          <TextField search placeholder="Search games" aria-label="Search games" />
          <TextField size="md" label="Read-only, 32px" readOnly value="C:\Program Files (x86)\" />
        </div>
      </Section>

      <Section title="Select" note="The open list is the menu surface; the current option has a 2px accent bar.">
        <div class="grid max-w-[880px] grid-cols-2 gap-6">
          <Select label="Game version" defaultValue="Diablo IV" options={['Diablo IV', 'Diablo IV: Vessel of Hatred', 'Public Test Realm']} />
          <Select variant="filled" label="On startup, view" defaultValue="Home Page" options={['Home Page', 'Last Viewed Game Page']} />
          <Select variant="filled" aria-label="Sort by" defaultValue="Featured" options={['Featured', 'Price: Low to High', 'Price: High to Low', 'Release Date']} />
          <Select label="Disabled" disabled defaultValue="Americas" options={['Americas', 'Europe', 'Asia']} />
        </div>
      </Section>

      <Section title="Checkbox and RadioGroup">
        <div class="grid max-w-[880px] grid-cols-2 gap-6">
          <div class="grid gap-3">
            <Cap>Checkbox</Cap>
            <Checkbox label="Pause updates when I launch a game" defaultChecked />
            <Checkbox label="Launch Battle.net when I start my computer" />
            <Checkbox nested label="Launch Battle.net minimized to the system tray" disabled />
            <Checkbox nested label="Create desktop icon for all users" defaultChecked disabled />
          </div>
          <RadioGroup label="Login region" defaultValue="asia"
            options={[{ value: 'americas', label: 'Americas' }, { value: 'europe', label: 'Europe' }, { value: 'asia', label: 'Asia' }, { value: 'china', label: 'China', disabled: true }]} />
        </div>
      </Section>

      <Section title="Slider">
        <div class="grid max-w-[880px] grid-cols-2 gap-6">
          <Slider label="Volume" showValue value={volume()} onChange={setVolume} />
          <Slider label="Disabled" defaultValue={30} disabled />
        </div>
      </Section>

      <Section title="SideNav" note="Current item: surface-highest + 4px accent bar. Dialog density shown on the right.">
        <div class="grid max-w-[880px] grid-cols-[300px_240px] gap-10">
          <SideNav aria-label="Account" current={nav()} onSelect={setNav}
            items={[{ id: 'overview', label: 'Account Overview', icon: IconGear }, { id: 'downloads', label: 'Downloads', icon: IconDownload }, { id: 'games', label: 'Games', icon: IconGame, disabled: true }, { id: 'friends', label: 'Friends', icon: IconFriends, divider: true }]} />
          <div class="rounded-md bg-surface-sunken px-3 py-5">
            <SideNav aria-label="Settings" density="dialog" current={nav()} onSelect={setNav}
              items={[{ id: 'overview', label: 'App', icon: IconGear }, { id: 'downloads', label: 'Downloads', icon: IconDownload }, { id: 'games', label: 'Game Settings', icon: IconGame, disabled: true }]} />
          </div>
        </div>
      </Section>
    </div>
  );
}
