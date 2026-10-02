# Dialog

A modal window for settings and confirmations: title bar, body, footer actions.

**Provide:** a title, the body (optionally with a side `SideNav` for multi-page settings), footer actions, and a close handler. Trap focus; Escape and the close button dismiss it.

- Backdrop `scrim` + 20px blur, `z-modal`. Window `surface-page`, 1px `border-solid`, `radius-md`, `shadow-lg`, max 800px wide (settings windows may be wider).
- Header: title `heading-lg` at 20/24, 24px ghost close button right, `space-6` padding, `line-subtle` divider below.
- Settings layout: a 240px `surface-sunken` side nav (current item: `surface-highest` + 4px `accent` bar), content scrolling on the right with `heading-md` section titles and `label` field labels, fields indented `space-6` under each title.
- Footer sticks to the bottom with a `line-subtle` divider: primary first, then secondary ("Done", "Reset to Defaults"), left-aligned, gap `space-2`. Confirmations put the destructive action as primary and name it with a verb ("Remove Friend"), never "OK".
