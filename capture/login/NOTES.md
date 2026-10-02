# Login page — capture

- URL: `https://kr.account.battle.net/login/en/?...&app=shop` (OAuth login for us.shop.battle.net)
- Captured: 2026-10-02, viewport 1549×990
- Theme classes: `html.bnet-next`, `body.tk-bnet-next.login-template`

## Files

| File | What |
|---|---|
| `viewport.png`, `fullpage.png` | Screenshots |
| `hover-continue-btn.png` | Continue button, hovered |
| `a11y-snapshot.txt` | Accessibility tree (structure) |
| `css/bnet-next-web.css` | Toolkit theme stylesheet (form controls, buttons, links) |
| `css/login-global.css` | Login page layout stylesheet |
| `css/*.shadow.css` | Footer web-component styles (`blz-nav-footer` + children) |
| `tokens-raw.json` | Every `--token` definition with its unresolved value + selector |
| `tokens-resolved.json` | 1134 tokens resolved to final values on `blz-nav-footer` |
| `login-rules*.txt` | Filtered CSS rules for the login elements |

## Layout

Single centered column, **416px** wide, top-aligned (~152px from top). Page bg `#15171e`.

| # | Element | Spec |
|---|---|---|
| 1 | Logo | SVG background, 240×40 (`logo-horizontal-color-light.svg`) |
| 2 | Heading "Log in or sign up" | Object Sans 700, 32/36, `#fff`, centered, margin `40 0 24` |
| 3 | Email input | see **Input** |
| 4 | "Forgot email?" link | margin-top 16, see **Link** |
| 5 | Continue button | full width, margin-top ~45, see **Primary button** |
| 6 | Privacy notice | Noto Sans 400 14/20, `rgba(255,255,255,.6)`; inline link bold, same color, external icon (FA `\f08e`, .75em) after |
| 7 | "OR" divider | Noto Sans 700 14/21 uppercase, `rgba(255,255,255,.6)`; 1px lines `rgba(255,255,255,.18)` either side with 20px gap; margin `32 auto 20` |
| 8 | Social login grid | 290px container, flex-wrap centered, 4 per row, see **Social buttons** |
| 9 | Footer | `blz-nav-footer` web component (links row, divider, logo + legal, social icons) |

## Components

### Input (text)
- 40px tall, padding `0 12px`, radius 4px, bg `#171920`, text `#fff` Noto Sans 16/24
- Placeholder `rgba(255,255,255,.6)`
- Border 1px: default `rgba(255,255,255,.36)` → hover `rgba(255,255,255,.84)` → focus `#148eff` → hover+focus `#7abfff`
- Transition: `border-color, background-color, box-shadow .2s`
- Selection bg `#47a6ff`

### Primary button (`.btn-primary`)
- 40px tall, padding `8px 24px`, radius 4px, Object Sans 500 16/20, `#fff`
- bg `#0074e0`, border 2px transparent
- **hover/focus**: same bg, border → `#47a6ff` (border ring, no bg change) — verified live
- **active**: bg `#003f7a`, text `rgba(255,255,255,.6)`, border `#005aad`
- **disabled**: bg `#003f7a`, text `rgba(255,255,255,.6)`, no pointer events
- Transition: `background-color, border-color, color .2s`

### Secondary / tertiary buttons (in the toolkit, not shown on this page)
- `.btn` / `.btn-secondary`: bg `rgba(255,255,255,.12)` → hover bg `.06` + border `rgba(255,255,255,.18)`; active text `.6`
- `.btn-tertiary`: transparent, 1px border `rgba(255,255,255,.24)` → hover 2px border

### Link
- Toolkit `a`: `#148eff` → hover/focus `#47a6ff`, `transition: color .2s`, no underline
- Form links are Noto Sans 700 14/20

### Social buttons
48×48, radius 4, margin 12 (24px between buttons), icon ~17×18 centered (SVG bg). Hover = darker bg, no transition beyond `.btn`'s `.2s`.

