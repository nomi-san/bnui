# BNUI design system

BNUI is a dark interface for game storefronts, launchers and account dashboards. It is plain HTML + CSS: **no JavaScript components and no provider**. Everything comes from one stylesheet.

## Setup (every page)

```html
<link rel="stylesheet" href="styles.css">   <!-- adjust the relative path -->
<body>                                         <!-- styles.css paints body with surface-page -->
```

- `styles.css` imports the token sheet (`tokens/bnui-tokens.css`), the component layer (`_ds_bundle.css`) and the web fonts. Without it nothing is styled.
- **Accent theme:** the default is Bnet Blue. Put `data-theme="oc-blue|oc-indigo|oc-violet|oc-grape|oc-pink|oc-teal|oc-orange"` on `<html>` (or any container) to swap only the accent tokens. Never hard-code the accent.

## Styling idiom: tokens + `bn-` classes

- Build with the `bn-` component classes (table under **Components**). For your own layout glue use only `var(--…)` tokens:
  - surfaces `--surface-page|sunken|raised|strong|highest`; white-alpha fills `--fill-subtle|fill|fill-strong`; lines `--line-subtle|line|line-strong`; text `--text-primary|body|secondary|tertiary|muted|disabled`
  - accent `--accent-fill` (primary fill), `--accent` (links, selection, focus), `--accent-ring`, `--on-accent`; status `--success`, `--warning`, `--danger`, `--info` (+ `-tint`, `-line`)
  - spacing `--space-1|2|3|4|5|6|8|10|12|16|20` (4→80px); radius `--radius-xs|sm|md|panel|lg|xl|full` (md = 4px default); shadows `--shadow-sm|md|tile|lg`; rings `--ring-primary-hover|secondary-hover|subtle-hover|focus`; motion `--duration-fast` (100ms) + `--ease-out`; sizes `--control-sm|pill|md|lg|xl`, `--content-max` (1600px)
  - fonts `--font-display` (headings, buttons, labels) and `--font-body` (text)
- Type classes (set the whole font): `.display-xl .display-lg .heading-xxl .heading-xl .heading-lg .heading-md .heading-sm .heading-xs .eyebrow .label .tab .button-xl/lg/md/sm .price .countdown .body-xl .body-lg .body-md .body-sm .body-sm-strong .body-xs`. Uppercase `.eyebrow`, `.label`, `.tab` yourself with `text-transform: uppercase`.
- Rules the agent must keep: one primary button per view; hover changes colour, fill or an inset ring only (100ms), never layout; selected = accent underline in horizontal nav, accent left bar in vertical lists; media is 16:9 (`aspect-ratio`) with `--radius-md`; separate content with fills, not borders or shadows.

## Where the truth lives

`styles.css` → `tokens/bnui-tokens.css` (every variable and type class) and `_ds_bundle.css` (every `bn-` class). Each component has a card `components/<Group>/<Name>/<Name>.html` (copy its markup) and usage notes in `<Name>.prompt.md`.

## Example

```html
<section style="max-width:var(--content-max);margin:0 auto;padding:var(--space-16) var(--space-4);display:grid;gap:var(--space-4)">
  <div class="bn-section-head"><h2 class="bn-section-head__title">Recommended</h2>
    <a class="bn-btn bn-btn--tertiary bn-btn--sm" href="#">Visit Shop</a></div>
  <div style="display:grid;grid-template-columns:repeat(auto-fill,minmax(260px,1fr));gap:var(--space-6)">
    <a class="bn-card" href="#">
      <div class="bn-card__media" style="background:var(--surface-strong)"><div class="bn-card__badges"><span class="bn-badge bn-badge--positive">New</span></div></div>
      <div class="bn-card__body"><div class="bn-card__eyebrow">Iron Front</div><h3 class="bn-card__title">Iron Front 2</h3><div class="bn-card__meta">Action Shooter</div></div>
      <div class="bn-card__foot"><span class="bn-price">$69.99</span></div>
    </a>
  </div>
</section>
```
