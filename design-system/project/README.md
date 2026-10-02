BNUI is a dark interface language for game storefronts, launchers and account dashboards. Content sits on a blue-black page and is separated by **layers of white light** (3%, 6%, 12% white fills), not by borders or shadows. A single accent colour appears only where something is selected, focused or is the main action. Hovers are fast (100ms), colour-only, and never move layout.

Read the tokens by name: colours `surface-*`, `fill-*`, `line-*`, `text-*`, `accent*`, status `success` / `warning` / `danger`; type styles `display-*`, `heading-*`, `body-*`, `eyebrow`, `label`, `tab`, `button-*`, `price`; spacing `space-*`; radii `radius-*`; elevation and rings `shadow-*`, `ring-*`; motion `duration-*`, `ease-*`; sizes `control-*`. Components are CSS classes in `components/bundle.css` with the prefix `bn-`; each component folder has a preview and usage notes.

## Content fundamentals

- **Voice:** direct and promotional without hype. Lead with the game or the action: "Become a legendary monster slayer", "Choose your path with the Premium Battle Pass". Short sentences, no exclamation marks except in the release callout ("Available November 4!").
- **Calls to action are verbs in Title Case:** "Buy Now", "Pre-purchase", "Install", "Add to Wishlist", "Visit Shop", "See All Games", "Learn More". One primary action per view.
- **Interface labels are sentence case:** "Search games", "Sort by", "Already installed? Locate the game.", "Launch when I start my computer".
- **Uppercase is reserved** for `eyebrow` (franchise line above a title: "WORLD OF WARCRAFT"), `label` (field and group labels: "GAME VERSION", "FAVORITES"), the `tab` style (HOME, GAMES) and badges (NEW, PRE-PURCHASE). Always with the style's letter-spacing.
- **Numbers:** prices "$29.99", ranges "From $12.99/month", dates "September 13, 2026", counters "1 / 18", durations "2:16", views "2.3M views". Use tabular figures in prices, counters and countdowns.
- **Trademarks:** set ® and ™ as `<sup>` at 60% size inside titles.
- **No emoji.** Status is carried by icons plus a word ("✓ Enabled" is an icon and a word, never colour alone).

## Visual foundations

### Surfaces and layering
- Paint every page and window `surface-page`. Sticky bars repeat `surface-page` so content scrolls under them without a shadow.
- Lay content on white-alpha fills, three steps only: `fill-subtle` for passive info boxes, `fill` for cards, rows and selected items, `fill-strong` for buttons and for hover. Hover moves an element up exactly one step (`fill` → `fill-strong`; transparent → `fill`).
- Use solid surfaces for structure: `surface-raised` for menus, popovers and panel bodies; `surface-strong` for panel header strips and side-nav hover; `surface-highest` for the selected side-nav item; `surface-sunken` for inputs and wells.
- Floating surfaces (menus, dropdown lists, hover cards) are `surface-raised` + 1px `border-solid` + `radius-md` + `shadow-sm` (menus) or `shadow-md` (hover cards). Nothing else gets a shadow except portrait covers (`shadow-tile`) and dialogs (`shadow-lg`).
- Separate page sections with 64px (`space-16`) of space and a 1px `line` rule. Separate rows inside a card with `line-subtle` or `fill-subtle` hairlines.

### Accent
- `accent-fill` is for the primary action only (one per view) and text selection. Text on it is always `on-accent`.
- `accent` marks state: links, focus borders on fields, the selected tab underline, the selected nav or option left bar, the active carousel dash, the active thumbnail frame, checkbox ticks and slider fills.
- `accent-ring` is the hover colour of the primary action (2px inset ring, `ring-primary-hover`) and of links.
- `accent-soft` names people who are online.
- Never use the accent for decoration, section backgrounds or large areas. If a screen has more than one primary button, demote the others to secondary.

### Selection
- **Horizontal navigation** shows the selection as an underline: 2px under the text for `bn-tabs--app` (uppercase app tabs, favourites bar), 4px full-width bar for content tabs (`bn-tab`).
- **Vertical lists** show it as a left bar inside the element: 2px in compact filter lists and dropdown options, 4px in the side nav, 8px on option cards. Draw it with an inset box-shadow so the label never shifts.
- Selected items also step up one fill and turn `text-primary`; compact lists also turn the label bold (reserve the bold width so nothing jumps).

