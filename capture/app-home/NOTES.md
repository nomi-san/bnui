# Battle.net desktop app: Home tab

- App: Battle.net 2.53.4, embedded Chrome (CEF) **108**, window 1600×1000, remote debugging on `127.0.0.1:8888`
- Captured: 2026-10-02
- Two separate documents:
  1. **Shell**: `resources://home/` (Vue app, compiled Sass, **no CSS variables**): title/nav bar, Favorites bar, friends sidebar
  2. **Home content**: `https://content-ui.battle.net/v2/en-us/phoenix/homepage`, embedded via `<cef-web-view>` (Next.js + the same `blz-*` web components and tokens as the store)
- Personal data masked in-page before capture: own name → `Player`, friends → `FriendOne/Two/Three`, activity → `Zone Name - Realm`, BattleTag numbers → `#0000`, "Friends since" → January 1, 2025, avatars → grey `#5a5d70`

## How it was captured
- Content webview: `battlenet-app` MCP (`--browserUrl http://127.0.0.1:8888 --experimentalIncludeAllPages`)
- Shell: the MCP can't see it (CEF doesn't auto-attach the app's own page), so it was captured with `../_tools/cdp.mjs` (direct page socket: `list`, `eval`, `shot`, `hover`)
- Full-page screenshots don't work in CEF 108 (the viewport repeats), so the content was captured as 4 viewport shots

## Files

| File | What |
|---|---|
| `shell-viewport.png` | Whole app window (shell + content), masked |
| `shell-hover-friend.png` | Friend row hovered → friend hover card, masked |
| `shell-outline.txt` | Shell DOM outline (sizes/positions; numeric IDs stripped) |
| `css/shell-*.css` | Shell stylesheets (`app.1215ee7b.css` 630 KB) |
| `content-01-top … content-04-bottom.jpeg` | Home content, top to bottom (transparent page bg renders black outside the app) |
| `content-hover-product-card.jpeg` | Product card hovered |
| `content-a11y-snapshot.txt` | Content accessibility tree |
| `content-tokens-resolved.json` | 1170 tokens resolved in the app content |
| `css/content-*.css`, `css/blz-counter.shadow.css` | Content stylesheets |

---

## Shell (app chrome)

### Window layout (1600×1000)
```
#main-header 88px (24px title-bar strip + 64px nav row)
├ nav (1280): [bnet logo ▾ 40] [← → 26px] [HOME | GAMES tabs] ··· drag area ··· [🔔 40]
└ right (320): [avatar 48 + name/status] [dock ⇱ 32]
#main-content
├ #main-panel (1280): Favorites bar (56, inset 24) → content area (padding 24/40)
└ #right-panel (320): friends toolbar → groups → friends list → "Chats and Groups" (bottom)
```
- Background: full-window game art `resources://home/img/…` with a bottom fade to `#15171e` (`linear-gradient(transparent calc(100%-256px), rgba(21,23,30,.9) calc(100%-100px), #15171e)`) and a right-side fade (640px, transparent → `#15171e` by 320px) so the sidebar sits on solid colour
- Body bg `#15171e`, font Noto Sans 16/24 white; headings Object Sans
- Global transition (same as the store): `color, background-color, border, filter .2s cubic-bezier(0,0,.2,1)`

### Top nav
| Element | Spec |
|---|---|
| Logo button | 40×40 icon, colour `#148eff`; dropdown caret `white/72%` |
| Back/forward | 26×26, padding 4, bg `white/12%`, radius 4, 16px arrow; transition .3s |
| **Main tabs** | Object Sans **16/24 UPPERCASE, letter-spacing .8px**, padding `8px 16px`. Idle: **500** `white/60%`; active: **700 white + 2px `#148eff` underline** under the text (`::after`, `transition: transform .4s`) |
| Bell | 40×40, icon 24 `white/72%` |
| Profile | avatar 48 circle + 20px status dot (online `#6cdb00`); name Noto Sans 16/24 **`#add8ff`** (blue-200) + caret; status 14 `white/72%` |

### Favorites bar
- 56px tall, bg `white/6%`, radius 4, inset 24px from edges
- Label "FAVORITES": Object Sans **700 12/16 uppercase .6px `white/48%`**
- Game buttons: 64×56 cells, 40px icon centred; "+" add: 32px circle bg `white/6%`
- Motion: `all .2s cubic-bezier(.5,0,.5,1)`

### Friends sidebar (320px)
| Element | Spec |
|---|---|
| Toolbar icon buttons | 40×40, padding 7, bg `white/12%`, radius 4, 24px icon (`icon-button large secondary`), transition .3s |
| Search | 176×40, bg `white/6%`, no border, radius 4, Noto Sans 14/21, search icon right (padding-right 30) |
| Group header | "▾ ★ Favorites - 0/0": Noto Sans **500 14/21 `white/72%`**, 24px row, caret + icon |
| Friend row | 288×56, padding `0 8px`; avatar 40 + status dot 20 (bottom-right); text column gap 12 |
| ┣ online | name Noto Sans 14/21 **`#add8ff`**; activity 12/18 `white/72%`; 32px game icon on the right |
| ┗ offline | avatar `filter: grayscale(1)`; dot `#5a5d70`; name + text **`white/48%`** |
| "Chats and Groups" | `blz-button` secondary (`white/12%`), ~224×40, + 32px collapse icon button |

