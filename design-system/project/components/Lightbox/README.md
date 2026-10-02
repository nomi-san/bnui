# Lightbox

Full-screen viewer for gallery media and video.

**Provide:** the media list, the starting index, and a close handler. Trap focus inside and close on Escape.

- Backdrop `scrim` (black 80%) with a 20px backdrop blur, `z-modal`.
- An 88px top bar holds the counter (neutral `Badge`) on the left and a 40×40 ghost close button on the right.
- Media is centred, 16:9, max 1200px wide, `radius-md`, with `space-10` side padding. Previous/next arrows (`bn-icon-btn--tall`) sit outside the media edges and are always visible here.
- Opens with an opacity fade (`duration-medium`); no zoom or slide.
