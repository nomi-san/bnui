# Store home

- URL: `https://us.shop.battle.net/en-us?from=root` (logged in)
- Captured: 2026-10-02, viewport 1549×990 (content width 1534 with scrollbar), page height 5779
- Stack: Next.js + Blizzard `blz-*` web components (Lit, shadow DOM) + MUI Autocomplete for search
- The BattleTag was replaced with `Player` in the page before capture

## Files

| File | What |
|---|---|
| `viewport.png` | Top of page, banner open |
| `fullpage.jpeg` | Whole page (the fixed bottom banner renders mid-page, a capture artifact) |
| `viewport-banner-open.png` | Scrolled to cards, countdown banner visible |
| `hover-nav-dropdown.png` | "Warcraft" menu hovered → dropdown open |
| `hover-card.png` | Product card hovered |
| `a11y-snapshot.txt` | Accessibility tree |
| `tokens-root-resolved.json` | **1190 `:root` tokens: the real Battle.net theme** (use these, not `../login/tokens-resolved.json`) |
| `css/*.css` | Next.js stylesheets (`458a6e8e737ef1da.css` = blz base + tokens) |
| `css/<blz-tag>.shadow.css` | Shadow-DOM styles of every component on the page |

## Page structure

```
blz-nav-battlenet         72px   sticky top:-80px (scrolls away), bg #15171e, z 1001
div.navigation            88px   sticky top:0, padding 16px 0, bg #15171e
  └ grid (gap 8): [browse menu 951] [search 354] [balance 180], each 56px tall, bg white/6%, radius 4
header > blz-carousel-beta 1502×424 (slides 1496×360 + indicators)
main
  section "Recommended"   h2 + 5×2 card grid
  section "Featured"      h2 + 5×2 card grid
  section "Trending Now"  h2 + 5×2 card grid
  section "Most Gifted"   h2 + 5×2 card grid     (each section padding-bottom 64)
  section download CTA    562px, padding 64 40, bg image, blz-feature max 1400
blz-announcement-banner   94px   sticky bottom:0, z 50, dismissible
blz-back-to-top-button    40×40  fixed right 24, bottom = banner + 20
footer blz-nav-footer     338px  padding 40
```

### Layout
- App container: `max-width: 1632px; padding: 0 16px; margin: 0 auto`
- Breakpoints (`--view-*`): xs 480 · sm 720 · md 960 · lg 1200 · xl 1400 · xxl 1600 · max 2600
- Section spacing: 64px between sections; h2 → grid: 16px margin; grid gap 24px
- Grid `ul.browsing-card-group-layout--auto`: 5 equal columns at 1502px (281px each), gap 24

## Components

### Top bar (`blz-nav-battlenet`)
- 72px, bg `#15171e`. Logo link 200×72 on the left
- Right: "Download Battle.net", "Support", account dropdown: Object Sans 700 16px white, 48px tall, padding `0 16`, radius 4, leading 24px icon
- Hover: bg `rgba(255,255,255,.05)`, transitions **.1s** (`color, background-color, text-decoration-color, filter, border-color`)
- When scrolled, the top bar slides away (`translateY(-100%)`) and the shop nav sticks at top 0

