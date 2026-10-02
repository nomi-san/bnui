# Pill

Small 26px buttons in a row of shortcuts above content (Shop, Patch Notes, Forums).

**Provide:** a short label, an optional 16px leading icon, and for external links a trailing external icon in `text-muted`.

- `fill-strong`, `radius-sm`, `button-sm`; hover adds `ring-subtle-hover`. Pills sit `space-2` apart, right-aligned above the content they relate to.
- A status shortcut ("Upgrade Available") keeps the neutral pill and colours its text and icon `success` (`bn-pill--status`). Never fill a pill with a status colour.
- Overflow goes into a 26px `bn-icon-btn--pill` with the more icon.
