# Brand / family page

- URL: `https://us.shop.battle.net/en-us/family/call-of-duty` (parent of the product page)
- Captured: 2026-10-02 at a **wider window: 1888px** (content width 1873), page height 12021
- No new web components. This page is about **container behaviour and page composition**. Components are specified in `../store-home/NOTES.md` and `../product-detail/NOTES.md`.
- The BattleTag was replaced with `Player` before capture

## Files

| File | What |
|---|---|
| `viewport-1888.png` | Top of page at 1888px: content centred, 120px side margins |
| `fullpage-1888.jpeg` | Whole page |
| `hover-tab-content-hub.png` | Scrolled: sticky shop nav + breadcrumb + tabbed content hub (tab hovered) |
| `a11y-snapshot.txt` | Accessibility tree |
| `css/page-rules.txt` | Matched layout rules (franchise bar, card groups, content hub) incl. media queries |

## Container: one rule for everything

```css
.app-container {
  width: 100%;
  max-width: calc(1600px + var(--global-size-200) * 2); /* 1632 */
  padding-inline: var(--global-size-200);              /* 16px */
  margin-inline: auto;
}
```
- **Content max width = 1600px**, centred; 16px gutters below that
- At 1873px: `margin-inline: 120.5px`, content x = 137 → 1737
- The top bar (`ul[part=bar]` inside `blz-nav-battlenet`), shop nav, breadcrumb, hero and every section use the same container, so all left edges line up
- Full-bleed (100vw): page bg, sticky nav/breadcrumb backgrounds, download-CTA background, footer background
- Inside the container (1600px): section dividers, hero, cards, everything else
- Tailwind mapping: `container` with `max-width: 1632px; padding: 0 16px; margin: 0 auto` (or `max-w-[1600px] mx-auto` inside `px-4`)

## Sticky stack (when scrolled)
| Layer | top | height | z | bg |
|---|---|---|---|---|
| top bar | slides away | 72 | 1001 | `#15171e` |
| shop nav | 0 | 88 (16 + 56 + 16) | – | `#15171e` |
| breadcrumb bar (`nav.navigation-tertiary-nav`) | **88px** | 49 | 999 | `#15171e` |
| section header column | **150px** | – | – | none |

Each sticky layer has an opaque page-colour background, so content scrolls cleanly underneath.

## Page composition

```
breadcrumb
hero carousel (blz-carousel-beta, same as home: 1600×360, 3 slides)
franchise logo bar (centred tiles)
section × N  ── padding 64 0, border-bottom 1px white/18%
   ├ [header 320px, sticky] h2 + blurb
   └ [content 1280px] cards (layout depends on item count)
```

### Franchise logo bar (sub-brand switcher)
- Centred row (wraps), **gap 24**, padding-top 16
- Tile: **200 × 112.5 (16:9)**, bg `#1a1c23` (`background-info-primary`), radius 4, logo `object-fit: contain`, padding `6px 16px`
- Hover: bg → `white/12%` (`background-action-secondary-hover`), .2s
- Small variant (not on this page): 40×40 icons, hover `transform: scale(1.2)` .2s
- Below 720px tiles are 72px tall; below 1200px the bar stacks vertically

### Section with side header (`.browsing-card-group`)
- `grid-template-columns: 320px 1280px` (header | content)
- Header: padding `10px 40px 10px 0` → content 272px; **`position: sticky; top: 150px`**
  - h2 `heading-xl` Object Sans 700 24/26 white
  - blurb Noto Sans 400 16/24 `white/72%`, margin `8 0`
- Content: `ul` flex-wrap with negative-margin gutters (`margin: 16px 0 -24px -24px`, `li { margin: 0 0 24px 24px }`), so **gutter 24**
- Sections: `padding: 64px 0; border-bottom: 1px solid rgba(255,255,255,.18)`

### Adaptive card sizing (`browsing-card-group-layout--featured`)
| Items in slot | Card | Size |
|---|---|---|
| 1 (featured) | **horizontal** `blz-card orientation=horizontal backplate` | 1280×432: media 768×432 (16:9, 60%) + content 512 (padding 32) |
| 2 | vertical, half width | 628 wide, media 628×353, heading **24/26** (bigger than grid cards) |
| rest | vertical grid card | 302 wide (4 per row in 1280) |

- Horizontal featured card content: optional game logo on top (320×160, `object-fit: cover`) → franchise line → heading Object Sans 700 24/26 → callout `#ffb400` → genre → price pinned bottom
- On mobile (`min-orientation=vertical`) the horizontal card becomes vertical

### Content hub (tabbed feature carousel)
`blz-carousel-beta.tabbable-carousel`: `transition=instant`, `hover-pause`, `loop`, `arrow-position=top`, `indicator-position=top`

- Title row: h2 `heading-xl` left; prev/next **ghost icon buttons 32×32** top-right (arrow icons `white/72%`), gap 8
- **Text tabs** (`blz-tab-controls` + `blz-tab-control variant=standard`), centred, gap 12:
  | State | Text | Indicator |
  |---|---|---|
  | rest | `white/48%` | – |
  | hover | `#fff` | – |
  | **active** | `#fff` | **`::after` 4px bar `#148eff`, radius 2, full tab width, at bottom** |
  - Tab: Object Sans 700 16/19, padding `10px 24px`
- Slide: 1594×500, bg `#1a1c23`; image left 54% (861px, `object-fit: cover`) with **fade into the panel colour**: `linear-gradient(to left, #1a1c23 0, transparent 50%)`
- Text panel: padding `80px 72px 80px 0`, inner margin-left 40, vertically centred:
  - 24px icon + heading `heading-md` Object Sans 700 18/20 white
  - intro Noto Sans 14/21 `white/72%`, margin `8 0`
  - bullet list Noto Sans 14/21 `white/72%`
  - **secondary** button (large) margin-top ~24

## Takeaways for the build
1. **Single container token**: 1600 content + 16 gutters. Everything aligns to it, and only backgrounds go full-bleed.
2. **Sticky layering**: nav (0) → breadcrumb (88) → section headers (150). Opaque page-colour backgrounds, no shadows.
3. **Side-header sections** (320 sticky | 1280 content) are the core layout for catalogue/brand pages.
4. **Count-adaptive card layouts**: 1 = horizontal hero card, 2 = halves, n = 4-col grid.
5. **Accent appears again only as indicators**: active tab underline, carousel dash, selected bars.
6. **Dividers** are `1px white/18%` (`border-action-pressed` / `white-18`), with 64px space above and below.
