import { splitProps, type JSX } from 'solid-js';
import { cx, ease, focusRing, snap } from './styles';

export type IconButtonProps = JSX.ButtonHTMLAttributes<HTMLButtonElement> & {
  /** filled: fill-strong + ring-subtle-hover. ghost: transparent text-secondary, gains fill-strong on hover. */
  variant?: 'filled' | 'ghost';
  /** sm 24px (dialog close), pill 26px, md 32px (default), lg 40px. */
  size?: 'sm' | 'pill' | 'md' | 'lg';
  'aria-label': string;
};

const variants = {
  filled: 'bg-fill-strong text-primary hover:shadow-ring-subtle-hover',
  ghost: 'bg-transparent text-secondary hover:bg-fill-strong hover:text-primary',
};

const sizes = {
  sm: 'size-control-sm [&_svg]:size-4',
  pill: 'size-control-pill [&_svg]:size-4',
  md: 'size-control-md [&_svg]:size-5',
  lg: 'size-control-lg [&_svg]:size-5',
};

export function IconButton(props: IconButtonProps) {
  const [local, rest] = splitProps(props, ['variant', 'size', 'class', 'type', 'children']);
  return (
    <button
      type={local.type ?? 'button'}
      class={cx(
        'inline-grid place-items-center p-0 border-0 rounded-md cursor-pointer',
        'transition-[box-shadow,background-color,color]', ease, snap, focusRing,
        variants[local.variant ?? 'filled'], sizes[local.size ?? 'md'],
        'disabled:bg-transparent disabled:text-disabled disabled:shadow-none disabled:cursor-not-allowed',
        local.class,
      )}
      {...rest}
    >
      {local.children}
    </button>
  );
}
