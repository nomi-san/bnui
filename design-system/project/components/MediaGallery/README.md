# MediaGallery

Screenshots and trailers for a product: a vertical thumbnail rail beside a 16:9 stage.

**Provide:** an ordered list of images and videos (with poster frames), and the active index.

- Rail 100px wide, thumbnails 16:9 `radius-md`, gap `space-2`; opacity .6 at rest, .85 on hover, 1 when active, with a 2px `accent` frame on the active one. The rail scrolls and fades out at the bottom (`mask-image`).
- Video thumbnails carry a 24px play badge (`bn-play`, `overlay-strong`) bottom-right.
- Stage: 16:9, `radius-md`. A neutral `Badge` counter ("1 / 18") sits centred `space-4` above the bottom edge. Arrows are `bn-icon-btn--tall`, hidden until the stage is hovered; the first slide disables the previous arrow.
- Clicking the stage opens the `Lightbox` at the same index. On narrow screens the rail moves under the stage as a horizontal strip.