### Shop nav (franchise menu + search + balance)
- Three panels in a grid with 8px gaps, each 56px tall, bg `rgba(255,255,255,.06)`, radius 4
- Menu item (`blz-menu-link`): padding 16, label **Noto Sans 700 14/21**, `rgba(255,255,255,.72)`, 16px chevron (gap 4)
- **Hover**: label + chevron → `#fff`, item bg +`white/6%`, **dropdown opens on hover** (no click)
- Search: MUI Autocomplete, 24px search icon, placeholder "Search Shop" `rgba(255,255,255,.72)`, 16px text (renders in Roboto; we'd use Noto Sans)
- Balance: same as menu item, dropdown anchored right

### Dropdown menu (`blz-menu`)
- bg `#1a1c23`, border 1px `rgba(255,255,255,.12)`, **radius 8**, 10px below the bar, ~328px wide, padding 12
- Item (`blz-menu-item`): 56px, padding 12, gap 12; 32px game icon; heading Noto Sans 400 14/24 `#fff`; subheading 12/21 `rgba(255,255,255,.72)`
- Optional "NEW" pill: bg `#d00`, Object Sans 700 12 uppercase, padding `4 8`, radius 4

### Hero carousel (`blz-carousel-beta`)
- Config: `autoplay=5000`, `hover-pause`, `transition=smooth`, `loop`, `slide-gap=12`, 1 per view
- Slide (`blz-banner`): 1496×360, radius 4, bg `#22242c`, padding `16 80`, content left + vertically centered
- Readability gradient, auto-generated from the image's median colour: `linear-gradient(45deg, C 20%, transparent 50%), linear-gradient(90deg, C 20%, transparent 50%)`
- Content block 420px wide, centered text: logo 320×168 → heading **Object Sans 700 20/22** white → 16px → primary button (large)
- Arrows: 28×64 tertiary icon buttons inside the slide edges (24px inset), bg `#15171e`, inset ring 2px `rgba(255,255,255,.24)`, radius 4, **opacity 0 until carousel hover**
- Indicators below (margin `10 0 16`, `blz-tab-control variant=dash`): 40×4 bars, 8px gap, inactive `rgba(255,255,255,.48)`, hover `rgba(255,255,255,.72)`, active `#148eff` and 6px tall (accent colour)
- Play/pause: 24×24 tertiary icon button, bottom-left of the slide

### Section header
`h2.blz-heading-text-xl`: Object Sans 700 **24/26** white

### Product card (`blz-card`, vertical)
| Part | Spec |
|---|---|
| Card | 281×456, bg `rgba(255,255,255,.06)`, radius 4, overflow hidden, whole card is a link |
| Media | 16:9 (281×158), image `object-fit: cover`, top corners rounded |
| Badges | absolute top-left, margin 4, gap 4 |
| Content | padding 24, grid |
| Franchise line | 24px franchise icon + 4px gap + Object Sans **500 12/14 uppercase**, letter-spacing .6px, `rgba(255,255,255,.72)`, 2 lines max |
| Title | Object Sans **700 18/20** white, `®` as `<sup>`, margin-top ~4 |
| Callout (optional) | Noto Sans 400 14/20, **`#ffb400`** (warning yellow), margin-top 4 |
| Genre | Noto Sans 400 12/17, `rgba(255,255,255,.72)`, margin-top 4 |
| Price | pinned to bottom (padding-top 24), Object Sans **500 24/29** white; optional "From" label before (margin-right 6) |
| In-card CTA (optional) | full-width primary button (large) under the price |

- **Hover**: bg `white/6%` → `white/12%`, **instant** (no duration set). No lift, shadow, scale or image zoom
- Video cards: `blz-web-video` overlays the media at `opacity 0` → fades in (.2s) on hover

### Badge (`blz-badge`, medium)
| Level | bg | text |
|---|---|---|
| urgent (PRE-PURCHASE) | `#d00` | `#fff` |
| positive (NEW) | `#6cdb00` | `#111218` |
| neutral | `#1a1c23` | `#fff` |

Noto Sans 700 14/21 uppercase, letter-spacing .6px, padding `2 8`, border 1px `rgba(255,255,255,.24)`, radius 4

### Button (`blz-button`): store version
The hover is a **ring that fades in**: `::after { box-shadow: inset 0 0 0 2px RING; opacity: 0 → 1; transition: opacity .2s ease-in-out }`. Text has `text-shadow: 0 1px 3px` (transparent by default).

| Variant | bg | hover | pressed | disabled |
|---|---|---|---|---|
| primary | `#0074e0` | same bg + ring `white/36%` (verified live) | bg `#003f7a`, text `white/72%`, ring `white/18%` | bg `#003f7a`, text `white/48%` |
| secondary | `white/12%` | same bg + ring `white/36%` | bg `white/6%`, ring `white/18%` | bg `white/6%` |
| tertiary | transparent + ring `white/24%` | ring `white/36%` | ring `white/18%`, text `white/72%` | ring `white/12%` |
| ghost | none, text `#148eff` | text `#47a6ff` | text `white/72%` | – |

| Size | height | padding | font | radius | ring |
|---|---|---|---|---|---|
| small | 24 | `4 16` | 500 12/14 | 3 | 1px |
| medium | 32 | `6 24` | 700 14/17 | 4 | 2px |
| large | 40 | `6 32` | 700 16/19 | 4 | 2px |

All buttons use Object Sans. ⚠ This differs from the login toolkit, where the primary hover ring is `#47a6ff`. The store uses neutral white rings for every variant.

### Countdown banner (`blz-announcement-banner` + `blz-countdown-timer`)
- Sticky bottom, 94px, bg `#22242c` + full-bleed background image (`object-fit: cover`) + side gradients `linear-gradient(90deg / 270deg, #22242c 20%, transparent 50%)`
- Padding `16 40`; inner max-width 1400; layout `spaced-out` (text left, timer middle, CTA pushed right)
- Left: 64×48 game icon, gap 16, then heading **Object Sans 700 20/22** white + subheading Noto Sans 400 16/17 `rgba(255,255,255,.48)` (margin-top 6, max-width 450, `text-wrap: balance`)
- Timer: 4 tiles; each number is a **40×40 white box, radius 2, Object Sans 700 24/26, text `#111218`**; `:` separators Object Sans 700 18 white, tile pitch 56px
- CTA: primary button (large)
- Close: 24×24 ghost icon button, top-right (8px), `rgba(255,255,255,.72)`
- Dismiss: container gets `.closed` → `height 0; opacity 0; visibility hidden`, host fades opacity over .3s. Stays closed for the session

### Download CTA (`blz-feature`)
- Full-bleed section, padding `64 40`, background image; inner 12-column grid, gap 80, max 1400
- Media (laptop screenshot) 7 cols on the left, text 5 cols on the right, vertically centered
- Heading **Object Sans 700 48/53** white → 16px → description Noto Sans 400 20/30 `rgba(255,255,255,.72)` → 32px → primary + secondary buttons (large, gap 8)
- Extras line: Noto Sans 14/21 `white/72%`, inline links `#148eff` underlined

### Back-to-top
40×40 tertiary icon button, fixed `right: 24px; bottom: banner + 20px`, bg `#15171e`, ring `white/24%`, `transition: bottom .3s`. Hidden near the top of the page.

## Motion summary
| What | Duration | Easing |
|---|---|---|
| Global `*` (color, background-color, border, filter) | .2s | ease-out `cubic-bezier(0,0,.2,1)` |
| Button hover ring | .2s (opacity) | ease-in-out `cubic-bezier(.5,0,.5,1)` |
| Card hover bg | **0s** | – |
| Nav bar links | .1s | ease |
| Banner dismiss / back-to-top move | .3s | ease-out |
| Carousel autoplay | 5s per slide, pauses on hover | smooth scroll |

For our build ("fast hover, minimal animation"): use **0–100ms** for hover colour changes, keep the button ring fade at ~100ms, and drop everything else.

## Tokens: the Battle.net theme (`tokens-root-resolved.json`)

### Physical palette (`--battle-net-color-physical-*`): base for the Tailwind theme
| Scale | Values |
|---|---|
| blue | 100 `#e0f0ff` · 200 `#add8ff` · 300 `#7abfff` · 400 `#47a6ff` · **500 `#148eff`** · **600 `#0074e0`** · 700 `#005aad` · 800 `#003f7a` |
| gray | 50 `#ebecef` · 100 `#d5d7dd` · 200 `#5a5d70` · 300 `#292b33` · 400 `#22242c` · 500 `#1a1c23` · **600 `#15171e`** (page) · 700 `#111218` |
| white (alpha %) | 3 · 6 · 12 · 18 · 24 · 36 · 48 · 60 · 72 · 84 · 100 |
| black (alpha %) | 6 · 12 · 24 · 48 · 60 · 72 · 100 |
| alert | green 500 `#6cdb00` / 600 `#54a800` · red 500 `#d00` / 600 `#b10000` / 800 `#580000` / 900 `#420000` · yellow 500 `#ffb400` / 600 `#cc9000` |
| elemental (accents) | electro `#74eef5` `#00e6f2` `#00c6d7` · mana `#fcb4e0` `#f87dcc` `#f23b8e` · pyro `#ffb54c` `#ff9500` `#fa7900` |

### Semantic roles (most used)
- Page bg `#15171e`, secondary page bg `#1a1c23`, content bg `#111218`
- Text: heading `#fff`, body `white/84%`, info/label `white/72%` or `white/60%`, description `white/48%`, placeholder `white/36%`
- Link `#148eff` → hover `#47a6ff`
- Card/backplate `white/6%` → hover `white/12%`
- Input border `white/36%` → hover `white/48%` → focus `#fff`
- Focus ring: inner `#111218` + outer `#fff`

### Type (desktop)
| Role | Font |
|---|---|
| title lg / md / sm | Object Sans 700 48/53 · 40/44 · 32/35 |
| heading xxl … xxs | Object Sans 700 32/35 · 24/26 · 20/22 · 18/20 · 16/19 · 14/17 · 12/14 |
| subheading lg / md | Object Sans 500 14/15 · 12/13, letter-spacing .6px, uppercase |
| body xl … xs | Noto Sans 400 20/30 · 18/27 · 16/24 · 14/21 · 12/18 |
| button lg / md / sm | Object Sans 700 16/19 · 700 14/17 · 500 12/14 |

### Other scales
- Radius: xs 2 · sm 3 · md **4** (default) · lg 6 · xl **8** (menus) · rounded 100
- Shadow (all `#00000080`): xs `0 1 3` · sm `0 3 6` · md `0 3 12` · lg `0 6 24` · xl `0 12 48`
- Grid gaps: xxxs 4 · xxs 8 · xs 16 · sm/md 24 · lg 48 · xl 80
- Content spacing: xs 6 · sm 10 · md 16 · lg 24
- Z-index: below -1 · base 0 · above 1 · docked 4 · fixed 10 · overlay 50 · menu 999 · modal 10000 · toast 11000