### Friend hover card (popover, opens on row hover)
- `.popover`: 312 wide, bg **`#1a1c23`**, border **1px `#35373d`**, radius 4, shadow **`0 5px 10px rgba(0,0,0,.48)`**, padding 16, attached left of the row
- Header: 72px avatar + status dot; name 16 `#add8ff` + `#tag` 16 `white/72%`; "Online" 14 `white/72%`; "Friends since…" 12–14
- Actions row: **"Start Chat" primary `blz-button`** 150×32 (Object Sans 700 14) + three 34×34 secondary icon buttons (gap 8)
- Game row: bg `white/6%`, radius 4, 56px, game icon + name 16 white + activity 14, 32px download button (secondary)
- "View Profile": text button Object Sans 700 14 `#148eff`, centred

### Shell hover rules (verified live)
| Control | Hover |
|---|---|
| Text tabs, icon-only buttons (GAMES, bell, dock, profile) | text/icon `white/60–72%` → **white**; icon buttons also get bg `white/12%` + radius 4 |
| List rows (friend, group header, Favorites game cell, profile button) | transparent → **`white/6%`**, radius 4 |
| Filled icon buttons (back/forward, add-friend, Chats and Groups) | **inset 1px ring `white/18%`** |
| Favorites game icon | **`translateY(-2px)`** lift (.2s ease-in-out) + cell `white/6%` |
| Favorites "+" | `white/6%` → `white/12%` |

---

## Home content (embedded webview, 1256×824)

Same tokens as the store (`content-tokens-resolved.json`, 1150 shared). **One systematic difference: line-heights are looser in the app** (`--semantic-*-line-height` 120% vs the store's 110%; e.g. heading-xl 24/29 vs 24/26, heading-lg 32/38 vs 32/35; badge padding `6 8 4 8` vs `2 8`).

It also defines a short alias layer, worth copying into our Tailwind theme:
| Alias | Value |
|---|---|
| `--color-bg-primary` / `--body-bg-color` | `#15171e` |
| `--color-bg-secondary` | `white/6%` |
| `--color-heading-primary` · `--color-text-primary` | `#fff` |
| `--color-body-primary` | `white/72%` |
| `--color-text-secondary` | `white/60%` |
| `--color-link-primary` | `#148eff` |
| `--cui-border-radius` | 4px |

The page background is **transparent** (it sits on the shell's art). It renders black in the screenshots.

### Sections (top to bottom)
1. **Billboard**: `blz-carousel-beta` hero + **4 preview tab cards** overlapping its bottom edge (`blz-tab-controls variant=preview`, 208×228, bg `white/6%`, radius 4, shadow `2px 1px 10px rgba(0,0,0,.3)`); **7s per slide** with a thin blue progress bar on the active card
2. **Recommended**: product cards (store `blz-card` style)
3. **New and Trending Videos**: video cards
4. **Featured Games**: wide feature cards
5. **News & Updates**: article cards
6. **Start Your Adventure For Free**: contained panel of portrait game tiles

### Section header (all carousels)
- h2 Object Sans **700 20/24** white (`heading-lg`)
- Right: optional **tertiary small** `blz-button` ("Visit Shop", "See All Games": 24px tall, 12/14 500, inset ring `white/24%`, radius 3) + **ghost arrow icon buttons** 32×32 (`white/72%`, disabled `white/24%`)

### Card carousel (`blz-carousel-beta`)
- `per-view=4` (md 4, sm 3, xs 2), `slide-gap=12`, `leading/trailing-peek-hint=60`, `peek-hint-fade`, smooth transition, arrows top-right
- Peek: slides container padding `3px 63px` with an edge mask `linear-gradient(to right, #000 0, #000 calc(100% - 60px), transparent)`

### Card variants (all `blz-card`, radius 4, 16:9 media)
| Variant | Width | Backplate | Content | Title |
|---|---|---|---|---|
| Product | 270 | `white/6%` | padding 24 | Object Sans 700 **18/22**, 3-line clamp |
| News | 270 | `white/6%` | padding 24 | 18/22 |
| Video | 213 | none | padding-top 16 | Object Sans 700 **14/17**, 2-line clamp; NEW badge top-left; **play badge** bottom-right (24px circle, `rgba(0,0,0,.7)`) |
| Featured game | 363 | none | padding-top 16 | 18/22 + description Noto Sans 12/17 `white/72%` |
| Free-to-play tile | 197 | – | – | **portrait 10:13** key art with logo, radius 4 |
- Franchise line (all): 20px icon + Object Sans 700 12/14 uppercase .6px `white/72%`, gap 4

### "Start Your Adventure For Free" panel
- Full-width `section`, bg **`white/6%`**, radius 4, padding `24px 40px`
- Title `heading-lg` 20/24 + subtitle Noto Sans 14/20 `white/60%`

### Content hover rules (verified live)
- **All cards**: media **`filter: brightness(1.1)`**
- Cards with a backplate: bg `white/6%` → **`white/12%`**
- Both fade over **.2s ease-out** (the store switches card bg instantly)

---

## Takeaways for the build
1. **The app adds a list/row hover idiom**: rows go transparent → `white/6%` with a 4px radius; filled controls get an inset 1px `white/18%` ring. Fits "fast hover" well.
2. **Name colours by presence**: online `#add8ff`, offline `white/48%` + greyscale avatar; status dots green `#6cdb00` / grey `#5a5d70`.
3. **Popover surface**: `#1a1c23` + 1px `#35373d` border + `0 5px 10px rgba(0,0,0,.48)` is the elevated-surface recipe (dropdowns, hover cards).
4. **Card hover = brighten the media** (`brightness(1.1)`) plus a backplate step. A subtle, cheap way to signal hover.
5. **Uppercase tracked tabs** (16px, .8px tracking) are the app-level nav, distinct from the store's sentence-case menus.
6. Use the store's 110% line-heights or the app's 120% consistently. The app's looser rhythm reads better for dense UI.
