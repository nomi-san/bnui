# Battle.net desktop app: Diablo IV game page (+ Battle.net menu)

- Window 1740×1000, social pane collapsed. Captured 2026-10-02, masked as in `../app-home/`
- Two documents:
  - **Shell** (`resources://home/`): Favorites bar, play column (logo, version select, Install), quick-link pills, Battle.net menu
  - **Game content webview** (`content-ui.battle.net/v2/en-us/phoenix/product/diablo-4`, 1200×782 at x=378,y=218): spotlight carousel, Featured, Latest Videos, Recommended, Latest News
- Capture note: screenshots taken **from the webview itself render broken** in CEF 108 (white panels, missing text), so all page shots are **shell screenshots** (the shell composites the webview correctly) after scrolling the webview. The `battlenet-app` MCP didn't list this webview (it only lists webviews present when it connected), so it was measured with `../_tools/cdp.mjs <script> <url-prefix>`.

## Files
| File | What |
|---|---|
| `viewport-menu-open.png` | Game page + Battle.net logo menu open |
| `hover-menu-item.png` | Menu with "Support" hovered |
| `page-01 … page-06-scroll*.png` | Game page, webview scrolled 0 → 3894 |

## Game page layout (shell)
```
Favorites bar: active game marked with a 2px #148eff underline (::after, transform .4s)
.games-content (margin-left 40)
├ .play column 272px (space-between, full height)
│   game logo (352×336 art, centred over a 272×168 slot)
│   … key art fills the window behind (.logo-background: game art + bottom fade to #15171e)
│   GAME VERSION label → version dropdown → INSTALL → "Already installed? Locate the game."
└ content (x 378): quick-link pills row (42px) → webview 1200×782
```

### Play controls
| Element | Spec |
|---|---|
| "GAME VERSION" | Object Sans 700 **12/12 uppercase .36px `white/48%`**, margin-bottom 8 |
| Version dropdown | 272×32, padding `7px 8px`, bg `white/6%`, radius 4, Noto Sans 14/18 `white/72%`, chevron right. Hover bg `white/12%` + text white (.3s ease-in-out) |
| **Install (play) button** | **272×56**, bg `#0074e0`, radius 4, border 2px transparent; Object Sans **700 20/30, letter-spacing .83px**. **Hover: 2px border `#47a6ff`** (accent-400 ring, verified live). Transition .2s ease-out |
| Helper line | "Already installed?" Noto Sans 12/18 `white/48%` + "Locate the game." text button `white/78%` → hover white |

### Quick-link pills (`.QuickLinks`, right-aligned above the webview)
- `blz-button secondary` pills: **26px tall**, bg `white/12%`, radius **3**, Object Sans **700 12/14**, icon 16 + label, **gap 8** between pills
- Hover: inset **1px ring `white/18%`** (verified)
- Status pill "Upgrade Available": **text + icon `#6cdb00`** (custom-color), same shape
- External links get a trailing ↗ icon `white/48%`; overflow "⋯" = 26px secondary icon button

## Battle.net logo menu (`DropdownMenu`)
| Part | Spec |
|---|---|
| Panel | **253 wide**, bg **`#1a1c23`**, border **1px `#35373d`**, radius 4, shadow **`0 3px 6px rgba(0,0,0,.48)`**, padding 8 |
| Arrow | 24px SVG caret, fill `#1a1c23`, points at the logo (top-left) |
| Open/close | `opacity` + `margin-top` slide, **.1s** ease-out |
| Item | 30px, padding `5px 8px`, radius **2**, 20px icon + 8 gap, Noto Sans **14/20 `white/72%`** |
| External item | trailing 16px ↗ icon `white/60%` (Support, Forums, Mobile App) |
| **Item hover** | bg **`white/6%`** + text white (verified) |
| Divider | `li` with **1px `white/12%` top border**, margin-top 8 + padding-top 8 |
| Footer | social icon buttons 32×32, bg `white/12%`, radius 4, centred; hover inset 1px ring `white/18%` |

Groups: (Settings, Battle.net Updates) · (Support↗, Forums↗, Mobile App↗, BlizzCon) · (Send Feedback, Report a Bug, Take Tour) · (Log Out, Exit) · socials

## Game content webview (same tokens/components as `../app-home/` content)
Sections: Spotlight carousel (5 slides, dash indicators) → **Featured** (3-col large cards with green category labels "SHOP NOW", grey "TRAILER") → Latest Videos (video cards) → Recommended (product cards, "Visit Shop") → **Latest News (horizontal rows)**

### News row (`blz-card orientation=horizontal`, no backplate)
| Part | Spec |
|---|---|
| Row | max **960** wide, rows stacked ~24 apart |
| Media | **320×180** (16:9), radius 4 |
| Content | padding-left **24**, vertically centred |
| Title | Object Sans **700 24/29** white |
| Description | Noto Sans 14/20 `white/72%`, margin-top 4 |
| Date (`blz-timestamp`) | Noto Sans **12/17 `white/48%`**, padding-top 24 |

## Takeaways for the build
1. **Primary CTA hover is the accent-400 ring** in-app too (Install), matching login and account. Use `ring-2 ring-accent-400` for primary, `ring-1 ring-white/18` for secondary/pills.
2. **Active/selected indicator = 2px accent underline** for horizontal nav (main tabs, Favorites bar), **left bar** for vertical lists. Same colour, same thickness family.
3. **Menus/popovers share one surface:** `#1a1c23` + 1px `#35373d` + 4px radius + black/48 shadow; items 30px with 2px radius and `white/6%` hover.
4. **Status colour inside a neutral control** ("Upgrade Available" green text on a `white/12%` pill) instead of a coloured pill. Keeps the chrome calm.
5. **Content rows vs cards:** news uses horizontal rows (image 1/3, text 2/3) for scannability. A good second card layout next to the grid card.