### Hover and press
| Element | Hover | Press |
|---|---|---|
| Primary button | `ring-primary-hover` (fill unchanged) | `accent-fill-pressed` |
| Secondary / tertiary button | `ring-secondary-hover` | `fill`, text `text-tertiary` |
| Pill, filled icon button | `ring-subtle-hover` | – |
| Ghost icon button, text button | text `text-secondary` → `text-primary`, icon buttons gain `fill-strong` | – |
| List row, menu item, nav item | transparent → `fill` (side nav: `surface-strong`), text → `text-primary` | – |
| Card with backplate | `fill` → `fill-strong`, media `brightness(1.1)` | – |
| Card without backplate, news row | media `brightness(1.1)` | – |
| Portrait cover tile | `scale(1.05)` + `brightness(1.08)`, title → `text-primary` | – |
| Text input, select | border `line-strong` → `line-hover` | focus: border `accent` |

All hovers use `duration-fast` with `ease-out`. Only colour, background, box-shadow, filter and (cover tiles only) scale change.

### Status
- `success`: online, installed, enabled, completed, positive badge (text `on-success`). `warning`: product notices (fill, text `on-warning`), release callouts as text, favourited star, away. `danger`: urgent badges (PRE-PURCHASE, BETA) as a fill with `on-danger`, busy. Danger is never used as text.
- Put a status colour inside a neutral control rather than colouring the control: "Upgrade Available" is `success` text on a `fill-strong` pill.

### Typography
- Two families: `display` (headings, buttons, labels, prices) and `body` (running text, inputs, lists). The display face is the licensed **Object Sans**; when it is not installed the stack falls back to **Figtree** (Google Fonts), then Noto Sans. The body face is **Noto Sans** at 400 and 700.
- Page title `display-lg` (dashboards) or `heading-xxl` (product title). Section heading `heading-xl` on the web, `heading-lg` inside the app. Card titles `heading-md`, clamped to 3 lines. Video and dense tile titles `heading-xs`.
- Body copy `body-md` in `text-body`; descriptions `body-sm` in `text-secondary`; genres, dates and fine print `body-xs` in `text-secondary` or `text-muted`.
- Hierarchy on cards always runs `eyebrow` → title → callout/description → meta → `price`, top to bottom, left-aligned.
- Use `button-xl` only for the screen's hero action (Install, the purchase panel CTAs).

### Spacing and layout
- Container: `content-max` (1600px) centred, with `space-4` gutters (1632px total). The top bar, nav, breadcrumb, hero and sections all align to it; only backgrounds bleed.
- Card grids: `space-6` gaps; 5 columns at desktop for product cards; carousels show 4 per view with `space-3` gaps and a 60px faded peek of the next card.
- Portrait cover grids are responsive with no JavaScript: `grid-template-columns: repeat(auto-fill, minmax(152px, 1fr))`, raised to 176px from 1270px and 200px from 1774px window width; gaps `space-10` × `space-6` (`space-8` columns at the largest step). Cards grow until another fits, then a column is added.
- Catalogue sections: a 320px header column (sticky) beside 1280px of content. Detail pages: main column `1fr` + `aside-width` (418px), gap `space-12`, both sticky. Dashboards: `sidebar-width` (300px) nav + content.
- Card padding `space-6`; panel padding `space-8` × `space-10`; field label to field `space-2`; stacked controls `space-6`.

### Imagery
- Media is 16:9 with `radius-md` (cards, galleries, video, news rows at 320×180). Game covers are 3:4 portrait with `shadow-tile`. Logos over art sit in a 320×168 slot.
- Text over art always sits on a scrim built from the surface colour: `linear-gradient(90deg, surface 20%, transparent 50%)` on the text side.
- Thumbnails at rest are at 60% opacity, 85% on hover, 100% when active; the active one gets a 2px `accent` frame.

