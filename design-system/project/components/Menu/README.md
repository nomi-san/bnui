# Menu

The floating surface for dropdown menus, select lists and hover cards.

**Provide:** items (20px icon + label), optional trailing external icon, and dividers between groups. Anchor it to its trigger with a small caret.

- Surface: `surface-raised`, 1px `border-solid`, `radius-md`, `shadow-sm`, padding `space-2`. Hover cards use `bn-popover` (padding `space-4`, `shadow-md`).
- Items: 30px, `radius-xs`, `body-sm` `text-secondary`; hover `fill` + `text-primary`. Dividers: 1px `line-subtle` with `space-2` above and below.
- Opens with a `duration-fast` fade; closes on outside click or Escape.
