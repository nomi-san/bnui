# PresenceRow

A person in a friends list with their status and activity.

**Provide:** avatar image, display name, status (online, away, busy, offline), activity text, and optionally the current game's 32px icon on the right.

- 56px row, padding `space-2`, `radius-md`; hover `fill`. Avatar 40px circle with a 14px status dot ringed in `surface-page`: `success` online, `warning` away, `danger` busy, `neutral-muted` offline.
- Online names `accent-soft` (`body-sm`), activity `body-xs` `text-secondary`. Offline: avatar `grayscale(1)`, name and activity `text-muted`.
- Hovering a row opens a hover card (`bn-popover`) with a primary "Start Chat" button.
