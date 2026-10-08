import { For, Show } from 'solid-js';
import { RadioGroup as KRadioGroup } from '@kobalte/core/radio-group';
import { cx, ease, labelText } from './styles';

export type RadioGroupProps = {
  /** Two to five choices; use option cards when a choice carries a price or description. */
  options: { value: string; label: string; disabled?: boolean }[];
  value?: string;
  defaultValue?: string;
  onChange?: (value: string) => void;
  label?: string;
  orientation?: 'vertical' | 'horizontal';
  disabled?: boolean;
  class?: string;
};

/* 20px circle on surface-page, 1px line-strong border (hover text-muted); selected shows a 12px
   accent dot. Labels text-secondary, text-primary on hover, text-body when selected. */
export function RadioGroup(props: RadioGroupProps) {
  return (
    <KRadioGroup
      class={cx('grid content-start gap-2', props.class)}
      value={props.value}
      defaultValue={props.defaultValue}
      onChange={props.onChange}
      orientation={props.orientation}
      disabled={props.disabled}
    >
      <Show when={props.label}>
        <KRadioGroup.Label class={labelText}>{props.label}</KRadioGroup.Label>
      </Show>
      <div class={cx('flex gap-3', props.orientation === 'horizontal' ? 'flex-row flex-wrap gap-x-6' : 'flex-col')}>
        <For each={props.options}>
          {(opt) => (
            <KRadioGroup.Item value={opt.value} disabled={opt.disabled} class="group inline-flex items-center gap-3 cursor-pointer data-[disabled]:cursor-default">
              <KRadioGroup.ItemInput class="peer" />
              <KRadioGroup.ItemControl
                class={cx(
                  'relative size-5 flex-none rounded-full border border-line-strong bg-surface-page transition-[border-color]', ease,
                  'group-[:not([data-disabled]):hover]:border-text-muted group-data-[disabled]:border-line-subtle',
                  'peer-focus-visible:shadow-ring-focus',
                )}
              >
                <KRadioGroup.ItemIndicator class="absolute inset-[3px] rounded-full bg-accent group-data-[disabled]:bg-line-strong" />
              </KRadioGroup.ItemControl>
              <KRadioGroup.ItemLabel
                class={cx(
                  'body-sm text-secondary transition-colors', ease,
                  'group-[:not([data-checked]):not([data-disabled]):hover]:text-primary group-data-[checked]:text-body group-data-[disabled]:text-disabled',
                )}
              >
                {opt.label}
              </KRadioGroup.ItemLabel>
            </KRadioGroup.Item>
          )}
        </For>
      </div>
    </KRadioGroup>
  );
}
