# HeroCarousel

The full-width promotional carousel at the top of store and home pages.

**Provide:** per slide, key art (cover-fit), an optional 320×168 logo, a headline (one or two lines), an optional line of copy, one primary CTA, and the slide's median colour as `--hero-tone` for the scrim.

- Slide 360px tall, `radius-md`, `surface-strong` behind the art, padding `space-4` × `space-20`; the text block is 420px, centred text, left of the art.
- Scrim: `linear-gradient(45deg, tone 20%, transparent 50%)` + the same at 90deg, so text always sits on solid colour.
- Headline `heading-lg`, copy `body-md` `text-secondary`, CTA `bn-btn--primary` (default size).
- Arrows: `bn-icon-btn--tall` docked `space-6` inside each edge, hidden until the carousel is hovered or focused (`duration-medium` fade). Pause button bottom-left; `CarouselDots` centred 10px below.
- Autoplay 5s, pause on hover, loop, slide gap `space-3`.
