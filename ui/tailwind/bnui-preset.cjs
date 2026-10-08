/* BNUI Tailwind preset: every value comes from design-system/project/tokens.json (the same file
   that feeds the Design System artifact and the Claude Design bundle).

   - addBase writes the tokens as CSS variables: :root (+ the first accent theme), one
     [data-theme="<id>"] block per further accent theme, and the [data-motion="instant"] override.
   - The theme maps Tailwind scales onto those variables, so accent themes and instant motion
     switch at runtime with no rebuild: bg-fill-strong, text-secondary, rounded-md,
     shadow-ring-focus, duration-fast, z-modal, h-control-md ...
   - Type styles (heading-md, label, body-sm ...) are component classes that set the whole font. */
const fs = require('fs');
const path = require('path');
const plugin = require('tailwindcss/plugin');

const TOKENS = path.resolve(__dirname, '../../design-system/project/tokens.json');
const t = JSON.parse(fs.readFileSync(TOKENS, 'utf8'));

const esc = (name) => name.replace(/\./g, '\\.');
const cssVar = (name) => `var(--${esc(name)})`;
const tokens = (family) => (t[family] && t[family].tokens) || [];
const themes = t.color.themes.map((th) => th.id);
const first = themes[0];

// --- CSS variables -----------------------------------------------------------
const rootVars = {};
const themeVars = Object.fromEntries(themes.slice(1).map((id) => [id, {}]));
for (const tok of [...t.color.tokens, ...tokens('shadow')]) {
  const v = tok.value;
  if (typeof v === 'string') { rootVars[`--${esc(tok.name)}`] = v; continue; }
  rootVars[`--${esc(tok.name)}`] = v[first];
  for (const id of themes.slice(1)) if (v[id] !== undefined) themeVars[id][`--${esc(tok.name)}`] = v[id];
}
const scalarVars = {};
for (const family of ['spacing', 'radius', 'duration', 'easing', 'size', 'zIndex']) {
  for (const tok of tokens(family)) scalarVars[`--${esc(tok.name)}`] = tok.value;
}
for (const [key, stack] of Object.entries(t.type.families)) scalarVars[`--font-${key}`] = stack;

const instant = Object.fromEntries(tokens('duration').filter((d) => d.name !== 'duration-instant').map((d) => [`--${esc(d.name)}`, '0ms']));

// --- theme scales ------------------------------------------------------------
const strip = (prefix) => (name) => name.startsWith(prefix) ? name.slice(prefix.length) : name;
const scale = (family, keyOf) => Object.fromEntries(tokens(family).map((tok) => [keyOf(tok.name), cssVar(tok.name)]));

const colors = { transparent: 'transparent', current: 'currentColor', inherit: 'inherit', ...Object.fromEntries(t.color.tokens.map((tok) => [tok.name, cssVar(tok.name)])) };
// text-primary / text-secondary ... instead of text-text-primary
const textShortcuts = Object.fromEntries(t.color.tokens.filter((tok) => tok.name.startsWith('text-')).map((tok) => [tok.name.slice(5), cssVar(tok.name)]));
// h-control-md, min-h-control-lg, max-w-content-max, w-sidebar-width ...
const sizes = scale('size', (n) => n);

const typeClasses = {};
for (const group of t.type.groups) {
  for (const s of group.styles) {
    const fam = s.family || group.family;
    typeClasses[`.${esc(s.name)}`] = {
      font: `${s.fontWeight} ${s.fontSize}/${s.lineHeight} var(--font-${fam})`,
      ...(s.letterSpacing ? { letterSpacing: s.letterSpacing } : {}),
    };
  }
}

module.exports = {
  theme: {
    colors,
    borderRadius: { none: '0', DEFAULT: cssVar('radius-md'), ...scale('radius', strip('radius-')) },
    boxShadow: { none: 'none', ...scale('shadow', strip('shadow-')) },
    zIndex: { auto: 'auto', 0: '0', 1: '1', ...scale('zIndex', strip('z-')) },
    fontFamily: Object.fromEntries(Object.keys(t.type.families).map((key) => [key, `var(--font-${key})`])),
    extend: {
      textColor: textShortcuts,
      spacing: { ...scale('spacing', strip('space-')), ...sizes },
      maxWidth: sizes,
      transitionDuration: { DEFAULT: cssVar('duration-fast'), ...scale('duration', strip('duration-')) },
      transitionTimingFunction: { DEFAULT: cssVar('ease-out'), ...scale('easing', strip('ease-')) },
      keyframes: { 'bn-fade-in': { from: { opacity: '0' }, to: { opacity: '1' } } },
      animation: { 'fade-in': `bn-fade-in ${cssVar('duration-medium')} ${cssVar('ease-out')}` },
    },
  },
  plugins: [
    plugin(({ addBase, addComponents }) => {
      addBase({
        [`:root, [data-theme="${first}"]`]: rootVars,
        ...Object.fromEntries(Object.entries(themeVars).map(([id, vars]) => [`[data-theme="${id}"]`, vars])),
        ':root': scalarVars,
        // Native-app feel: every duration 0ms. Combines with any data-theme.
        ':root[data-motion="instant"], [data-motion="instant"]': instant,
      });
      addComponents(typeClasses);
    }),
  ],
};
