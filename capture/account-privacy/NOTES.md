# Account: Privacy & Communication (settings page)

- URL: `https://account.battle.net/privacy`
- Captured: 2026-10-02 at 1888px wide, page height 2823
- Same app as `../account-overview/` (Vue + Bootstrap + Meka). Sidebar, card, h1 and tokens are specified there. **New here: the read-only settings list pattern.**
- Header BattleTag shows `Player` (masked)

## Files

| File | What |
|---|---|
| `viewport.png` | Top: h1 + "Social Settings" card |
| `fullpage.jpeg` | All 5 sections |
| `a11y-snapshot.txt` | Accessibility tree |

## Page composition
```
h1 "Privacy" (Object Sans 700 40/44)
card × 5 (stacked, full content width 1160, gap ~30 via .mt-card-top)
  header:  h2 + "✎ Update" link (right)
  body:    setting rows separated by hairlines
```
Sections: Social Settings (7 rows) · Game Data And Profile Privacy (1) · Personalized Recommendations (2) · Communication Preferences (3) · Profile Settings (1)

## Settings card

### Header action link ("Update")
- `a.card-header-link`: Noto Sans 700 16/24, `#148eff`, underlined, cursor pointer
- Leading 16px **pencil icon** (Font Awesome solid), same colour
- **Hover**: `#47a6ff` (verified live). The underline stays
- Clicking switches the card to edit mode (not captured, see below)

### Setting row (read-only)
Bootstrap `.row` with two columns: **text (col-9)** | **status (col-3, right-aligned)**.

| Part | Spec |
|---|---|
| Title | Noto Sans 400 **16/24** white |
| Description | Noto Sans 400 **14/20** `white/72%`, margin-top 4, max ~830px |
| Inline link (optional) | Noto Sans 700 14/20 `#148eff` underlined + external-link icon, on its own line |
| Status | right-aligned, Noto Sans 16/24, vertically aligned to the description |
| Divider | `hr`, margin `24px 0`, `border-top: 1px solid white/10%` × `opacity .25` (very faint, ≈ `white/3%`) |

Status variants:
| State | Look |
|---|---|
| **Enabled** | 16px solid check-circle + "Enabled", both **`#70d929`** |
| **Disabled** | 16px solid times-circle + "Disabled", both **white** |
| Value | plain text white (e.g. "Everybody", "Listening & Speaking", "English (US)", "Public") |

⚠ The enabled green here is `#70d929` (also used for the default-payment-card bar), not the palette's `#6cdb00`. They're visually almost identical, so use `success-500 #6cdb00` in the build.

## Pattern takeaway: "settings list"
A reusable read-only description-list row:
```
┌──────────────────────────────────────────────────────┬──────────────┐
│ Title (16 white)                                     │   ✓ Enabled  │
│ Description (14/20 white/72), wraps to ~75% width    │              │
└──────────────────────────────────────────────────────┴──────────────┘
──────────────── hairline, 24px above/below ────────────────
```
Status uses colour + icon + label (never colour alone): green check = on, white × = off, plain text = enum value.

## Edit mode (after clicking "Update")

Files: `edit-mode-viewport.png` (controls), `edit-mode-save-hover.png` (Save hovered).

- The card swaps in place: the **"Update" link disappears**, each status becomes a control in the same right column, and **Save (primary) + Cancel (secondary)** appear left-aligned under the last row (`meka-button--large`, gap 16, ~24px above)
- Other cards stay read-only (only one card is edited at a time)
- No modal, no animation: instant swap

### Checkbox (page variant `label.styled-checkbox`), used for on/off settings
| State | Box | Mark |
|---|---|---|
| rest | 24×24, bg `#111218`, border 1px `white/84%`, radius 4 | – |
| **hover** | border **`#148eff`** (accent) | – |
| focus-within | border + outline 1px `#005aad` | – |
| **checked** | same box | **green `#6cdb00` tick**: L-shape 17×9, `border-left/bottom 4px`, radius 2, `rotate(-45deg)` |
| disabled | border `white/36%` | grey dash (2px `white/36%`) |
- Native `<input type=checkbox>` hidden (0×0, opacity 0) inside the label

### Dropdown (`select.meka-dropdown`), native select restyled
- 252×42, padding `8px 32px 8px 8px`, bg **`#111218`**, border 1px `white/36%`, radius 4, Noto Sans 16/24 white, `appearance: none`
- Chevron: inline SVG (Font Awesome chevron-down), fill `white/60%`, **16px at `right 8px` centre**
- States: hover border `white/84%` · **focus/active border `#148eff`** (verified live) · disabled border `white/12%` + text `white/48%` · error border `#ffb400` · success border `#6cdb00`
- `transition: border-color .2s ease-out`; small variant: 14/20, padding `6px 8px`

### Meka form library (in CSS, not all on this page)
| Control | Spec |
|---|---|
| **Text input** `.meka-input` | bg `#111218`, border `white/36%`, radius 4, padding 8, 16/24; placeholder `white/60%`; hover `white/84%`; focus `#148eff`; disabled `white/12%` + text `white/48%`; error `#ffb400`; success `#6cdb00` |
| **Checkbox** `.meka-checkbox` (library) | 20×20 box, bg `#15171e`, border `white/36%` → hover `white/48%` → active `white/24%`; checked: 6×12 tick, `border-width 0 3px 3px 0`, `rotate(45deg)`; label `white/72%` → hover white → checked `white/84%`, padding-left 32 |
| **Radio** `.meka-radio-button` | 20×20 circle, bg `#15171e`, border `white/36%`; checked dot 12px **`#148eff`** (hover `#47a6ff`, active `#003f7a`); label as checkbox |

→ Across inputs/selects the state ladder is consistent: **rest `white/36%` → hover `white/84%` → focus accent `#148eff` → disabled `white/12%`**, with error = yellow and success = green borders.

### Save / Cancel
- Save = `meka-button--primary --large`; **hover: inset 2px ring `#47a6ff`** (verified live), bg unchanged
- Cancel = `meka-button--secondary --large` (`white/12%`; hover ring `white/18%`)
