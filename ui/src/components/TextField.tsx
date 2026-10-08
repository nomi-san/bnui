import { Show, splitProps, type JSX } from 'solid-js';
import { TextField as KTextField } from '@kobalte/core/text-field';
import { IconSearch } from './icons';
import { cx, ease, labelText } from './styles';

export type TextFieldProps = {
  label?: string;
  placeholder?: string;
  value?: string;
  defaultValue?: string;
  onChange?: (value: string) => void;
  /** Helper text under the field. */
  description?: string;
  /** Error text; also sets the warning border. */
  error?: string;
  disabled?: boolean;
  readOnly?: boolean;
  /** lg 40px (default); md 32px for dense settings rows. */
  size?: 'md' | 'lg';
  /** fill background, no border, 14px text, search icon on the right. */
  search?: boolean;
  type?: string;
  inputMode?: JSX.HTMLAttributes<HTMLInputElement>['inputMode'];
  class?: string;
  inputClass?: string;
  'aria-label'?: string;
};

/* Field box: surface-sunken + line-strong border. Hover line-hover; focus shows the accent border
   instead of the ring, and snaps; disabled line-subtle + text-disabled; error warning. Read-only
   (the native Settings path field) drops to line-subtle + text-secondary. */
const field = (size: 'md' | 'lg', search: boolean) => cx(
  'w-full rounded-md text-primary placeholder:text-tertiary transition-[border-color,background-color]', ease,
  'focus:outline-none focus:duration-0',
  size === 'md' ? 'h-control-md px-3 body-sm' : 'h-control-lg px-3 body-md',
  search
    ? 'border border-transparent bg-fill pr-9 body-sm hover:bg-fill-strong focus:border-accent'
    : 'border border-line-strong bg-surface-sunken hover:border-line-hover focus:border-accent data-[invalid]:border-warning disabled:border-line-subtle disabled:text-disabled read-only:border-line-subtle read-only:text-secondary',
);

export function TextField(props: TextFieldProps) {
  const [local] = splitProps(props, ['label', 'description', 'error', 'size', 'search', 'class', 'inputClass', 'placeholder', 'type', 'inputMode', 'aria-label']);
  return (
    <KTextField
      class={cx('grid content-start gap-2', local.class)}
      value={props.value}
      defaultValue={props.defaultValue}
      onChange={props.onChange}
      disabled={props.disabled}
      readOnly={props.readOnly}
      validationState={local.error ? 'invalid' : 'valid'}
    >
      <Show when={local.label}>
        <KTextField.Label class={labelText}>{local.label}</KTextField.Label>
      </Show>
      <div class="relative">
        <KTextField.Input
          class={cx(field(local.size ?? 'lg', !!local.search), local.inputClass)}
          placeholder={local.placeholder}
          type={local.type}
          inputMode={local.inputMode}
          aria-label={local['aria-label']}
        />
        <Show when={local.search}>
          <IconSearch class="pointer-events-none absolute right-2.5 top-1/2 size-[18px] -translate-y-1/2 text-secondary" />
        </Show>
      </div>
      <Show when={local.description && !local.error}>
        <KTextField.Description class="body-xs text-tertiary">{local.description}</KTextField.Description>
      </Show>
      <KTextField.ErrorMessage class="body-xs text-warning">{local.error}</KTextField.ErrorMessage>
    </KTextField>
  );
}

