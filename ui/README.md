# BNUI · SolidJS + Tailwind 3

The BNUI design system as SolidJS components styled with Tailwind CSS 3. Every value comes from [`../design-system/project/tokens.json`](../design-system/project/tokens.json), the same file behind the Design System artifact and the Claude Design bundle.

First slice: the token foundation plus the controls of the Battle.net desktop app's **Settings window**, assembled into a working replica of it ([`../capture/app-settings/`](../capture/app-settings/)).

## Run it

```sh
pnpm install
pnpm dev        # http://localhost:5173  (gallery + Settings window)
pnpm build      # typecheck + production build to dist/
pnpm preview    # serve dist/ on http://localhost:4173
```

Open `/#/settings` for the Settings window alone at the captured size (996×708), for side-by-side comparison with the screenshots.

## Tokens → Tailwind

[`tailwind/bnui-preset.cjs`](tailwind/bnui-preset.cjs) reads `tokens.json` at build time. There is no generated token file to keep in sync. It writes the tokens as CSS variables and points every Tailwind scale at them:

| Family | Classes |
|---|---|
| Colour | `bg-surface-page`, `bg-fill`, `bg-fill-strong`, `border-line-strong`, `bg-accent-fill`, `text-accent`, `text-success` … (every colour token by name); text shortcuts `text-primary`, `text-body`, `text-secondary`, `text-tertiary`, `text-muted`, `text-disabled` |
| Spacing | `p-6`, `gap-2`, `ml-0.5` … (`space-*` tokens); sizes `h-control-md`, `min-h-control-lg`, `size-control-pill`, `max-w-content-max`, `w-sidebar-width` |
| Radius | `rounded-xs` 2, `rounded-sm` 3, `rounded` / `rounded-md` 4, `rounded-panel` 5, `rounded-lg` 6, `rounded-xl` 8, `rounded-full` |
| Shadow and rings | `shadow-sm`, `shadow-md`, `shadow-tile`, `shadow-lg`, `shadow-sticky`; `shadow-ring-primary-hover`, `shadow-ring-secondary-hover`, `shadow-ring-subtle-hover`, `shadow-ring-tertiary`, `shadow-ring-focus` |
| Motion | `duration-fast` (default), `duration-medium`, `duration-slow`, `duration-instant`; `ease-out` (default), `ease-in-out`; `animate-fade-in` |
| Layers | `z-docked`, `z-sticky`, `z-overlay`, `z-menu`, `z-modal`, `z-toast` |
| Type | `font-display`, `font-body`; whole-font classes `display-xl` … `heading-md` … `label`, `button-md`, `price`, `body-sm` … `body-xs` (add `uppercase` to `eyebrow`, `label`, `tab`) |

**Accent theme:** `data-theme="oc-blue|oc-indigo|oc-violet|oc-grape|oc-pink|oc-teal|oc-orange"` on `<html>` or any container swaps only the accent tokens. Bnet Blue is the default.

**Motion:** hovers ease with `duration-fast`. Focus rings and press states snap, as in the native app: each control carries `focus-visible:duration-0 active:duration-0`. `data-motion="instant"` on `<html>` or a container sets every duration to 0ms. `prefers-reduced-motion` does the same.

Lay out your own pages with these classes only; never hard-code a colour, size or duration.

## Components

All in [`src/components/`](src/components/), exported from `src/components/index.ts`. The interactive ones sit on [Kobalte](https://kobalte.dev) for keyboard behaviour, focus management and ARIA.

| Component | Built on | Notes |
|---|---|---|
| `Button` | `<button>` / `<a href>` | `variant` primary · secondary · tertiary · ghost; `size` sm 24 · md 32 · lg 40 · xl 56; `block` |
| `IconButton` | `<button>` | `variant` filled · ghost; `size` sm 24 · pill 26 · md 32 · lg 40; `aria-label` required |
| `Link` | `<a>` | `variant` inline · plain · subtle; `external` adds the out-of-box icon |
| `TextField` | Kobalte TextField | label, description, `error` (warning border), `disabled`, `readOnly`, `size` md · lg, `search` |
| `Select` | Kobalte Select | `variant` outlined · filled; list on the menu surface, current option with a 2px accent bar |
| `Checkbox` | Kobalte Checkbox | accent tick, no fill; `nested` indents a dependent option |
| `RadioGroup` | Kobalte RadioGroup | 2–5 options, 12px accent dot |
| `Slider` | Kobalte Slider | 3px track, 16px thumb, hover halo; arrow keys, Home/End |
| `SideNav` | `<nav>` + buttons | `density` default (web side nav) · dialog (native Settings nav) |
| `Dialog` | Kobalte Dialog | modal: scrim + blur, focus trap, Escape, focus returns to the opener; parts `DialogLayout`, `DialogSection`, `DialogFooter`, and `DialogFrame` for a static window |

The demos ([`src/demos/`](src/demos/)) show every state: `Gallery.tsx` (component gallery) and `SettingsWindow.tsx` (the Settings window with working state, Reset to Defaults and dependent options).

## Where it follows the native app instead of the design-system cards

The Settings replica was pixel-checked against the captures and the app's own Qt stylesheet ([`../capture/app-qt/NOTES.md`](../capture/app-qt/NOTES.md)). Three parts follow the native app where the design-system cards differ:

- **`SideNav density="dialog"`** matches the native Settings nav: 36px rows 4px apart, 14px labels in `text-tertiary`, `fill` hover and current, and a 2×32px accent bar rounded on its outer edge. The Dialog card in the design system still shows the web side nav (40px rows, 4px bar).
- **`DialogLayout footer`** puts Done / Reset to Defaults under the content column, with the nav running full height, as in the app. `DialogFooter` (full width) stays for confirmations.
- **Read-only `TextField`** drops to a `line-subtle` border and `text-secondary`, like the native path field.

## Not in this slice

- Tooltip: ⓘ hints use the native `title` until the Tooltip component lands. Only the "Clear Saved Login Info" text was captured; the others say so.
- The Voice Chat level meter, the Notifications accordion, and the Friends & Chat page (not captured).
- The other 27 design-system components (cards, carousels, tabs, menus, toasts …) and the store-home page, which come in later slices.
