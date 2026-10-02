# design-sync notes (BNUI)

Target: claude.ai/design project `2d54865a-c246-4107-bd5a-16b428495b7b` ("BNUI"), pinned in `config.json`.

## Shape: off-script, CSS-only (Modernist-style)

- BNUI has no React components and no `dist/`, so the converter (`package-build.mjs`) is not used. `.design-sync/build.py` produces the upload layout directly from `design-system/project/` (the Design System artifact mirror):
  `python .design-sync/build.py` -> `ds-bundle/`
- Output: `styles.css` (@imports Google Fonts + `tokens/bnui-tokens.css` + `_ds_bundle.css`), `_ds_bundle.js` (empty `window.BNUI` stub with a valid `@ds-bundle` header, 0 components), `README.md` (= `conventions.md` + generated Components table + brand book), `thumbnail.html` (from `components/Cover`), and `components/<Group>/<Name>/<Name>.{html,prompt.md}` for 37 components + 4 Foundations cards. No `.jsx` / `.d.ts`: the design agent uses `bn-` classes, not a JS API.
- `.ds-build-meta.json` and `.review.html` are local-only (dot files are never uploaded). `.review.html` frames every card at its viewport, for visual review: serve `ds-bundle/` (`python -m http.server --directory ds-bundle`) and open `/.review.html`.
- No `_ds_sync.json` anchor: the hash recipe needs converter facts this layout doesn't have. The next sync re-verifies everything, which is fine for 41 static cards.

## Verify before upload

1. `node .ds-sync/package-validate.mjs ./ds-bundle --no-render-check` must end "bundle is complete" (the 2 warnings, no `_ds_sync.json` and RENDER_SKIPPED, are expected). Stage the scripts first: copy the design-sync skill's `package-*.mjs`, `resync.mjs`, `lib/` into `.ds-sync/`.
2. The render check is done by hand in Chrome on `.review.html`: every card is styled, complete, and has no overflow (`scrollHeight == clientHeight` in each frame), with web fonts and with the fallback stack forced.

## Card heights

- `card-heights.json` holds each card's viewport height: the measured content bottom (in Chrome) + 24px, rounded up to 10. Re-measure when a preview changes; cards not listed fall back to the artifact preview height + 40.
- Backdrop cards (Dialog, Lightbox): the build swaps the backdrop's fixed height for `100vh` so the scrim fills the card; the viewport equals the old backdrop height (Lightbox 420 so its stage fits).
- The card scaffolding sets `html { scrollbar-width: none }`: a scrollbar stealing 15px made the Button card's first row wrap and the card grow (a feedback loop). Button is 820 wide for slack.

## Fonts

- Display face is Object Sans in the brand book (licensed, not shipped). Figtree (Google Fonts) is the substitute in `--font-display`; body is Noto Sans (Google Fonts). Both arrive via the remote @import in `styles.css`, so the validator's FONT_MISSING stays quiet.
- Claude Design shows "Missing brand font" for ANY family named in a font token without font files, even with fallbacks after it (the validator does not catch this). So the build drops `UNSHIPPED_FONTS` (Object Sans) from the uploaded stacks and rewrites the brand-book sentence; `tokens.json` and the artifact keep Object Sans as the brand reference. If licensed Object Sans files become available: add them under `fonts/` with `@font-face` imported from `styles.css`, remove it from `UNSHIPPED_FONTS`, and add `fonts/**` to the upload plan.

## Re-sync

- Edit `design-system/project/` (and republish the artifact) -> `python .design-sync/build.py` -> validate -> review in Chrome -> upload into the pinned project via the atomic path (sentinel `_ds_needs_recompile` first, content writes, deletes for dropped paths, sentinel re-arm). No `_ds_sync.json` to write.
- Windows: the build clears `ds-bundle/`'s contents instead of deleting the folder, because a running preview server keeps the folder locked.
