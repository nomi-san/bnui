# Product detail page (PDP)

- URL: `https://us.shop.battle.net/en-us/product/call-of-duty-modern-warfare-4`
- Captured: 2026-10-02, viewport 1549×990, page height 6294
- Scope: **new patterns only**. Nav, product card, badge, price, buttons and footer are in `../store-home/NOTES.md`; tokens are in `../store-home/tokens-root-resolved.json`.
- The BattleTag was replaced with `Player` before capture

## Files

| File | What |
|---|---|
| `viewport.png` | Above the fold: breadcrumb, gallery, purchase sidebar |
| `fullpage.jpeg` | Whole page |
| `hover-gallery.png` | Gallery hovered → arrows shown |
| `hover-edition-option.png` | Unselected edition option hovered |
| `a11y-snapshot.txt` | Accessibility tree |
| `css/blz-*.shadow.css` | New components: breadcrumb, gallery, lightbox, carousel, comparison-table, select, video-badge, legal-ratings |
| `css/*.css` | PDP page stylesheets (Next.js modules) |

## Page layout

```
breadcrumb                         (16px above content)
.product-page__grid   grid-template-columns: 1fr 418px; column-gap 48; padding-bottom 64
 ├ left (1036, sticky)   gallery → "Launching…" description
 └ right (418, sticky)   title / genre / notice / edition picker / CTAs / compatibility / fine print
#comparison-table      full width, h2 + table
#product-features      h2, then rows of [section-header 1/4 | 3-col card grid 3/4]
```
- Both columns are `position: sticky`, so the shorter column stays in view while the longer one scrolls.
- Section h2: Object Sans 700 24/26, margin-bottom 24–32. Sections separated by 64px.

## Patterns

### Breadcrumb (`blz-breadcrumb`)
- Row 21px tall: 20px home icon → items. Separators are 12px chevrons with ~8px space around them
- Items Noto Sans 400 14/21 (`body-sm`), gap 6, uses the `link-subtle` tokens:
  - link: `white/48%` → hover/focus `white/60%` + underline (`text-underline-position: under`)
  - current page (`aria-current=page`, not a link): `white/60%`
  - separator chevron 12px: `white/60%`

### Purchase sidebar (418px)
| Element | Spec |
|---|---|
| Title `h1` | Object Sans 700 **32/35** white, margin-bottom 4 (`heading-xxl`) |
| Genre | Object Sans 500 14/15 uppercase, letter-spacing .6px, `white/60%` (`subheading-lg`) |
| **Notice (yellow)** | `div.product-notification`: bg **`#ffb400`** (alert yellow 500), text **`#000`**, Noto Sans 14/21, padding `10px 20px`, radius 4, margin-top 32 |
| Picker header | grid `[label | link]`: "SELECT A PRODUCT" Object Sans 500 12/13 uppercase .6px `white/72%`; "Compare" Noto Sans 700 16/24 `#148eff` underlined |
| Picker → CTAs → info | vertical stack, gap 24 |

### Edition picker (radio cards) ★ accent
`ol > li > div.product-option` (role radio), stacked with an 8px gap.

| State | bg | text | edge |
|---|---|---|---|
| rest | transparent | `white/72%` | outline 1px `white/12%` |
| hover | `white/6%` | `#fff` | outline 1px `white/12%` |
| **selected** | `white/6%` | `#fff` | **border-left 8px solid `#148eff`** + outline |

- Padding `16px 20px`, radius 4, `transition: .2s`, cursor pointer
- Content: name Object Sans 700 18/20 (margin-bottom 8) + price `blz-price` Object Sans 500 24/29

### Big CTAs
- Primary "Pre-purchase" and secondary "Add to Wishlist": `blz-button size=large`, **full width (418), height 56**
- Label uses `heading-lg`: **Object Sans 700 20/22**. Wishlist has a 24px heart icon + 4px gap
- Stack: `li { padding-bottom: 10px }`
- States as in the store button spec (ring `white/36%` fades in)

