# Alert

An inline message inside a page or panel: information, success, a warning or an error.

**Provide:** an optional title, one or two sentences, an icon matching the status, and an optional close handler.

- Neutral (`bn-alert`): `surface-raised` with a 1px `line` border. Status variants use the matching tint and line tokens (`info-tint` + `info-line`, `success-…`, `warning-…`, `danger-…`) with the icon in the status colour.
- Padding `space-3` × `space-4`, `radius-md`, 20px icon, text `body-sm` `text-secondary`; title uppercase 14/15 weight 500 in `text-primary`.
- Always pair the colour with an icon and words. Use the yellow `Notice` instead for product release notes in the purchase column.
