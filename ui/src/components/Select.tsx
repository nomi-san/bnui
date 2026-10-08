import { Show } from 'solid-js';
import { Select as KSelect } from '@kobalte/core/select';
import { IconChevronDown } from './icons';
import { cx, ease, focusRing, labelText, menuSurface, snap } from './styles';

export type SelectProps = {
  options: string[];
  value?: string;
  defaultValue?: string;
  onChange?: (value: string) => void;
  label?: string;
  placeholder?: string;
  /** outlined: the text-field box (40px). filled: 32px fill → fill-strong, for toolbars and settings. */
  variant?: 'outlined' | 'filled';
  disabled?: boolean;
  class?: string;
  'aria-label'?: string;
};

const trigger = {
  outlined: 'h-control-lg px-3 border border-line-strong bg-surface-sunken text-primary body-md hover:border-line-hover data-[expanded]:border-accent',
  filled: 'h-control-md px-2 border-0 bg-fill text-secondary body-sm hover:bg-fill-strong hover:text-primary data-[expanded]:bg-fill-strong data-[expanded]:text-primary',
};

/* The open list is the menu surface directly below the trigger; the current option shows fill +
   a 2px accent left bar, the highlighted one fill + text-primary. */
const item = cx(
  'relative flex items-center gap-2 min-h-[30px] px-2 py-[5px] rounded-xs cursor-pointer outline-none',
  'font-body text-[14px] leading-5 text-secondary transition-colors', ease,
  'data-[highlighted]:bg-fill data-[highlighted]:text-primary',
  'data-[selected]:bg-fill data-[selected]:text-primary data-[selected]:shadow-[inset_2px_0_0_var(--accent)]',
  'data-[disabled]:text-disabled data-[disabled]:cursor-default',
);

export function Select(props: SelectProps) {
  const variant = () => props.variant ?? 'outlined';
  return (
    <KSelect<string>
      class={cx('grid content-start gap-2', props.class)}
      options={props.options}
      value={props.value}
      defaultValue={props.defaultValue}
      onChange={(v) => v !== null && props.onChange?.(v)}
      placeholder={props.placeholder}
      disabled={props.disabled}
      disallowEmptySelection
      sameWidth
      gutter={4}
      itemComponent={(p) => (
        <KSelect.Item item={p.item} class={item}>
          <KSelect.ItemLabel>{p.item.rawValue}</KSelect.ItemLabel>
        </KSelect.Item>
      )}
    >
      <Show when={props.label}>
        <KSelect.Label class={labelText}>{props.label}</KSelect.Label>
      </Show>
      <KSelect.Trigger
        aria-label={props['aria-label']}
        class={cx(
          'flex w-full items-center justify-between gap-2 rounded-md text-left cursor-pointer',
          'transition-[border-color,background-color,color]', ease, snap, focusRing,
          'disabled:cursor-not-allowed disabled:text-disabled',
          trigger[variant()],
        )}
      >
        <KSelect.Value<string> class="truncate data-[placeholder-shown]:text-tertiary">{(s) => s.selectedOption()}</KSelect.Value>
        <KSelect.Icon class="flex-none text-secondary">
          <IconChevronDown class="size-4" />
        </KSelect.Icon>
      </KSelect.Trigger>
      <KSelect.Portal>
        <KSelect.Content class={menuSurface}>
          <KSelect.Listbox class="m-0 grid list-none gap-0 p-0 outline-none" />
        </KSelect.Content>
      </KSelect.Portal>
    </KSelect>
  );
}