| Provider | bg | hover |
|---|---|---|
| Google / Apple / Steam | `#ffffff` | `#cecece` |
| Facebook | `#1877f2` | `#1860b7` |
| Discord | `#5865f2` | `#374098` |
| Xbox | `#107c10` | `#0a4f0a` |
| PlayStation | `#0070cc` | `#00439c` |
| Nintendo | `#e60012` | `#b3000e` |

### Footer (`blz-nav-footer`)
- Top row links: Object Sans 700 14px, white, 48px tall hit area
- Bottom legal links: BN Noto Sans 400 14px; copyright 12px `rgba(255,255,255,.7)`, "trademarks" underlined (offset 1px)
- Social icon buttons 52×40 (round bg), hover bg `rgba(255,255,255,.1)`
- Locale selector: globe icon `#66c4ff` on hover/open, label → white
- All nav hovers: `color, background-color, text-decoration-color, filter, border-color .1s ease`; press = `translateY(1px)`

## Design token system (Blizzard `blz` web components)

The footer ships the full Blizzard design system as CSS variables in three layers: **global** (raw scales), then **semantic** (named roles), then **component** (`--nav-*`, `--navbar-*`, `--button-*`, …). See `tokens-resolved.json`.

### Blues: three families seen so far
| Source | Values |
|---|---|
| Login toolkit (`bnet-next`) | `#0074e0` button · `#148eff` link/focus · `#47a6ff` hover · `#7abfff` · `#005aad` · `#003f7a` pressed |
| Nav/footer theme (`--nav-color-primary-*`) | 500 `#009dff` · 600 `#33b1ff` · 700 `#66c4ff` · inverse `#0074e0`; Battle.net button `#0074e0` → hover `#148eff` |
| Generic blz DS (`--global-color-primary-*`) | 300 `#38a8ff` · 400 `#0592ff` · 500 `#0076d1` · 600 `#00599e` · 700 `#003c6b` |

**`#0074e0` / `#148eff` / `#47a6ff`** is the shared Battle.net brand blue. Confirm against the shop pages.

### Neutrals
- Backgrounds: login page `#15171e`, input `#171920`, toolkit default `#1c1e26`
- Nav background ramp: `#0a0d15` → `#151c28` → `#232a39` → `#323a48`
- Content (white alpha): .05 · .10 · .12 · .15 · .30 · .50 · .70 · .80 · .90 · 1
- Darken (black alpha): .05 · .10 · .15 · .30 · .50 · .70 · .90 · 1

### Status
error `#f31d77` / `#f87cb0` · success `#00ff94` / `#66ffbf` · warning `#ffbb33` / `#ffdd99`

### Scales
- **Size/space** (`--global-size-*`): 2 4 6 8 10 12 14 16 18 20 24 26 28 30 32 36 40 48 56 60 64 72 80 88 92 100
- **Radius**: xs 2 · sm 3 · md 4 (default for actions) · lg 6 · xl 8 (nav buttons/menus) · rounded 100
- **Font size**: 10 12 14 16 18 20 24 30 32 36 40 48 60
- **Shadow** (all `rgba(0,0,0,.3)`): xs `0 1 3` · sm `0 4 8` · md `0 5 15` · lg `0 10 24` · xl `0 15 35`
- **Motion**: fast `.1s` · medium `.2s` · slow `.3s`; ease-out `cubic-bezier(0,0,.2,1)`, ease-in-out `cubic-bezier(.5,0,.5,1)`

### Fonts
- **Object Sans** 400/500/700: display, headings, buttons, nav (`--nav-font-default`)
- **Noto Sans** (a.k.a. "BN Noto Sans") 400/700: body, inputs, small text (`--nav-font-accent`)
- **Font Awesome 5 Pro**: icons (external link, etc.)
- The blz defaults (Roboto/Montserrat) are overridden by the Battle.net theme and not used.
- ⚠ Object Sans and Font Awesome Pro are commercial fonts. Decide on licensing or substitutes before shipping.

## Notes for our build
- Hover speed reference: the nav uses **.1s**, form controls **.2s**. For "fast hover", use .1s everywhere and only animate color/bg/border.
- Primary button hover is a **border ring**, not a bg shift. Good fit for accent swapping (one accent shade for the ring).
