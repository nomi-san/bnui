# Tooltip

A short explanation that appears when hovering or focusing an info icon or a truncated label.

**Provide:** one or two sentences of plain text (no links or buttons; use a popover for those), and the trigger, usually a 16px info icon (`bn-info`) after a label or button.

- Surface `surface-raised`, 1px `surface-highest` border, `radius-md`, `shadow-sm`, padding `space-2` × `space-3`, max 320px wide; text `body-md` at 16/22 in `text-body` (14/20 on small screens). An 8px caret points at the trigger.
- Show after a short hover delay (about 300ms) or immediately on keyboard focus; fade in `duration-fast`; hide on Escape or pointer leave. Connect it with `aria-describedby`.
- The border and type come from the source tokens; the fill is inferred from the source's popover surfaces.
