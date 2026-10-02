# Button

Buttons trigger an action; one primary per view, everything else secondary, tertiary or ghost.

**Provide:** a verb label in Title Case ("Buy Now", "Install", "Add to Wishlist"), optionally a 20px leading icon. Use `<button>` for actions and `<a class="bn-btn">` for navigation.

**Variants:** `bn-btn--primary` (`accent-fill`, `on-accent` text), default secondary (`fill-strong`), `bn-btn--tertiary` (transparent + `ring-tertiary`), `bn-btn--ghost` (`accent` text, for "Compare"-style inline actions).
**Sizes:** `bn-btn--sm` 24px (`button-sm`), `bn-btn--md` 32px (`button-md`), default 40px (`button-lg`), `bn-btn--xl` 56px (`button-xl`, the screen's hero action only). `bn-btn--block` fills its container.

- Hover never changes the fill: primary gains `ring-primary-hover`, secondary and tertiary gain `ring-secondary-hover`, in `duration-fast`.
- Pressed primary uses `accent-fill-pressed`; disabled primary uses `accent-fill-pressed` with `text-muted`.
- Don't put two primary buttons side by side; pair primary with secondary ("Done" + "Reset to Defaults", gap `space-2`).
