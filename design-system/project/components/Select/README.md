# Select

A closed field that opens a list of options; the list is a `bn-menu` directly below it.

**Provide:** a `label`, the current value, and the options.

- Outlined select (`bn-select`): same box as a text field (40px, `surface-sunken`, `line-strong` border, hover `line-hover`, open border `accent`).
- Filled select (`bn-select--filled`): 32px, `fill` → `fill-strong` on hover and when open, `text-secondary` → `text-primary`. Use it in toolbars ("Sort by: Featured") and settings.
- The open list marks the current option with `fill` and a 2px `accent` left bar (`aria-selected="true"`). Chevron is 16px `text-secondary`.
