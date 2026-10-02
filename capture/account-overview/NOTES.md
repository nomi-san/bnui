# Account Overview (dashboard)

- URL: `https://account.battle.net/overview`
- Captured: 2026-10-02 at 1888px wide, page height 1451
- **Different app**: Vue + Bootstrap 5 + the **Meka** design system (`meka-*`). Only the nav/footer are `blz-*` web components.
- Personal data replaced in the page before capture: BattleTag → `Player#1234`, name → `J*** D**`, email → `p*******r@example.com`

## Files

| File | What |
|---|---|
| `fullpage.png` | Whole page (masked) |
| `viewport-hover-sidenav.png` | "Account Details" sidebar item hovered |
| `a11y-snapshot.txt` | Accessibility tree (masked) |
| `tokens-meka-resolved.json` | 284 `:root` tokens: Meka (`--meka-*`) + Bootstrap (`--bs-*`) |
| `css/app.css` | Account app stylesheet (Bootstrap + page CSS) |
| `css/inline-meka.css` | Meka component CSS (buttons, utils) + card/side-nav rules |

## Key finding: one palette, three component systems
`--meka-color-bnet-*` is **the same palette** as the store's `--battle-net-color-physical-*` (blue 100–800, gray 50–700, white/black alphas, green/red/yellow). The colour layer is shared across login (toolkit), store (`blz`) and account (Meka). Only component details differ:

| | Login toolkit | Store `blz-button` | Account `meka-button` |
|---|---|---|---|
| Primary bg | `#0074e0` | `#0074e0` | `#0074e0` (blue-600) |
| Primary hover | 2px border `#47a6ff` | inset ring `white/36%` (fades in) | inset ring 2px **`#47a6ff`** (blue-400) |
| Primary active | bg `#003f7a`, text `white/60%` | bg `#003f7a` | bg `#003f7a` (blue-800), ring `#005aad`, text `white/60%` |
| Secondary | `white/12%` → hover `white/6%` + `white/18%` ring | `white/12%` + ring `white/36%` | `white/12%` → ring 2px `white/18%`; active bg `white/6%` |
| Tertiary | transparent + 1px `white/24%` | transparent + ring `white/24%` | bg `#15171e` + 1px ring `white/24%` → 2px `white/36%` |
| Transition | .2s bg/border/color | .2s opacity (ring) | **box-shadow 200ms ease-out** |

→ Two of three systems use an **accent-coloured hover ring** (light accent on accent fill). That suits a swappable accent: `ring = accent-400` over `bg = accent-600`.

Meka button sizes: small · medium · large (`10px 32px`, 16/20, min-height 40) · extra-large (`16px 40px`, 20/24); square icon variants. Radius 4. Font Object Sans 700.

## Layout
```
body bg #15171e + background-xl.svg (purple/blue haze at top, full-bleed)
main.main-container   max 1600, padding 60 40 0 (centred like the store container)
 ├ sidebar 300px (sticky top 20)
 └ content (flex 1)     h1 → card grid
```
- h1: Object Sans 700 **40/44** (Meka header-2)
- Card grid: Bootstrap `row` (gutter 24 = col padding 12), `col-12 col-xl-6` → 2 columns ≥1200px, 1 below; row gap 30 (col margin-top)

## Components

### Sidebar navigation (vertical)
- 300px, items 50px tall, padding `14px 20px 13px 16px`, Noto Sans 16/20 white
- 20px line icon + 15px gap
- Groups separated by `hr`: 1px `white/12%`, margin `5px 20px`
- **Active**: bg `#292b33` (gray-300), **border-left 4px `#148eff`**, radius 4
- **Hover** (non-active): bg `#22242c` (gray-400), white, radius 4. No left bar
- Rest: border-left 4px transparent (keeps text aligned)
- Last item "Download Battle.net" styled as a link (`#148eff` bold) with an external-link icon

### Dashboard card (`.blz-card`, Meka)
- Two-tone: **header** bg `#22242c`, padding `32px 40px`, radius `5 5 0 0`; **body** bg `#1a1c23`, padding `27px 40px 32px`, radius `0 0 5 5`
- Header row: h2 Object Sans 700 **20/24** (left) + **link with chevron** (right): Noto Sans 700 16/24 `#148eff`, underlined, 10×16 chevron icon
- Full height in grid (`height: 100%`); no shadow, no border
- Variant: `default-payment-card` gets a 4px green (`#70d929`) left border

### Form: code input + button
- Input: height 42, padding 8, bg **`#111218`** (gray-700), border 1px `white/36%`, radius 4, Noto Sans 16/24; placeholder `white/60%`; `transition: border-color .2s ease-out`
- Primary `meka-button--large` beside it (gap 24)

### Key-value list ("Your Information")
- Bootstrap row per item: label col-4, Noto Sans **14/20 `white/72%`**; value col-8, Noto Sans 16/24 white
- Row pitch ~40px; inline actions are links (`#148eff` bold underlined)
- Copy-to-clipboard icon (16px, `#148eff`) after the BattleTag

### Stat value
- Balance: Noto Sans **24/32 `#6cdb00`** (green-500)

### Progress ring (security checkup)
- 161px circle, track `white/12%`, fill `#0074e0` → **`#6cdb00` when complete** (CSS clip/rotate technique, 1.8° per %)
- Inner disc 144px bg `#1a1c23` (≈ 8.5px ring)
- Value Object Sans 700 **40/44**; label "COMPLETE" Object Sans 700 14/16 uppercase, letter-spacing .7px, margin-top 8
- Build note: use an SVG circle with `stroke-dasharray` instead

### Checklist
- 36px circular status icons: done = **green `#6cdb00` check**, todo = `white/12%` plus
- Text Noto Sans 16 / line-height 36; todo items are links (`#148eff` bold underlined)

### Empty state
- Centred Noto Sans 16/24 white, padding `64px 0 80px`

## Typography scale (Meka)
| Token | Size |
|---|---|
| display header-1 … 9 | 48/52 · 40/44 · 32/36 · 24/28 · 20/24 · 18/22 · 16/20 · 14/18 · 12/16 (Object Sans 700) |
| body large / base / small / xs | 18/28 · 16/24 · 14/20 · 12/18 (Noto Sans) |

Slightly different line-heights from the store (`heading-xl` 24/26 vs Meka 24/28). Pick one scale for the build (recommend the store's `semantic-*`).
