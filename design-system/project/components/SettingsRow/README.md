# SettingsRow

One setting: title and description on the left, its status or control on the right.

**Provide:** the setting title, a one- or two-sentence description, and either a read-only status or, in edit mode, the control (Checkbox, Select).

- Grid `3fr 1fr`, padding `space-6` top and bottom, separated by a `fill-subtle` hairline. Title `body-md` `text-primary`, description `body-sm` `text-secondary`.
- Status: Enabled = 16px check-circle + word in `success`; Disabled = 16px x-circle + word in `text-primary`; enums as plain `text-primary` text. Never colour alone.
- Edit mode replaces each status with its control in place and adds Save (primary) + Cancel (secondary) under the last row. Only one card edits at a time.