### Shape, borders, elevation
- `radius-md` (4px) is the default for everything rectangular. `radius-sm` (3px) for small buttons, pills and checkboxes; `radius-xs` (2px) for menu items and compact rows; `radius-panel` (5px) for dashboard panels; `radius-full` for avatars and dots.
- Borders appear only on inputs (`line-strong`), floating surfaces (`border-solid`) and outlined option cards (`line-subtle`). Every hover ring is an inset box-shadow.

### Motion
- `duration-fast` for hovers, `duration-medium` for menus fading in and media arrows appearing, `duration-slow` for dismissing banners. Carousels advance every 5–7s and pause on hover. No bounces, no slide-ins, no parallax. Honour `prefers-reduced-motion` by removing transitions and the cover-tile scale.

### Focus
- Every interactive element shows `ring-focus` on `:focus-visible`: a 2px `focus-inner` gap and a 2px `focus-outer` ring, legible on fills and on artwork. Text fields show focus with an `accent` border instead.

### Overlays and feedback
- Modal layers (`Dialog`, `Lightbox`) sit on `scrim` with a 20px backdrop blur at `z-modal`, trap focus, close on Escape, and fade in over `duration-medium`. Nothing zooms or slides.
- Floating hints (`Tooltip`, hover cards, menus) use the floating surface (`surface-raised` + 1px border + `radius-md` + `shadow-sm`/`shadow-md`) at `z-menu`.
- Choose feedback by scope: `Alert` for a message about the content it sits in (tinted with the status' `-tint` and `-line` tokens); `Toast` for the outcome of something the user just did or a background event, stacked bottom-right at `z-toast`; `Notice` (solid `warning`) only for product release notes in the purchase column; `AnnouncementBanner` for one launch at a time, sticky at the bottom of the window.
- `Toast` is the only light surface (`surface-inverse` + `on-inverse`) so it reads over any screen. Toasts auto-dismiss after about 5s unless hovered; errors wait to be closed.
- Status colours carry a word and an icon every time. `info` is a status, not the accent, so it stays blue in every accent theme.

## Accent themes

The first theme, **Bnet Blue**, is the default. The other themes swap only the six accent tokens and `ring-primary-hover` for an Open Color hue; every surface, text and status token is shared.

| Token | Rule in Open Color themes |
|---|---|
| `accent-fill` | shade 8 (white text); shade 6 for Teal and Orange (dark text) |
| `accent-fill-pressed` | one shade darker than the fill |
| `accent` | shade 5, or 4 where 5 is under 4.5:1 on `surface-page` (Violet) |
| `accent-ring` | one shade lighter than `accent` |
| `accent-soft` | shade 2 |
| `on-accent` | white, or `surface-sunken` ink on the bright fills |

Always set text on accent fills with `on-accent`. Pink sits near `danger` and Orange near `warning`: in those themes keep badges and notices exactly as specified so status still reads.

## Iconography

- Outline icons on a 24px grid with round caps, used at 16px (inline, pills, status), 20px (nav, menus, buttons) and 24px (toolbars). Colour with `currentColor`; icons take the text colour of their control.
- External destinations get a trailing 16px "arrow out of box" icon in `text-tertiary`. Dropdowns use a 16px chevron-down in `text-secondary`. Breadcrumbs use 12px chevrons.
- The source product uses Font Awesome Pro and a private icon set. Use an open outline set with the same geometry (Lucide or Tabler, 1.5–2px stroke). This system ships no logos or game art: set product names in the display face, and use real key art supplied by the product.

## Components

Actions: `Button`, `IconButton`, `Link`, `Pill`. Forms: `TextField`, `Select`, `Checkbox`, `Radio`, `Slider`, `OptionCard`. Navigation: `Tabs`, `SideNav`, `Breadcrumb`, `CarouselDots`, `Menu`. Promotion: `HeroCarousel`, `AnnouncementBanner`. Content: `ProductCard`, `MediaCard`, `GameTile`, `NewsRow`, `MediaGallery`, `ComparisonTable`, `SectionHeader`, `Badge`, `Price`, `Notice`. Overlays: `Dialog`, `Lightbox`, `Tooltip`. Feedback: `Alert`, `Toast`. Dashboard: `Panel`, `SettingsRow`, `ProgressRing`, `Countdown`. Social: `PresenceRow`. Each folder's README says what to pass in and when to use it.
