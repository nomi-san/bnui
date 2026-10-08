import { splitProps, type JSX } from 'solid-js';

/* Outline icons on a 24px grid with round caps, coloured by currentColor (the design system's
   iconography rule). Size comes from the control: most set 20px, chevrons and info 16px. */
type IconProps = JSX.SvgSVGAttributes<SVGSVGElement>;

const Svg = (props: IconProps & { weight?: number }) => {
  const [local, rest] = splitProps(props, ['weight', 'children']);
  return (
    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width={local.weight ?? 1.8}
      stroke-linecap="round" stroke-linejoin="round" aria-hidden="true" {...rest}>
      {local.children}
    </svg>
  );
};

export const IconGear = (p: IconProps) => (
  <Svg {...p} weight={1.6}>
    <circle cx="12" cy="12" r="3" />
    <path d="M19.4 15a1.7 1.7 0 0 0 .3 1.8l.1.1a2 2 0 1 1-2.8 2.8l-.1-.1a1.7 1.7 0 0 0-1.8-.3 1.7 1.7 0 0 0-1 1.5V21a2 2 0 1 1-4 0v-.1a1.7 1.7 0 0 0-1.1-1.5 1.7 1.7 0 0 0-1.8.3l-.1.1a2 2 0 1 1-2.8-2.8l.1-.1a1.7 1.7 0 0 0 .3-1.8 1.7 1.7 0 0 0-1.5-1H3a2 2 0 1 1 0-4h.1a1.7 1.7 0 0 0 1.5-1.1 1.7 1.7 0 0 0-.3-1.8l-.1-.1a2 2 0 1 1 2.8-2.8l.1.1a1.7 1.7 0 0 0 1.8.3H9a1.7 1.7 0 0 0 1-1.5V3a2 2 0 1 1 4 0v.1a1.7 1.7 0 0 0 1 1.5 1.7 1.7 0 0 0 1.8-.3l.1-.1a2 2 0 1 1 2.8 2.8l-.1.1a1.7 1.7 0 0 0-.3 1.8V9a1.7 1.7 0 0 0 1.5 1H21a2 2 0 1 1 0 4h-.1a1.7 1.7 0 0 0-1.5 1Z" />
  </Svg>
);
export const IconDownload = (p: IconProps) => <Svg {...p}><path d="M12 3v12M7 10l5 5 5-5M4 21h16" /></Svg>;
export const IconGame = (p: IconProps) => (
  <Svg {...p}><rect x="3" y="6" width="18" height="12" rx="2" /><path d="M8 10v4M6 12h4M15 11h.01M18 13h.01" /></Svg>
);
export const IconFriends = (p: IconProps) => (
  <Svg {...p}><circle cx="9" cy="8" r="3.5" /><path d="M2.5 20a6.5 6.5 0 0 1 13 0M16 4.6a3.5 3.5 0 0 1 0 6.8M18.5 14.3A6.5 6.5 0 0 1 21.5 20" /></Svg>
);
export const IconMic = (p: IconProps) => (
  <Svg {...p}><rect x="9" y="3" width="6" height="11" rx="3" /><path d="M5 11a7 7 0 0 0 14 0M12 18v3" /></Svg>
);
export const IconBell = (p: IconProps) => <Svg {...p}><path d="M6 8a6 6 0 1 1 12 0c0 7 3 9 3 9H3s3-2 3-9M10.3 21a1.9 1.9 0 0 0 3.4 0" /></Svg>;
export const IconFlask = (p: IconProps) => (
  <Svg {...p}><path d="M9 3h6M10 3v6.5L4.6 18.8A1.5 1.5 0 0 0 5.9 21h12.2a1.5 1.5 0 0 0 1.3-2.2L14 9.5V3M7.5 15h9" /></Svg>
);
export const IconDocument = (p: IconProps) => (
  <Svg {...p}><path d="M14 3H6a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V9zM14 3v6h6M8 13h8M8 17h8" /></Svg>
);
export const IconClose = (p: IconProps) => <Svg {...p} weight={2}><path d="M6 6l12 12M18 6 6 18" /></Svg>;
export const IconChevronDown = (p: IconProps) => <Svg {...p} weight={2}><path d="m6 9 6 6 6-6" /></Svg>;
export const IconInfo = (p: IconProps) => <Svg {...p}><circle cx="12" cy="12" r="9" /><path d="M12 16v-4.5M12 8h.01" /></Svg>;
export const IconExternal = (p: IconProps) => (
  <Svg {...p} weight={2}><path d="M14 4h6v6M10 14 20 4M18 14v5a1 1 0 0 1-1 1H5a1 1 0 0 1-1-1V7a1 1 0 0 1 1-1h5" /></Svg>
);
export const IconSearch = (p: IconProps) => <Svg {...p} weight={2}><circle cx="11" cy="11" r="7" /><path d="m20 20-3.5-3.5" /></Svg>;
export const IconPlay = (p: IconProps) => <Svg {...p}><path d="M7 4.5v15l12-7.5z" /></Svg>;
