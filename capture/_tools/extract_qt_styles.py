"""Extract the Battle.net desktop app's native Qt styles (QML + QSS) into capture/app-qt/.

The app keeps its Qt UI in Battle.net.mpq (an MPQ v1 archive next to Battle.net.exe):
plain-text QML under resources/{common,main,play,test}/, the Qt Widgets stylesheet
resources/battle.net.css, and the dark-theme control skins (SVG + 9-patch PNG).
Nothing is compiled, so "decompiling" is unpacking plus a little analysis:

  qml/                 every .qml file + common/util.js (legacy launcher UI)
  qss/                 battle.net.css and styled_dialog/*.css as shipped
  qss/darktheme.css    the rules behind the current dark dialogs (Settings, menus, toasts)
  assets/              the dark-theme SVG/PNG skins those rules point at
  tokens-qss-dark.json every colour in darktheme.css and the assets, mapped to BNUI tokens

Text files are written with LF line endings. Fonts are not copied (Object Sans and the
Blizzard faces are licensed).

Needs: pip install mpyq pillow
Run from the repo root:  python capture/_tools/extract_qt_styles.py [install dir]
"""
import collections, glob, json, re, sys
from pathlib import Path

import mpyq
from PIL import Image

ROOT = Path(__file__).resolve().parent.parent.parent
OUT = ROOT / 'capture' / 'app-qt'
TOKENS = ROOT / 'design-system' / 'project' / 'tokens.json'
PAGE = (0x15, 0x17, 0x1e)  # surface-page, the background every dark dialog paints

# Rules that make up the current dark look. Most carry [darktheme=true]; the Settings
# dialog, QMenu, the Dark* widgets, the login cog menu, tooltips (ArrowPopup), scrollbars
# and radio buttons are dark without the attribute (checked against screenshots).
DARK_SELECTORS = re.compile(r'darktheme|Phoenix--Dark|^QMenu|style~="dark"|style~="settings"|optionHeader|'
                            r'ClientSettings|SettingsTab|SettingsAccordion|GameInstallUpdateSettings|'
                            r'GameUpdateSettingWidget|GameSettingsWidget|InDevelopmentSettings|AboutSettings|'
                            r'VoiceSettingsWidget|VoiceMenu|loginSettings|Phoenix--ArrowPopup|ToolTipInternal|'
                            r'^QScrollBar|^QRadioButton')
NINE_PATCHES = ['images/darktheme/contextMenu_border.png', 'images/darktheme/contextMenu_border_shadow.png',
                'controls/darktheme/toast_base_dark.png', 'controls/darktheme/toast_base_dark_hover.png']


def find_install():
    dirs = [d for d in glob.glob(r'C:\Program Files (x86)\Battle.net\Battle.net.*') if d.rsplit('.', 1)[1].isdigit()]
    dirs.sort(key=lambda d: int(d.rsplit('.', 1)[1]))
    return Path(dirs[-1]) if dirs else None


def app_version(install):
    m = re.search(rb'Phoenix (\d+\.\d+\.\d+\.\d+)', (install / 'battle.net.dll').read_bytes())
    return m.group(1).decode() if m else install.name


def lf(data): return data.replace(b'\r\n', b'\n')


def write(rel, data):
    p = OUT / rel
    p.parent.mkdir(parents=True, exist_ok=True)
    p.write_bytes(data)


# --- QSS -------------------------------------------------------------------

def parse_qss(text):
    text = re.sub(r'/\*.*?\*/', '', text.replace('\r', ''), flags=re.S)
    text = re.sub(r'\{(\w+)\}', lambda m: '<' + m.group(1) + '>', text)  # {font_list} etc., filled in by FontEngine
    rules = []
    for m in re.finditer(r'([^{}]+)\{([^{}]*)\}', text):
        sels = [s.strip() for s in m.group(1).split(',') if s.strip()]
        decls = [tuple(x.strip() for x in d.split(':', 1)) for d in m.group(2).split(';') if ':' in d]
        rules.append((sels, decls))
    return rules


def is_dark(sels, decls):
    return any(DARK_SELECTORS.search(s) for s in sels) or any('darktheme/' in v for _, v in decls)


def format_rules(rules):
    return '\n\n'.join(',\n'.join(s) + '\n{\n' + ''.join(f'\t{k}: {v};\n' for k, v in d) + '}' for s, d in rules)


# --- colours ---------------------------------------------------------------

def to_hex(r, g, b, a=255):
    return '#%02x%02x%02x' % (r, g, b) + ('' if a >= 255 else '%02x' % a)


