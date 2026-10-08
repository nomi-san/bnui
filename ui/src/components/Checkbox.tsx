import type { JSX } from 'solid-js';
import { Checkbox as KCheckbox } from '@kobalte/core/checkbox';
import { cx, ease } from './styles';

export type CheckboxProps = {
  label: JSX.Element;
  checked?: boolean;
  defaultChecked?: boolean;
  onChange?: (checked: boolean) => void;
  disabled?: boolean;
  /** Indent a dependent option under its parent (space-6). */
  nested?: boolean;
  class?: string;
};

/* 20px box on surface-sunken, 1px line-hover border, radius-sm; hover border accent. Checked is an
   accent tick with no fill. Disabled: border line-subtle, label text-disabled. The whole row clicks. */
export function Checkbox(props: CheckboxProps) {
  return (
    <KCheckbox
      class={cx('group inline-flex items-center gap-3 cursor-pointer data-[disabled]:cursor-default', props.nested && 'ml-6', props.class)}
      checked={props.checked}
      defaultChecked={props.defaultChecked}
      onChange={props.onChange}
      disabled={props.disabled}
    >
      <KCheckbox.Input class="peer" />
      <KCheckbox.Control
        class={cx(
          'relative size-5 flex-none rounded-sm border border-line-hover bg-surface-sunken transition-[border-color]', ease,
          'group-[:not([data-disabled]):hover]:border-accent group-data-[disabled]:border-line-subtle',
          'peer-focus-visible:shadow-ring-focus',
        )}
      >
        <KCheckbox.Indicator class="absolute left-[6px] top-[2px] h-[11px] w-[6px] rotate-45 border-b-[2.5px] border-r-[2.5px] border-accent group-data-[disabled]:border-line-strong" />
      </KCheckbox.Control>
      <KCheckbox.Label class="body-sm text-body group-data-[disabled]:text-disabled">{props.label}</KCheckbox.Label>
    </KCheckbox>
  );
}
