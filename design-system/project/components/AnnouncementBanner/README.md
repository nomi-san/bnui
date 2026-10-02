# AnnouncementBanner

A sticky bar at the bottom of the window announcing a launch, with a countdown and one CTA.

**Provide:** a 64×48 game icon, a headline (`heading-lg`), one or two lines of copy, a `Countdown`, a primary CTA, background art (cover-fit), and a dismiss handler.

- `position: sticky; bottom: 0`, `z-overlay`, `surface-strong` under the art, with side scrims (`surface-strong` 20% → transparent 50%) so text and the CTA sit on solid colour.
- Inner row max 1400px, padding `space-4` × `space-10`, gap `space-8`: lead (icon + text) left, countdown centre, CTA pushed right.
- Copy is `body-md` at 16/17 in `text-muted`, max 450px, balanced. Close is a ghost icon button top-right.
- Dismissing fades it out over `duration-slow` and keeps it closed for the session.