def css_colours(value):
    """Every colour literal in a QSS value, as #rrggbb or #rrggbbaa."""
    out = []
    for m in re.finditer(r'#([0-9a-fA-F]{8}|[0-9a-fA-F]{6}|[0-9a-fA-F]{3})\b', value):
        h = m.group(1).lower()
        out.append('#' + (''.join(c * 2 for c in h) if len(h) == 3 else h))
    for m in re.finditer(r'rgba?\(([^)]*)\)', value):
        parts = [p.strip() for p in m.group(1).split(',')]
        r, g, b = (int(float(p)) for p in parts[:3])
        a = 255
        if len(parts) == 4:
            p = parts[3]
            a = round(float(p[:-1]) * 2.55) if p.endswith('%') else round(float(p) * 255) if float(p) <= 1 else int(p)
        out.append(to_hex(r, g, b, a))
    return out


def svg_colours(text):
    """fill/stroke colours of an SVG, folding in a fill-opacity/stroke-opacity or a wrapping <g opacity>."""
    out = []
    group = re.search(r'<g[^>]*\sopacity="([\d.]+)"', text)
    for m in re.finditer(r'<(\w+)([^>]*)>', text):
        attrs = dict(re.findall(r'([\w-]+)="([^"]*)"', m.group(2)))
        for prop in ('fill', 'stroke'):
            v = attrs.get(prop, '')
            if not v.startswith('#') and v not in ('white', 'black'):
                continue
            h = {'white': '#ffffff', 'black': '#000000'}.get(v, v.lower())
            if len(h) == 4: h = '#' + ''.join(c * 2 for c in h[1:])
            op = float(attrs.get(prop + '-opacity', attrs.get('opacity', 1)))
            if group and m.group(1) != 'g' and m.start() > group.start(): op *= float(group.group(1))
            out.append(h + ('' if op >= 1 else '%02x' % round(op * 255)))
    return out


