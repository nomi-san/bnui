# GameTile

Portrait game covers in a library grid.

**Provide:** 3:4 cover art, the game name, the genre, favourite state, and an optional label (NEW, BETA).

- Cover `radius-md` with `shadow-tile`. Hover: `scale(1.05)` + `brightness(1.08)` in `duration-fast`; the title turns `text-primary`.
- Badges top-left, joined: a 26px star chip on `surface-sunken` (`text-muted`, `warning` when favourited) and a `danger` label.
- Title in the display face at 14/21, weight 500, `text-body`; genre `body-xs` `text-tertiary`, `space-2` below the cover.
- Grid: `bn-tile-grid` (`repeat(auto-fill, minmax(152px, 1fr))`, raise the minimum to 176px from 1270px and 200px from 1774px).
