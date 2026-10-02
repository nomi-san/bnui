# ProductCard

A product for sale in a grid or carousel: media, franchise line, title, callout, genre, price.

**Provide:** 16:9 key art, optional badges (`Badge`), the franchise name and its 20px icon, the title (≤3 lines), an optional callout (release date, offer), the genre, and a `Price`. Optionally a full-width primary button under the price.

- Backplate `fill`, `radius-md`, content padding `space-6`; the price is pinned to the bottom so rows align.
- Callout text is `warning`; genre `body-xs` `text-secondary`.
- Hover: backplate `fill-strong` and media `brightness(1.1)` in `duration-fast`. The whole card is one link.
- Grid: `space-6` gaps, 5 columns at the 1600px container, 4 per view in carousels.
