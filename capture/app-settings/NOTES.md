# Battle.net desktop app: Settings window (Qt5 native)

- Native Qt5 dialog (not web), so there's no DOM/CSS. Values below are **read from the screenshots** (approximate, ±1–2px), mapped to the web tokens they visibly match.
- Window ~996×708. Captured by the user 2026-10-02. App version 2.53.4.17896.

## Files
| File | What |
|---|---|
| `01-app-general.png` | App → General + Startup (selects, secondary buttons, checkboxes, disabled checkbox) |
| `02-app-dropdown-open.png` | "On startup, view" select **open** (option list) + Advanced checkboxes (checked) |
| `03-downloads.png` | Downloads: path field + "Change", "Scan for Games", nested checkboxes, numeric KB/s inputs (one focused) |
| `04-voice-chat.png` | Voice Chat: selects, **volume sliders**, **input level meter**, outlined "Click to set" key-binding button |

## Layout
```
Title bar "Settings" (Object Sans 700 ~20, padding ~24) ········· ✕ (top-right)
1px divider (white/12%)
├ Left nav ~240px, bg slightly darker than content (≈ #111218 vs #15171e)
│   items 40px: 20px line icon + label (Noto Sans 14–15 white/72%)
│   active: bg ≈ #22242c + 2px #148eff left bar, text white
│   disabled ("Game Settings"): white/36%, no hover
│   version "2.53.4.17896" bottom-left (12–13, white/48%)
└ Content (scrolls, thin scrollbar white/24%)
    Section heading: Object Sans 700 ~18 white ("General", "Startup", …)
    Fields indented ~24 under the heading
    Field label: Object Sans 700 12 UPPERCASE ~.5px white/84% (+ ⓘ info icon white/60%)
    Sticky footer: 1px top divider, [Done primary] [Reset to Defaults secondary], gap 8
```

## Controls (all visually match the web tokens)
| Control | Look |
|---|---|
| **Select** | ~412×32, bg `white/12%` (≈ #2c2e35), radius 4, text Noto Sans 14 white/84%, chevron right white/72% |
| **Select, open** | option list directly below: bg ≈ `#1a1c23`, 1px `#35373d` border, radius 4; option rows ~32px; **highlighted option: bg `white/6%` + 2px `#148eff` left bar**, text white |
| **Primary button** ("Done") | ~96×32, `#0074e0`, radius 4, Object Sans 700 14 white |
| **Secondary button** ("Reset to Defaults", "Scan for Games", "Change", "Test Microphone") | 32px, bg `white/12%`, radius 4, Object Sans 700 14 white |
| **Tertiary/outlined** ("Click to set") | 160×30, transparent, 1px `white/36%` border, radius 4, Object Sans 700 14 |
| **Checkbox** | 18–20px, radius 3, 1px `white/48%` border, transparent; **checked: `#148eff` check mark** (no fill); label Noto Sans 14 white/84%; disabled: border + label white/24% |
| Nested checkbox | indented 24 under its parent |
| **Text/path input** | 32px, bg `#111218`-ish (darker than selects), 1px `white/24%` border, radius 3; read-only path field |
| **Numeric input** (KB/s) | 76×32, right-aligned value; **focused: 1px white border** |
| **Slider** | track 3px `white/24%`, **filled part `#148eff`**, thumb 16px circle `#148eff` |
| **Level meter** | row of ~36 segmented bars (6×20, gap 4), inactive `white/18%` (active would be accent/green) |
| Info icon ⓘ | 14px outline circle, `white/60%`, sits after labels/buttons |

## Takeaways
- Native settings reuse the web palette 1:1 (page `#15171e`, raised `#1a1c23`, divider `#35373d`, fills white/6–12%, accent `#148eff`).
- **Selected = accent left bar** appears again (nav item and open-select option).
- Adds controls the web captures lacked: **slider, segmented level meter, key-binding button, numeric input, disabled nav item, sticky dialog footer**.
- Checkbox here is **outline + accent tick** (no fill), lighter than the account site's green tick. Prefer the accent tick for the design system.
