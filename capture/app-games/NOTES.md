# Battle.net desktop app: Games tab (All Games grid)

- Document: the app shell `resources://home/` (same as `../app-home/` shell), captured with `../_tools/cdp.mjs`
- Window **1740×1000**, social pane **collapsed** (icon rail, 136px)
- Captured: 2026-10-02. Masked as in `../app-home/` (avatars grey, no names)
- CSS source: `../app-home/css/shell-app.1215ee7b.css` (search `.AllGames`, `.AllGamesCard`)

## Files
| File | What |
|---|---|
| `viewport-1740.png` | Games tab at 1740px, 6-column grid |
| `hover-game-card.png` | Warcraft III card hovered (scaled + title white) |

## Layout
```
Favorites bar (shared shell)
.AllGames  display:flex
├ .AllGames-sidePanel  195px, sticky top 0, margin-right 32
│   search · divider · filter list (My Games, Installed, Favorites | All Games, Start For Free, Handheld, Mobile, MacOS)
└ .AllGames-main  flex 1
    header: "All Games" (Object Sans 700 24/28) ············ "Sort by:" + dropdown
    .AllGames-grid (responsive, see below)
```

## ★ Responsive grid: pure CSS, no JS
```css
.AllGames-grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(152px, 1fr));
  grid-auto-rows: min-content;
  gap: 40px 24px;                                   /* row · column */
}
@media screen and (min-width: 1270px) {
  .AllGames-grid { grid-template-columns: repeat(auto-fill, minmax(176px, 1fr)); }
}
@media screen and (min-width: 1774px) {
  .AllGames-grid { grid-template-columns: repeat(auto-fill, minmax(200px, 1fr)); gap: 40px 32px; }
}
```
**Behaviour (what you saw):** `1fr` stretches the cards to fill the row. As soon as another `min`-wide card plus gap fits, `auto-fill` adds a column and every card shrinks back toward `min`, then grows again. The window-width media queries raise the minimum card size on large windows, so cards don't get tiny on wide screens.

Columns = `floor((W + gap) / (min + gap))`, card width = `(W − (n−1)·gap) / n` (W = grid width):

| Grid width W | window < 1270 (min 152, gap 24) | 1270–1773 (min 176, gap 24) | ≥ 1774 (min 200, gap 32) |
|---|---|---|---|
| 900 | 5 × 161 | 4 × 207 | 4 × 201 |
| 1100 | 6 × 163 | 5 × 201 | 4 × 251 |
| **1317** (captured) | 7 × 168 | **6 × 200** ✓ | 5 × 238 |
| 1500 | 8 × 166 | 7 × 194 | 6 × 223 |
| 1800 | 10 × 158 | 9 × 179 | 7 × 230 |

Column thresholds (W where column *n* appears): min 176/gap 24 → 4:776 · 5:976 · 6:1176 · 7:1376 · 8:1576.

Tailwind equivalent: `grid gap-x-6 gap-y-10 [grid-template-columns:repeat(auto-fill,minmax(152px,1fr))] min-[1270px]:[grid-template-columns:repeat(auto-fill,minmax(176px,1fr))] min-[1774px]:[grid-template-columns:repeat(auto-fill,minmax(200px,1fr))] min-[1774px]:gap-x-8`

## Game card (`.AllGamesCard`)
| Part | Spec |
|---|---|
| Card | **portrait 3:4** key art (source 600×800), radius 4, overflow hidden, **`box-shadow: 0 8px 12px rgba(0,0,0,.48)`** |
| **Hover** | **`transform: scale(1.05); filter: brightness(1.08)`**, `transition: all .1s cubic-bezier(0,0,.2,1)` (verified live) |
| Badges | absolute top-left 4px, row: favourite star + optional label |
| ┣ Favourite | 26×26 icon button, bg **`#111218`**, star `white/48%` → hover white; **favourited `#ffb400`**; radius `4 0 0 4` when joined to a badge |
| ┗ Label (BETA / NEW) | bg **`#d00`**, Object Sans 700 12/18 uppercase .6px, padding `0 8px`, radius `0 4 4 0` (joined to the star) |
| Title (below card, margin-top 8) | Object Sans **500 14/21 `white/84%`** → **white while the card is hovered** (`.AllGamesCard:hover + .label`) |
| Genre | Noto Sans 12/18 `white/60%` |
| Installed label (when installed) | green `#6cdb00` check icon + text `white/60%` → white on hover |
| Row gap 40px leaves room for the 2-line title |

## Filter side panel
| Element | Spec |
|---|---|
| Search | full width, 37px, bg `white/6%`, radius 4, Noto Sans 14, padding `8 30 8 8`, icon right |
| Divider | 1px `white/12%`, margin `12px 0` |
| Option row | 29px, padding `4px 8px 4px 16px`, radius 2, Noto Sans 14/21 `white/72%`; count pill right |
| ┣ hover | bg `white/6%`, text white (bg/colour fade **out** over .3s, in instantly); active: `opacity .48; translateY(1px)` |
| ┗ **selected** | bg `white/6%`, text **white 700**, **2px `#148eff` left bar** (`::before` inset border-left) |
| Count pill | bg **`rgba(0,0,0,.24)`**, radius 9, min-width 27, centred, Noto Sans 700 12/17 `white/72%` |
| Label width trick | `::before { content: attr(data-label); font-weight: 700; height: 0; visibility: hidden }` reserves the bold width so selecting doesn't shift layout |

## Header controls
- "Sort by:" Noto Sans 14 `white/72%` (line-height 32) + **DropdownSelect** button: 32px, padding `4px 8px`, bg `white/6%`, radius 4, Noto Sans 14/18 `white/72%`, chevron → hover bg `white/12%` + text white (.3s ease-in-out)

## Collapsed social pane (icon rail)
- 136px wide: avatar 48 + dropdown caret; one 88×40 icon button (bg `white/12%`); group headers become `▾ ★ 0` / `▾ 👥 1` (icon + count); friends shown as 40px avatars with status dots, stacked; bottom: chat icon button + expand `←|`

## Takeaways for the build
1. **Responsive card grid = `repeat(auto-fill, minmax(MIN, 1fr))` + breakpoint-raised MIN.** No JS, no container queries needed.
2. **Two hover languages:** cover-art tiles **scale 1.05 + brighten** (fast .1s); content cards brighten media / step the backplate (`../app-home`). Use scale only for pure image tiles.
3. **Selected-list-item pattern** again uses the accent as a **2px/4px left bar** (filter option here, account sidebar, PDP edition picker).
4. **Bold-width reservation** (`attr(data-label)` pseudo) avoids layout jump when an item becomes bold. Worth copying.