### Info boxes (sidebar)
- Section label: Object Sans 700 12/14 uppercase `white/72%` (`heading-xxs`), margin-bottom 8
- **Subtle panel**: bg **`white/3%`**, radius 4, padding `16px 20px` (compatibility row) / `24px 16px` (fine print)
- Compatibility row: 20px icon in **`#6cdb00`** (success green) + 8px gap + Noto Sans 14 `white/72%`
- Fine print: bulleted list, Noto Sans 12/18 `white/60%`, item spacing 8; inline links bold, same colour

### Media gallery (`blz-gallery`, vertical thumbnails)
- Layout: flex, gap 8: thumbnail rail 100px (left) + featured media 16:9 (radius 4, overflow hidden)
- Thumbnails: 100×56 (16:9), radius 4, gap 8, **opacity .6 → hover .85 → active 1**, `transition: opacity .2s`
- **Active indicator**: a separate element that slides to the active thumbnail, `border: 2px solid #148eff` (accent), radius 4; 4px when keyboard-focused
- Rail scrolls with a fade mask: `mask-image: linear-gradient(180deg, #000 80%, transparent)` (both ends once scrolled)
- Video thumbnails: `blz-video-badge` bottom-right (4px): 24px circle, bg `rgba(0,0,0,.7)`, white play icon 20px
- Counter badge "1 / 18": bottom-center (16px), neutral badge (bg `#1a1c23`, border `white/24%`, Noto Sans 700 14 uppercase)
- Arrows: same as hero carousel (28×64 tertiary, bg `#15171e`, ring `white/24%`), **hidden until the gallery is hovered** (`opacity 0 → 1, .2s`); disabled arrow: icon `white/24%`, no ring
- Clicking the featured media opens `blz-lightbox` (CSS saved, not captured live)

### Description
- h2 `heading-xl` 24/26, margin-bottom 24
- Paragraphs Noto Sans 400 **16/24**, `white/84%`, margin `8 0`

### Comparison table (`blz-comparison-table-beta`)
- Full-width `<table>`, first column = feature names, one column per edition
- Header cell: 16:9 image (radius 4) → edition name Object Sans 700 18/20 → full-width primary button (large, 40px) with the price as label; padding `16 8`
- Body rows **56px**, Noto Sans 14/21, names `white/72%`
- **Zebra**: odd rows `white/6%`, even transparent
- Included = `bn-checkmark-circle-filled` 24px icon, centered
- Rows that open a modal: hover bg `white/12%`
- **Sticky header** when scrolled: thead sticks to top 0, bg `#15171e`, `box-shadow: 0 4px 4px rgba(0,0,0,.25)`, header images hidden, slide-in .3s

### Feature section (`#product-features`)
- Each row: `display: flex`: section header (h3 `heading-xl`, 1/4 ≈ 376px) + `grid 3 cols, gap 24` (3/4)
- **Feature card** (`blz-card.feature`, no backplate): image 16:9 radius 4 → padding-top 16 → title Object Sans 700 18/20 → description Noto Sans 14/21 `white/60%` (margin-top 4)
- Rows separated by 32px

## New design takeaways
1. **Accent usage is sparse**: links, the selected edition's left bar, the active gallery-thumbnail frame, carousel indicators and the primary button. Everything else is neutral white-alpha. That keeps the Open Color swap small.
2. **Three surface levels on the page bg** (`#15171e`): `white/3%` (passive info panels), `white/6%` (cards, zebra, selected/hover), `white/12%` (hover on cards, secondary buttons).
3. **Outline instead of border** for selectable cards (`outline: 1px white/12%`), so the 8px accent bar doesn't shift the layout.
4. **Semantic colour blocks**: warning notice = solid `#ffb400` with black text; success = `#6cdb00` icons; callout text on cards also uses `#ffb400`.
5. **Media is always 16:9 with radius 4**: cards, gallery, thumbnails, comparison headers, feature cards.
