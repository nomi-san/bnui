import { For, Show, type Component, type JSX } from 'solid-js';
import { cx, ease, focusRing, snap } from './styles';

export type SideNavItem = {
  id: string;
  label: string;
  icon?: Component<JSX.SvgSVGAttributes<SVGSVGElement>>;
  disabled?: boolean;
  /** Draw a line-subtle divider above this item (group separator). */
  divider?: boolean;
};

export type SideNavProps = {
  items: SideNavItem[];
  current: string;
  onSelect: (id: string) => void;
  /** default: the web side nav (48px rows, body-md, 4px bar, sidebar-width).
      dialog: the desktop app's Settings nav (36px rows, 14px, 2px bar), see capture/app-qt. */
  density?: 'default' | 'dialog';
  'aria-label': string;
  class?: string;
};

/* default — current: surface-highest + 4px accent left bar (inset shadow, so the label never shifts);
   hover surface-strong.
   dialog — the native Settings nav (QSS #secondLevelTabs): 36px rows 4px apart, radius-xs, 14px text
   in text-tertiary; hover and current fill (white/6%), current text-primary with a 2px accent bar
   inset 2px top and bottom, rounded on its outer edge. Icons follow the label colour.
   Disabled: text-disabled, no hover. */
export function SideNav(props: SideNavProps) {
  const dialog = () => props.density === 'dialog';
  const look = (current: boolean, disabled?: boolean) => {
    if (dialog()) {
      return cx(
        'relative min-h-9 gap-1.5 rounded-xs text-[14px] [&_svg]:text-current',
        disabled ? 'bg-transparent text-disabled cursor-default'
          : current ? 'bg-fill text-primary before:absolute before:inset-y-0.5 before:left-0 before:w-0.5 before:rounded-l-xs before:bg-accent'
            : 'bg-transparent text-tertiary hover:bg-fill hover:text-primary',
      );
    }
    return cx(
      'min-h-12 gap-3 rounded-md text-[16px] [&_svg]:text-secondary',
      disabled ? 'bg-transparent text-disabled cursor-default [&_svg]:text-disabled'
        : current ? 'bg-surface-highest text-primary shadow-[inset_4px_0_0_var(--accent)]'
          : 'bg-transparent text-primary hover:bg-surface-strong',
    );
  };
  return (
    <nav aria-label={props['aria-label']} class={props.class}>
      <ul class="m-0 grid list-none gap-1 p-0">
        <For each={props.items}>
          {(item) => {
            const current = () => props.current === item.id;
            return (
              <>
                <Show when={item.divider}>
                  <li role="separator" class="mx-4 my-1 h-0 border-t border-line-subtle" />
                </Show>
                <li>
                  <button
                    type="button"
                    disabled={item.disabled}
                    aria-current={current() ? 'page' : undefined}
                    onClick={() => props.onSelect(item.id)}
                    class={cx(
                      'flex w-full items-center border-0 px-4 text-left font-body leading-5 cursor-pointer',
                      'transition-[background-color,color]', ease, snap, focusRing,
                      '[&_svg]:size-5 [&_svg]:flex-none', look(current(), item.disabled),
                    )}
                  >
                    <Show when={item.icon}>{(Icon) => { const I = Icon(); return <I />; }}</Show>
                    {item.label}
                  </button>
                </li>
              </>
            );
          }}
        </For>
      </ul>
    </nav>
  );
}
