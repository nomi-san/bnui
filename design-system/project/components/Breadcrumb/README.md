# Breadcrumb

Shows where a detail page sits: home icon, parents, current page.

**Provide:** the trail; the last item is the current page (`aria-current="page"`, not a link).

- `body-sm`; links `text-muted` → `text-tertiary` + underline on hover; current page `text-tertiary`; 12px chevrons in `text-tertiary`, gap 6px.
- When the page scrolls, the breadcrumb bar sticks under the main nav on `surface-page`.
