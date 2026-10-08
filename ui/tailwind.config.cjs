/** @type {import('tailwindcss').Config} */
module.exports = {
  presets: [require('./tailwind/bnui-preset.cjs')],
  content: ['./index.html', './src/**/*.{ts,tsx}'],
};
