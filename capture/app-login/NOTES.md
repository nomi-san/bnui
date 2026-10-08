# Battle.net desktop app: login window

- App 2.53.4.17896, window 362×631. Screenshots taken by the user 2026-10-08; no personal data on screen.
- **Hybrid window:** the form is a **web page** (CEF) and everything around it is **native Qt**: the 1px frame, minimise/close, the options cog and the menu it opens. It is the only app window built this way. Settings and the other dialogs are fully Qt ([`../app-settings/`](../app-settings/)), and the main window is the Vue shell ([`../app-home/`](../app-home/)).

## Files
| File | What |
|---|---|
| `viewport.png` | Login window at rest: "Log in or sign up", email field, Continue, social sign-in grid |
| `options-menu-open.png` | Cog clicked: native options menu open (Login Region, status, Settings, Continue Without Logging In) |

## Web part (CEF)
The same toolkit as the account login in [`../login/NOTES.md`](../login/NOTES.md); pixel-checked here:
- Field 40px, bg `#171920`, 1px border ≈ `white/36%` (`#6b6c70`), radius 4
- Continue: `.btn-primary`, 40px, `#0074e0`, full width of the form (starts 19px from the window edge; the right side leaves room for the page scrollbar)
- "Forgot email?" link `#148eff` bold; "OR" divider 1px `white/18%` (`#3f4147`)

## Qt part
Exact specs are in [`../app-qt/NOTES.md`](../app-qt/NOTES.md) (sections "Window chrome" and "Context menu"). In short:

| Element | Look |
|---|---|
| Frame | 1px `#36383e` around the window |
| Minimise / close | 16px glyphs, `white/48%` → white on hover |
| Options cog (`#loginSettingsButton`) | 26×26, radius 4, `white/12%` + white gear; hover adds a 1px `white/18%` outline; **stays in its pressed skin while the menu is open** (`white/6%`, 1px `white/12%`, gear at 60%) |
| Options menu (`QMenu#loginSettingsMenu`) | 237px wide, 4px below the cog, right-aligned to it. Surface `#1a1c23` + 1px `#35373d` + soft shadow (1px above, 3px at the sides, 5px below). 13px Noto items 28px tall, text `white/72%`. |
| ┣ group header | "LOGIN REGION": Object Sans 700 12 uppercase `white/72%` |
| ┣ choices | Americas / Europe / Asia / China / Help Me Decide, then Use Last Status / Appear Offline. The current choice is shown by `white/6%` + a 2px `#148eff` left bar, **no tick** |
| ┗ separators | 1px `white/12%`, 8px above and below, 6px side insets |

## Takeaways
- A native popup over web content looks seamless because both use the same surfaces: the menu is BNUI's floating surface (`surface-raised` + `border-solid`), and its selection is the accent left bar from the Settings nav and the select list.
- Menu-button pattern: while its menu is open, the trigger keeps its pressed look.
