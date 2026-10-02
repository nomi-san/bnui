# Tabs

Switch between peer views. Two styles: app tabs for top-level navigation and content tabs inside a section.

**Provide:** 2–6 short labels and the selected one (`aria-selected="true"`).

- App tabs (`bn-tabs--app`): `tab` style, uppercase, 500 `text-tertiary` idle, 700 `text-primary` selected with a 2px `accent` underline under the text. Hover goes to `text-primary`.
- Content tabs (`bn-tab`): `button-lg` style, `text-muted` idle, `text-primary` on hover and selected; the selected tab gets a 4px full-width `accent` bar.
- Switch content instantly; don't animate the panel.