def nine_patch(img):
    """Fill and 1px border colour of a dark 9-patch: centre pixel, and the first (nearly) opaque pixel on the middle row."""
    w, h = img.size
    row = [img.getpixel((x, h // 2)) for x in range(w // 2)]
    border = next(p for p in row if p[3] >= 240)  # the shadowed variant anti-aliases its border to 95%
    return [to_hex(*border[:3]), to_hex(*img.getpixel((w // 2, h // 2))[:3])]


def bnui_index():
    t = json.loads(TOKENS.read_text(encoding='utf-8'))
    idx = collections.defaultdict(list)
    for tok in t['color']['tokens']:
        v = tok['value']
        v = v.get('bnet') if isinstance(v, dict) else v
        if isinstance(v, str) and v.startswith('#'): idx[v.lower()].append(tok['name'])
    return idx


def white_over_page(hexv):
    """For an opaque grey: the white alpha that composites to it over surface-page, if one fits all channels."""
    if len(hexv) != 7: return None
    c = [int(hexv[i:i + 2], 16) for i in (1, 3, 5)]
    alphas = [(c[i] - PAGE[i]) / (255 - PAGE[i]) for i in range(3)]
    a = sum(alphas) / 3
    if a <= 0.01 or a >= 1: return None
    if any(abs(PAGE[i] + a * (255 - PAGE[i]) - c[i]) > 1.6 for i in range(3)): return None
    return round(a * 255)


def match_bnui(hexv, idx):
    if hexv in idx: return {'bnui': idx[hexv], 'match': 'exact'}
    # white/black alpha one step off a token (rounding of percentages)
    if len(hexv) == 9:
        for d in (-1, 1, -2, 2):
            near = hexv[:7] + '%02x' % max(0, min(255, int(hexv[7:], 16) + d))
            if near in idx: return {'bnui': idx[near], 'match': 'alpha±%d' % abs(d)}
    res = {'match': 'none'}
    a = white_over_page(hexv)
    if a is not None:
        res = {'composite': 'white/%d%% over surface-page' % round(a / 2.55), 'match': 'composite'}
        for d in (0, -1, 1, -2, 2):
            near = '#ffffff%02x' % (a + d)
            if near in idx:
                res['bnui'] = idx[near]
                break
    if len(hexv) == 7:  # a solid surface token within 2/255 wins over the composite reading, which is kept as a note
        c = [int(hexv[i:i + 2], 16) for i in (1, 3, 5)]
        for tok, names in idx.items():
            if len(tok) == 7 and max(abs(c[i] - int(tok[1 + 2 * i:3 + 2 * i], 16)) for i in range(3)) <= 2:
                res.update(bnui=names, match='near')
                break
    return res


# --- main ------------------------------------------------------------------

def main():
    install = Path(sys.argv[1]) if len(sys.argv) > 1 else find_install()
    if not install or not (install / 'Battle.net.mpq').exists():
        sys.exit('Battle.net install not found; pass its Battle.net.<build> directory')
    version = app_version(install)
    arc = mpyq.MPQArchive(str(install / 'Battle.net.mpq'), listfile=True)
    files = {raw.decode('utf-8', 'replace').replace('\\', '/'): raw for raw in arc.files}
    read = lambda rel: arc.read_file(files['resources/' + rel])

    counts, assets = collections.Counter(), set()
    for name in sorted(files):
        if not name.startswith('resources/') or '..' in name.split('/'): continue
        rel = name[len('resources/'):]
        if rel.endswith('.qml') or rel == 'common/util.js':
            write('qml/' + rel, lf(read(rel))); counts['qml' if rel.endswith('.qml') else 'js'] += 1
        elif rel.startswith(('controls/darktheme/', 'images/darktheme/')):
            write('assets/' + rel, read(rel)); assets.add(rel)

    qss = read('battle.net.css')
    write('qss/battle.net.css', lf(qss))
    for rel in sorted(n[len('resources/'):] for n in files if n.startswith('resources/css/styled_dialog/')):
        write('qss/styled_dialog/' + rel.rsplit('/', 1)[1], lf(read(rel)))

    rules = parse_qss(qss.decode('utf-8'))
    dark = [r for r in rules if is_dark(*r)]
    # Images the dark rules use outside the darktheme folders (arrows, search icon, radios, scrollbar).
    for _, decls in dark:
        for _, v in decls:
            for ref in re.findall(r'url\("?resources/([^")]+)"?\)', v):
                if ref not in assets and 'resources/' + ref in files:
                    write('assets/' + ref, read(ref)); assets.add(ref)
    header = ('/* Dark-theme subset of battle.net.css (Battle.net %s), extracted by capture/_tools/extract_qt_styles.py.\n'
              '   %d of %d rules, in source order, comments dropped. <font_dark> = Noto Sans, <font_dark_title> = Object Sans\n'
              '   (filled in at runtime by FontEngine). url(resources/...) paths resolve under ../assets/. */\n\n'
              % (version, len(dark), len(rules)))
    write('qss/darktheme.css', (header + format_rules(dark) + '\n').encode('utf-8'))

    idx = bnui_index()
    colours = collections.defaultdict(lambda: {'count': 0, 'uses': []})
    for sels, decls in dark:
        for k, v in decls:
            for c in css_colours(v):
                e = colours[c]; e['count'] += 1
                if len(e['uses']) < 6: e['uses'].append('%s { %s }' % (sels[0], k))
    for path in sorted((OUT / 'assets').rglob('*.svg')):
        for c in svg_colours(path.read_text(encoding='utf-8')):
            e = colours[c]; e['count'] += 1
            use = 'assets/' + path.relative_to(OUT / 'assets').as_posix()
            if len(e['uses']) < 6 and use not in e['uses']: e['uses'].append(use)
    for rel in NINE_PATCHES:
        border, fill = nine_patch(Image.open(OUT / 'assets' / rel).convert('RGBA'))
        for c, role in ((border, 'border'), (fill, 'fill')):
            e = colours[c]; e['count'] += 1
            if len(e['uses']) < 6: e['uses'].append('assets/%s (9-patch %s)' % (rel, role))

    out = {
        'source': 'Battle.net.mpq resources/battle.net.css + dark-theme assets, Battle.net %s' % version,
        'note': 'Colours of the native dark theme. match: exact = same value as a BNUI token; alpha±n = white/black '
                'alpha within n/255 of a token; near = opaque, within 2/255 per channel of a token; composite = an '
                'opaque grey equal to white at that alpha over surface-page.',
        'colours': [dict(value=c, **match_bnui(c, idx), **colours[c]) for c in
                    sorted(colours, key=lambda c: -colours[c]['count'])],
    }
    write('tokens-qss-dark.json', (json.dumps(out, indent=1) + '\n').encode('utf-8'))
    print('Battle.net %s: %d QML files + %d JS, %d assets, %d/%d dark QSS rules, %d colours -> %s'
          % (version, counts['qml'], counts['js'], len(assets), len(dark), len(rules), len(colours),
             OUT.relative_to(ROOT)))


if __name__ == '__main__':
    main()
