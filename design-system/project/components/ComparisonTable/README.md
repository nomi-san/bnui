# ComparisonTable

Compare editions feature by feature, with a buy button per column.

**Provide:** the editions (16:9 image, name, price, buy handler) as columns, and the features as rows with a value per edition (a check, a dash or short text). Group rows are optional.

- Header cells: image `radius-md`, name `heading-md`, full-width primary button showing the price, gap `space-4`, aligned to the bottom.
- Body rows 56px, `body-sm`; the feature name column is `text-secondary`, values are centred. Odd rows get `fill` (zebra); a group row is `line` with a rounded top and bold `text-primary`.
- Included = 24px check icon in `text-primary`; not included = an em dash in `text-muted`.
- Columns are at least 200px; the table scrolls horizontally inside its container with 53px fades in `surface-page` at the edges. Once scrolled past, the header sticks with `shadow-sticky` and hides its images.
