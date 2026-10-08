import { createEffect, Show, type JSX, type ParentProps } from 'solid-js';
import { Dialog as KDialog } from '@kobalte/core/dialog';
import { IconButton } from './IconButton';
import { IconClose } from './icons';
import { cx } from './styles';

/* Window: surface-page, 1px border-solid, radius-md, shadow-lg. Header heading-lg 20/24 with a
   24px ghost close button and a line-subtle divider; footer left-aligned, primary first, gap space-2.
   Backdrop scrim + 20px blur at z-modal. Fades in over duration-medium; nothing zooms or slides. */
export const dialogPanel =
  'flex flex-col overflow-hidden border border-border-solid rounded-md bg-surface-page shadow-lg';

const head = 'flex flex-none items-center justify-between gap-4 p-6 border-b border-line-subtle';
const title = 'm-0 font-display font-bold text-[20px] leading-6 text-primary';

/* Settings layout: a 240px surface-sunken side nav beside the scrolling content. A settings window
   passes `footer` so its actions sit under the content column and the nav runs full height, as in
   the desktop app; other dialogs use the full-width DialogFooter after the layout. */
export const DialogLayout = (props: ParentProps<{ nav: JSX.Element; navFooter?: JSX.Element; footer?: JSX.Element }>) => (
  <div class="grid min-h-0 flex-1 grid-cols-[240px_minmax(0,1fr)]">
    <div class="flex min-h-0 flex-col bg-surface-sunken px-2.5 py-5">
      <div class="relative min-h-0 flex-1 overflow-auto">{props.nav}</div>
      <Show when={props.navFooter}><div class="px-4 pt-4">{props.navFooter}</div></Show>
    </div>
    <div class="flex min-h-0 min-w-0 flex-col">
      <div class="relative min-h-0 flex-1 overflow-auto p-6 text-body">{props.children}</div>
      <Show when={props.footer}>
        <div class="mx-6 flex flex-none gap-2 border-t border-line-subtle py-4">{props.footer}</div>
      </Show>
    </div>
  </div>
);

/* Settings section: heading-md title, fields indented space-6 below it. */
export const DialogSection = (props: ParentProps<{ title: string; class?: string }>) => (
  <section class="mb-8 last:mb-0">
    <h3 class="heading-md m-0 mb-4 text-primary">{props.title}</h3>
    <div class={cx('grid gap-5 pl-6', props.class)}>{props.children}</div>
  </section>
);

export const DialogFooter = (props: ParentProps) => (
  <div class="flex flex-none gap-2 border-t border-line-subtle px-6 py-4">{props.children}</div>
);

/* Static window for showcases and screenshot parity: same parts, no portal, no focus trap. */
export const DialogFrame = (props: ParentProps<{ title: string; onClose?: () => void; class?: string }>) => (
  <section role="dialog" aria-label={props.title} class={cx(dialogPanel, props.class)}>
    <div class={head}>
      <h2 class={title}>{props.title}</h2>
      <IconButton variant="ghost" size="sm" aria-label="Close" onClick={() => props.onClose?.()}><IconClose /></IconButton>
    </div>
    {props.children}
  </section>
);

export type DialogProps = ParentProps<{
  open: boolean;
  onOpenChange: (open: boolean) => void;
  title: string;
  /** Size of the window, e.g. "w-[996px] max-w-full h-[708px]". Defaults to "w-full max-w-[800px]". */
  class?: string;
}>;

/* Modal: focus trap, Escape and the close button dismiss it (Kobalte). Opened from anywhere (no
   Dialog.Trigger), so it remembers what had focus and hands focus back on close. */
export function Dialog(props: DialogProps) {
  let returnFocus: HTMLElement | null = null;
  createEffect(() => {
    if (!props.open) return;
    returnFocus = document.activeElement as HTMLElement | null;
    // The page behind gets aria-hidden while open; don't leave focus inside it meanwhile.
    returnFocus?.blur();
  });
  return (
    <KDialog open={props.open} onOpenChange={props.onOpenChange}>
      <KDialog.Portal>
        <KDialog.Overlay class="fixed inset-0 z-modal bg-scrim backdrop-blur-[20px] data-[expanded]:animate-fade-in" />
        <div class="fixed inset-0 z-modal grid place-items-center p-6">
          <KDialog.Content
            class={cx(dialogPanel, 'max-h-[calc(100%-48px)] data-[expanded]:animate-fade-in', props.class ?? 'w-full max-w-[800px]')}
            onCloseAutoFocus={(e) => { if (returnFocus?.isConnected) { e.preventDefault(); returnFocus.focus(); } }}
          >
            <div class={head}>
              <KDialog.Title class={title}>{props.title}</KDialog.Title>
              <KDialog.CloseButton
                as={IconButton}
                variant="ghost"
                size="sm"
                aria-label="Close"
              >
                <IconClose />
              </KDialog.CloseButton>
            </div>
            {props.children}
          </KDialog.Content>
        </div>
      </KDialog.Portal>
    </KDialog>
  );
}
