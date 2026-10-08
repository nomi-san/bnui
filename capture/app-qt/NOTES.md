# Battle.net desktop app: native Qt layer (QML + QSS)

- App: Battle.net **2.53.4.17896**, extracted 2026-10-08 from `Battle.net.mpq` (MPQ v1, 2,978 files) in `C:\Program Files (x86)\Battle.net\Battle.net.17896\`
- Re-run after an app update: `python capture/_tools/extract_qt_styles.py` (needs `pip install mpyq pillow`; picks the newest `Battle.net.<build>` folder, or pass one)
- Nothing is compiled: the QML is plain source (no `.qmlc`) and the stylesheet is a plain Qt Style Sheet, so the values below are exact, not measured

## Where the app's styles live

| Source | What it styles | Status |
|---|---|---|
| `resources/battle.net.css` (QSS, 894 rules) | Every **Qt Widgets** window: Settings, login, install/modify, context menus, toasts, error popups, add-friend | **Live.** Its `[darktheme=true]` rules are the look in [`../app-settings/`](../app-settings/) |
| `resources/{common,main,play}/*.qml` (162 files) | The 1.x launcher layout: TopNav, LeftNav game list, PlayScreen, progress bars, balloons | Shipped and still linked (`QQuickView`, `Phoenix::QmlWindowRoot`), but it is the old look: Blizzard font, `#00aeff` links, PNG button skins. Not seen in any 2.x capture. Legacy reference only |
| `resources/js/phoenix_home/css/app.1215ee7b.css` | The Vue app shell (`resources://home/`) | Same build as [`../app-home/css/shell-app.1215ee7b.css`](../app-home/css/shell-app.1215ee7b.css) (that copy is CSSOM-serialised). Not repeated here |

Fonts ship in the MPQ too (`resources/fonts/`: Object Sans Medium/Bold, Noto Sans, Blizzard Light/Regular/Bold). They are licensed and **not** copied.

## Files

| Path | What |
|---|---|
| `qss/battle.net.css` | The whole stylesheet as shipped (LF line endings) |
| `qss/darktheme.css` | The 239 rules behind the current dark look, comments dropped, `{font_*}` placeholders shown as `<font_*>` |
| `qss/styled_dialog/*.css` | Window-frame styles for active/inactive dialogs |
| `assets/controls/darktheme/`, `assets/images/darktheme/` | SVG/PNG skins the dark rules use: checkbox, slider, combobox arrow, menu and toast 9-patches, status dots, voice icons |
| `tokens-qss-dark.json` | All 49 colours in `darktheme.css` and the assets, with usage and the matching BNUI token |
| `qml/` | All QML + `common/util.js`, original tree. Images they reference (`../controls/*.png`, `../images/*.png`) are not copied |

## Dark theme: the palette is BNUI's

Every dark colour is a BNUI token, either directly or as **white-alpha pre-composited onto `#15171e`** (Qt widgets paint opaque greys). That confirms the BNUI layering model:

| Qt solid | = white over `surface-page` | BNUI |
|---|---|---|
| `#23252b` | 6% | `fill` (≈ `surface-strong`) |
| `#313339` / `#313337` | 12% | `fill-strong` / `line-subtle` |
| `#3f4147` / `#3e4045` | 18% | `line` |
| `#4d4e54` | 24% | only inside `ring-tertiary` (no colour token) |
| `#56585d` | 28% | none |
| `#696b6f` | 36% | `line-strong` |
| `#85868a` | 48% | `text-muted` |
| `#bebec0` | 72% | `text-secondary` |

Direct matches: `#15171e` page, `#111218` settings nav, `#1a1c23` + `#35373d` menus and popups, `#292b33` meter track, `#0074e0` / `#003f7a` / `#148eff` / `#47a6ff` / `#add8ff` accent ladder, `#6cdb00` / `#ffb400` / `#dd0000` status. Off-token: `#005aad` (primary pressed border), `#26496c` (slider/link focus border), `#6b7c9d` (offline dot), `rgb(100,100,100)` (disabled input text).

## Typography
- `<font_dark>` = **Noto Sans**: all widgets, links, inputs, menus. `<font_dark_title>` = **Object Sans**: buttons, headings, tab bar, field labels.
- Base size 13px; the Settings dialog sets 14px. Default text `white/72%`.
- Settings section heading (`optionHeader`): Object Sans **700 18** white. Field label (`subheading3`): Object Sans **700 12 UPPERCASE** `white/72%`. Dialog title (a `QTabBar` tab): Object Sans 700 18, padding `27px 0`, 25px from the left.
- `heading4` 14 bold, `heading6` 18 bold. Menu group header: Object Sans 700 12 uppercase `white/72%`, margin `12 0 6 6`.

## Controls (exact)

### Button (`QPushButton[style~="global"]`)
Object Sans **bold 14** white, radius 4, padding `0 17px`, content height 28 + **2px border = 32px** (Done measures 96×32). The border is always drawn, in the fill colour at rest, so hover never shifts layout.

| Variant | Rest | Hover = focus | Pressed | Disabled |
|---|---|---|---|---|
| Primary (`:default`, the Enter-key button) | `#0074e0`, border same | border 2px **`#47a6ff`** | bg `#003f7a`, border `#005aad`, text `white/60%` | bg + border `#003f7a`, text `white/60%` |
| Secondary (`:!default`) | `#313339` (white/12%), border same | border 2px `#56585d` (white/28%) | bg `#23252b`, border `#3e4045`, text `white/60%` | bg + border `#23252b`, text `white/60%` |
| Tertiary | transparent, **1px** `#4d4e54` (white/24%) | **2px** `#696b6f` (white/36%) | 2px `#3f4147` | 1px `#313339`, text `white/48%` |
| Key-binding ("Click to set") | as tertiary, padding `0 38px` | as tertiary | listening: 1px `#3f4147` | as tertiary |

Sizes: small 20px / 12px / radius 3 / padding 5; large 36 / 16px / padding 28; extralarge 52 / 20px / padding 38.

### Text input and spin box
bg **`black/24%`** (composites to `#101117` ≈ `surface-sunken`), 1px **`#696b6f`** (white/36%), radius 4, 30px + border = **32px**, text white.
Hover border `#85868a` (white/48%) · focus `#148eff` · read-only `#313337` + text `white/72%` · disabled `#313337` + text `rgb(100,100,100)` · error `#ffb400`. Search variant: 30px left padding with a search icon.

### Select (`Phoenix--DarkComboBox`)
bg `white/6%`, radius 4, Noto 14 `white/72%`, padding `4 8 7 12`, 16px chevron `white/72%`. Hover/focus: bg `white/12%`, text and chevron white. Open/pressed: bg `white/12%`, text `white/48%`. Disabled: bg `white/12%`, text `white/20%`.
List: the menu 9-patch below; padding `5 0`; rows **30px**, margin `1 5`, padding `0 7`, `white/72%`; hover `white/6%` radius 3 + white; **selected `white/6%` + 2px `#148eff` left bar**, right corners radius 3; disabled `white/24%`.

### Context menu (`QMenu`) and popups
- Surface: 9-patch = `#1a1c23` + 1px `#35373d` (`surface-raised` + `border-solid`). Popups and error boxes use the shadowed version (about 3px of soft shadow at the sides, 5px below) plus arrow images.
- Padding `6px 0`, Noto 14. Item 28px, margin `1 6`, padding `0 8`, `white/72%` → selected `white/6%` radius 3 + white; pressed `white/60%`; disabled `white/48%`; checked adds the 2×28 accent bar. Separator 1px `white/12%`, margin `8 6`.

### Checkbox and radio
20px (small 16, toast 18), radius 4 (radio round), fill `black/24%`, 1px stroke **`white/36%`** → hover/focus `white/48%` → pressed `white/24%` → disabled `white/12%`. Tick/dot **`#148eff`** → hover `#47a6ff` → pressed `#003f7a` → disabled `white/24%`. Label spacing 10px; disabled label `white/48%`.

### Slider and level meter
- Groove **4px** (small 2px), radius 2: filled `#148eff`, empty `white/12%`, inset 6px. Focus: 1px `#26496c` frame, radius 2.
- Handle art 18×18 in a 24px box (18px for the small slider): rest **14px `#148eff` dot**; hover 12px `#0074e0` + 2px `#47a6ff` ring; pressed `#003f7a` + `#005aad` ring; disabled `#003f7a`.
- Input level meter: pills **8×20, radius 2**: active `#148eff`, inactive `#292b33` (`surface-highest`), disabled `#5a5d70`.

### Links (`QPushButton[style~="link"]`)
Noto **bold**, `#148eff`, padding `0 5 1 5` → hover `#47a6ff` + underline → pressed `#148eff` + underline; focus 1px `#26496c` frame radius 2; disabled `#148eff` at 48%. White link: `white/72%` bold underlined → hover white; focus frame `#bebec0`.

### Settings window layout
- Dialog `#15171e`. Title tab bar, then 1px `white/12%` rule. Left nav container **`#111218`**, padding `18 8 40 8`.
- Nav items: radius 2, label `white/60%`; hover `white/6%`; **selected `white/6%` + 2px `#148eff` left bar** (36px art), label white; disabled label `white/20%`. Version label `white/48%`, margin `0 0 20 22`.
- Accordion header: `#23252b`, radius 4, Noto, padding-left 38, chevron right/down; hover `#313337`; focus border `#47494d`; open → square bottom corners over a `white/3%` pane. Per-game boxes: `white/3%`, radius 4.
- Bottom bar **78px**, `#15171e`, top rule `white/12%`. "Changes saved" check icon; installed message `#6cdb00`.

### Toast (`Phoenix--DarkToast`)
- 9-patch `#15171e` + 1px `#313339` + soft bottom-weighted shadow; hover `#1a1c23` + `#35373d`.
- Title Noto bold 14 white; a person's name **`#add8ff`** (`accent-soft`); body 14 `white/72%`; extra line bold 14, margin-top 8.
- 12px status badge on a cutout matching the toast fill: online `#6cdb00`, away `#ffb400`, busy `#dd0000`, offline `#6b7c9d`. Close icon 16px `white/48%` → white on hover.

### Other
- ⓘ tooltip icon 16px `white/48%`. Notification text: normal `#6cdb00`, error `#ffb400` (errors are yellow).
- Install dialog background: radial gradient from the bottom-right corner, `#141a25` → `#15171e`.

## Buttons: Qt vs web

The colours are identical. The **motion and focus model** differ:

| | Qt dark dialog (`battle.net.css`) | Web login toolkit `.btn-primary` ([`../login/`](../login/)) | Web store `blz-button` ([`../store-home/`](../store-home/)) | BNUI `bn-btn` |
|---|---|---|---|---|
| Rest | `#0074e0`, 2px border in fill colour | `#0074e0`, 2px transparent border | `#0074e0` | `accent-fill` |
| Hover ring | 2px `#47a6ff` **border** | 2px `#47a6ff` **border** | 2px inset `white/36%` ring on `::after`, **every variant** (primary too) | 2px inset `ring-primary-hover` (`#47a6ff`) |
| Ring appears | **instantly** (QSS has no transitions; 0 `transition` in 894 rules) | `border-color .2s` ease | `::after` opacity 0 → 1, **200ms `ease-in-out`** (the "glow" fade) | box-shadow **100ms `ease-out`** |
| Focus | `:focus` = hover look; applies after a mouse click too (no `:focus-visible` in QSS) | `.btn:focus` = hover look | no focus rule in its shadow CSS (store focus tokens: `#111218` inner + white outer) | `:focus-visible` → `ring-focus` (2px `#111218` + 2px white), also eased 100ms |
| Pressed | `#003f7a`, border `#005aad`, text `white/60%` | same | `#003f7a`, border `white/18%` | `accent-fill-pressed` |
| Secondary hover | keeps `#313339`, 2px `#56585d` border | bg drops to `white/6%`, border `white/18%` | keeps `white/12%`, 2px `white/36%` ring | keeps `fill-strong`, `ring-secondary-hover` (`white/36%`) |
| Size | 32px, Object Sans 700 14 | 40px, Object Sans 500 16 | 40px default | 32 (`md`) / 40 default |

The Qt dialog is the login toolkit's button (same accent ring, same pressed `#005aad` border) with zero duration: Qt can't animate, so the ring snaps on. The store's `blz-button` is the one with the fading neutral ring. BNUI takes the store's mechanics (inset ring, no layout shift) with the toolkit's accent ring, at 100ms.

## Corrections to [`../app-settings/NOTES.md`](../app-settings/NOTES.md) (screenshot estimates)

| Control | Screenshot estimate | Exact (QSS, pixel-checked on `03-downloads.png`) |
|---|---|---|
| Numeric input "1000" | "focused: 1px white border" | Not focused: rest border `#696b6f` (white/36%). The empty one is **disabled** (`#313337`) because its checkbox is off |
| Path / numeric fill | `#111218`-ish, border `white/24%`, radius 3 | `black/24%` → `#101117`; rest border white/36%, read-only `#313337`; radius 4 |
| Nav selected | `#22242c` + 2px bar | `white/6%` over `#111218` = `#1f2026` (pixel-exact) + 2px `#148eff` |
| Nav label | `white/72%` | `white/60%` |
| Checkbox | 18–20px, radius 3, `white/48%` border | 20px, radius 4, `black/24%` fill, `white/36%` border (48% on hover) |
| Slider | track 3px `white/24%`, thumb 16px | track 4px, empty part `white/12%`, thumb 14px dot |
| Level meter | 6×20 bars, gap 4, `white/18%` | 8×20 pills, radius 2, inactive `#292b33` |
| Select at rest | `white/12%` | `white/6%` (12% on hover/focus/open) |
