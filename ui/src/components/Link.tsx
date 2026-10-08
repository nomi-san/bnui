import { Show, splitProps, type JSX } from 'solid-js';
import { IconExternal } from './icons';
import { cx, ease, focusRing, snap } from './styles';

export type LinkProps = JSX.AnchorHTMLAttributes<HTMLAnchorElement> & {
  /** inline: accent, bold, underlined (prose). plain: no underline (helper links). subtle: text-muted fine print. */
  variant?: 'inline' | 'plain' | 'subtle';
  /** Adds the trailing "arrow out of box" icon for external destinations. */
  external?: boolean;
};

const variants = {
  inline: 'text-accent font-bold underline hover:text-accent-ring',
  plain: 'text-accent font-bold no-underline hover:text-accent-ring',
  subtle: 'text-muted font-normal no-underline hover:text-tertiary hover:underline',
};

export function Link(props: LinkProps) {
  const [local, rest] = splitProps(props, ['variant', 'external', 'class', 'children']);
  return (
    <a
      class={cx(
        'cursor-pointer rounded-xs [text-underline-position:under] transition-colors', ease, snap, focusRing,
        variants[local.variant ?? 'inline'], local.class,
      )}
      {...(local.external ? { target: '_blank', rel: 'noreferrer' } : {})}
      {...rest}
    >
      {local.children}
      <Show when={local.external}>
        <IconExternal class="ml-0.5 inline-block size-[.75em] align-baseline" />
      </Show>
    </a>
  );
}
