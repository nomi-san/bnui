/* Shared class fragments. Values come from the BNUI preset (tailwind/bnui-preset.cjs). */

export const cx = (...parts: (string | false | null | undefined)[]) => parts.filter(Boolean).join(' ');

/* Hovers ease with duration-fast; focus and press snap, as in the native desktop app.
   data-motion="instant" on <html> or a container zeroes the hover duration too. */
export const ease = 'duration-fast ease-out';
export const snap = 'focus-visible:duration-0 active:duration-0';

/* One keyboard focus ring everywhere: 2px focus-inner gap + 2px focus-outer. */
export const focusRing = 'focus-visible:outline-none focus-visible:shadow-ring-focus';

/* Uppercase field and group label (the `label` type style). */
export const labelText = 'label uppercase text-secondary';

/* Floating surface for menus and dropdown lists. */
export const menuSurface =
  'min-w-[220px] p-2 border border-border-solid rounded-md bg-surface-raised shadow-sm text-secondary z-menu animate-fade-in';
