# Login — password step

- URL: `https://kr.account.battle.net/login/en/password?...&app=mktp`
- Captured: 2026-10-02, viewport 1549×990
- Same stylesheets as `../login/` (`bnet-next-web.css`, `login-global.css`); body class `password-template`
- The account email was replaced with `player@example.com` in the page before capture

## Files

| File | What |
|---|---|
| `viewport.png`, `fullpage.png` | Screenshots (password field focused) |
| `hover-secondary-btn.png` | "Use passkey" hovered |
| `rest-secondary-btn.png` | "Email a code" at rest |
| `a11y-snapshot.txt` | Accessibility tree |

## Layout

Same 416px centered column, logo and footer as the email step. Only the differences are listed below.

| # | Element | Spec |
|---|---|---|
| 1 | Heading "Welcome back" | Same as email step: Object Sans 700 32/36, margin `40 0 24` |
| 2 | Account line | `p.below-header-cta.account-switcher`: Noto Sans 400 16/24, `rgba(255,255,255,.84)`, centered, margin-bottom 20. Email text, then "Switch account" link |
| 3 | "Switch account" link | Noto Sans **700 16/24**, `#148eff`, **underlined** (`text-underline-position: under`), `nowrap` |
| 4 | Password input + eye toggle | see **Password input** |
| 5 | "Forgot password?" | Same as "Forgot email?" (14/20 bold link, margin-top 16) |
| 6 | Log in button | Primary button, same as Continue |
| 7 | "OR" divider | margin `40 0 28` |
| 8 | Other options | `div.other-login-options`, padding-top 12; two full-width **secondary buttons**, 16px apart: "Use passkey" (`<button>`) and "Email a code" (`<a>`) |

## Components

### Password input
- Same as the text input (40px, bg `#171920`, radius 4, border states default → hover → focus `#148eff` → hover+focus `#7abfff`)
- Right padding **52px** for the toggle
- Eye toggle: `span.view-password-button[role=button][tabindex=0]`, absolute, `right: 12px`, vertically centered, 18×16
  - Icon: Font Awesome `fa-eye` / `fa-eye-slash` (swapped on click), color **`#148eff`** (link blue)
  - `fa-eye-slash` nudged `translateX(-1px)`
  - Caps-lock indicator slot at `right: 33px` (`fa-arrow-alt-square-up`, `rgba(255,255,255,.6)`)

### Secondary button (`.btn-secondary`), verified live
| State | bg | border (2px) | text |
|---|---|---|---|
| rest | `rgba(255,255,255,.12)` | transparent | `#fff` |
| hover / focus | `rgba(255,255,255,.06)` | `rgba(255,255,255,.18)` | `#fff` |
| active | `rgba(255,255,255,.06)` | `rgba(255,255,255,.18)` | `rgba(255,255,255,.6)` |
| disabled | `rgba(255,255,255,.06)` | transparent | `rgba(255,255,255,.6)` |

- Same box as primary: 40px, padding `8px 24px`, radius 4, 500 16/20, `transition: background-color, border-color, color .2s`
- Hover **dims** the fill and adds a faint ring. It doesn't brighten.
- Inconsistency on the live site: `<a class="btn">` gets **Noto Sans** (from a `login-global.css` rule), while `<button class="btn">` keeps **Object Sans**. "Email a code" and "Use passkey" therefore render in different fonts. We should use Object Sans for all buttons.

### Link hover (verified live)
`#148eff` → `#47a6ff`; underline color follows the text color.

## Pattern: button hierarchy
Both hovers are "ring" hovers. The fill stays the same or gets quieter, and a 2px border appears:
- **Primary**: fill = accent, hover ring = light accent (`#47a6ff`)
- **Secondary**: fill = white 12%, hover = white 6% + ring white 18%
- **Tertiary**: transparent + white 24% border, hover = thicker border

With a swappable accent, only the primary fill and ring, links, focus border and eye icon change. Secondary and tertiary are neutral (white-alpha).
