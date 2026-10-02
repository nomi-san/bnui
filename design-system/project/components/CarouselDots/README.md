# CarouselDots

Position indicator for carousels: one 40×4 dash per slide.

**Provide:** the slide count, the current index (`aria-current="true"`), and a pause button when the carousel autoplays.

- Idle dashes `text-muted` (as a fill), hover `text-secondary`; current dash is 6px tall in `accent`. Gap `space-2`.
- Place them centred under the carousel, `space-3` below it; the pause control is a ghost icon button before them.
- Autoplay every 5–7s and pause on hover.
