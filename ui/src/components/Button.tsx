import { splitProps, type JSX } from 'solid-js';
import { Dynamic } from 'solid-js/web';
import { cx, ease, focusRing, snap } from './styles';

export type ButtonVariant = 'primary' | 'secondary' | 'tertiary' | 'ghost';
export type ButtonSize = 'sm' | 'md' | 'lg' | 'xl';

export type ButtonProps = JSX.ButtonHTMLAttributes<HTMLButtonElement> & {
  variant?: ButtonVariant;
  size?: ButtonSize;
  block?: boolean;
  /** Renders an <a> for navigation. */
  href?: string;
};

/* Hover never changes the fill: primary gains ring-primary-hover, secondary and tertiary
   ring-secondary-hover. Pressed: primary accent-fill-pressed, others fill + text-tertiary. */
const variants: Record<ButtonVariant, string> = {
  primary: 'bg-accent-fill text-on-accent hover:shadow-ring-primary-hover active:bg-accent-fill-pressed disabled:bg-accent-fill-pressed disabled:text-muted',
  secondary: 'bg-fill-strong text-primary hover:shadow-ring-secondary-hover active:bg-fill active:text-tertiary disabled:bg-fill disabled:text-disabled',
  tertiary: 'bg-transparent text-primary shadow-ring-tertiary hover:shadow-ring-secondary-hover active:bg-fill active:text-tertiary disabled:bg-fill disabled:text-disabled',
  ghost: 'bg-transparent text-accent hover:text-accent-ring disabled:text-disabled',
};

const sizes: Record<ButtonSize, { box: string; pad: string }> = {
  sm: { box: 'min-h-control-sm rounded-sm button-sm', pad: 'px-4' },
  md: { box: 'min-h-control-md rounded-md button-md', pad: 'px-6' },
  lg: { box: 'min-h-control-lg rounded-md button-lg', pad: 'px-8' },
  xl: { box: 'min-h-control-xl rounded-md button-xl', pad: 'px-4' },
};

export function Button(props: ButtonProps) {
  const [local, rest] = splitProps(props, ['variant', 'size', 'block', 'href', 'class', 'type', 'children']);
  const variant = () => local.variant ?? 'secondary';
  const size = () => sizes[local.size ?? 'lg'];
  return (
    <Dynamic
      component={local.href ? 'a' : 'button'}
      href={local.href}
      type={local.href ? undefined : (local.type ?? 'button')}
      class={cx(
        'relative items-center justify-center gap-2 whitespace-nowrap border-0 no-underline cursor-pointer',
        local.block ? 'flex w-full' : 'inline-flex',
        'transition-[box-shadow,background-color,color]', ease, snap, focusRing,
        'disabled:cursor-not-allowed disabled:shadow-none [&_svg]:size-5 [&_svg]:flex-none',
        size().box,
        variant() === 'ghost' ? 'px-2' : size().pad,
        variants[variant()],
        local.class,
      )}
      {...rest}
    >
      {local.children}
    </Dynamic>
  );
}
