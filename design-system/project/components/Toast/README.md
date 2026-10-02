# Toast

A brief confirmation or system message that appears in the corner and leaves on its own.

**Provide:** a title (a past-tense outcome: "Download complete"), an optional sentence, an optional single action, the status, and a close handler.

- The one light surface in the system: `surface-inverse` with `on-inverse` text, `radius-md`, `shadow-lg`, 380px wide. A 32px status strip on the left holds a 20px icon: `info` / `success-strong` / `warning` with `on-inverse`, `danger-strong` with `on-danger`.
- Stack bottom-right (`bn-toasts`, `space-6` from the edges, gap `space-2`, `z-toast`), newest at the bottom. Auto-dismiss after about 5s unless hovered; errors stay until closed. Announce with `role="status"` (`role="alert"` for errors).
- Fade in and out with `duration-medium`; don't slide.
