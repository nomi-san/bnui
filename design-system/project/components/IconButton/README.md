# IconButton

Square buttons that hold one icon: toolbars, carousel arrows, overflow menus.

**Provide:** one icon (20px) and an `aria-label` naming the action.

- Default is filled (`fill-strong`, 32px) with `ring-subtle-hover`; `bn-icon-btn--lg` is 40px (sidebar toolbars), `bn-icon-btn--pill` is 26px (back/forward, overflow next to pills).
- `bn-icon-btn--ghost` is transparent `text-secondary`; on hover it gains `fill-strong` and `text-primary`. Use it for bells, dock buttons and carousel arrows in section headers.
- `bn-icon-btn--tall` (28×64, `surface-page`) is the arrow docked inside media carousels; show it only while the carousel is hovered.
- Disabled arrows drop to `text-disabled` with no fill.
