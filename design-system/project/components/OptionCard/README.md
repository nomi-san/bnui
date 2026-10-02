# OptionCard

Radio cards for choosing an edition or plan, with a name and a price.

**Provide:** a group `label` ("SELECT A PRODUCT"), optionally a "Compare" link on the right, and per option a name (`heading-md`) and a `Price`.

- Rest: transparent, 1px `line-subtle` outline, text `text-secondary`. Hover: `fill`, `text-primary`.
- Selected (`aria-checked="true"`): `fill`, `text-primary`, and an 8px `accent` bar inside the left edge (inset shadow, so nothing shifts).
- Stack options `space-2` apart, full width of the purchase column (`aside-width`).
