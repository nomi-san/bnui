import { Show } from 'solid-js';
import { Slider as KSlider } from '@kobalte/core/slider';
import { cx, ease, focusRing, labelText, snap } from './styles';

export type SliderProps = {
  label?: string;
  value?: number;
  defaultValue?: number;
  onChange?: (value: number) => void;
  minValue?: number;
  maxValue?: number;
  step?: number;
  /** Show the formatted value next to the label. */
  showValue?: boolean;
  disabled?: boolean;
  class?: string;
  'aria-label'?: string;
};

/* Track 3px line-strong; the filled part and the 16px thumb are accent. Hovering the slider adds a
   4px fill-strong halo to the thumb. Arrow keys, Home/End and PageUp/Down come from Kobalte. */
export function Slider(props: SliderProps) {
  return (
    <KSlider
      class={cx('group grid w-full content-start gap-2', props.class)}
      value={props.value === undefined ? undefined : [props.value]}
      defaultValue={props.defaultValue === undefined ? undefined : [props.defaultValue]}
      onChange={(v) => props.onChange?.(v[0])}
      minValue={props.minValue}
      maxValue={props.maxValue}
      step={props.step}
      disabled={props.disabled}
      aria-label={props['aria-label']}
    >
      <Show when={props.label || props.showValue}>
        <div class="flex items-center justify-between">
          <Show when={props.label}><KSlider.Label class={labelText}>{props.label}</KSlider.Label></Show>
          <Show when={props.showValue}><KSlider.ValueLabel class="body-xs text-tertiary" /></Show>
        </div>
      </Show>
      <KSlider.Track class="relative h-4 w-full cursor-pointer before:absolute before:inset-x-0 before:top-[7px] before:h-[3px] before:rounded-full before:bg-line-strong data-[disabled]:cursor-default">
        <KSlider.Fill class="absolute top-[7px] h-[3px] rounded-full bg-accent group-data-[disabled]:bg-line-strong" />
        <KSlider.Thumb
          class={cx(
            'top-0 block size-4 rounded-full bg-accent transition-[box-shadow]', ease, snap, focusRing,
            'group-[:not([data-disabled]):hover]:shadow-[0_0_0_4px_var(--fill-strong)] group-data-[disabled]:bg-line-strong',
          )}
        >
          <KSlider.Input />
        </KSlider.Thumb>
      </KSlider.Track>
    </KSlider>
  );
}
