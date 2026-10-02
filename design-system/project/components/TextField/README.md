# TextField

Single-line text entry on `surface-sunken` with a `line-strong` border.

**Provide:** a `label` (uppercase, above the field), a placeholder that shows the format ("XXXX-XXXX-XXXX-XXXX", "Email or Phone"), and helper or error text when needed.

- States: hover border `line-hover`; focus border `accent` (no glow); disabled border `line-subtle` + `text-disabled`; error border `warning` with `bn-help--error` text below.
- Placeholder is `text-tertiary`. Value text is `body-md` in `text-primary`.
- Search fields use `bn-field--search`: `fill` background, no border, 14px text, search icon on the right; hover steps to `fill-strong`.
