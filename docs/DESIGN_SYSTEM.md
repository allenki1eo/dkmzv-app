# DKMZV App — design system

The look is modelled on shipped products like [Mobbin](https://mobbin.com/)
itself: near-monochrome surfaces, 1 px hairlines instead of shadows, and one
accent used as punctuation, never as a fill. Colour is cheaper than restraint,
and restraint is what makes a church app feel like a product rather than a
brochure.

## Layers of colour

Three layers, never mixed:

| Layer | What it is | Where it lives | Rule |
| --- | --- | --- | --- |
| **Chrome** | Neutral slate | `Surfaces` in `lib/theme/brand.dart` | Carries every surface, every filled button, every hairline |
| **Accent** | Usharika identity | `Congregation.accentHex` | Icons, selected states, small badges. Never a card, never a button fill |
| **Vestment** | Church-year cloth | `SeasonPalette` in `lib/theme/liturgical.dart` | A ribbon, a dot, a swatch. Never a screen |

Advent and Lent are still purple on the altar. They are not purple on the
navigation bar.

### Chrome (light)

| Token | Hex | Use |
| --- | --- | --- |
| `canvas` | `#F5F6F8` | Page background |
| `card` | `#FFFFFF` | Surfaces sitting on the canvas |
| `ink` | `#0F1419` | Body and titles |
| `muted` | `#5A6472` | Secondary text |
| `hairline` | `#E4E7EC` | 1 px borders, the only elevation |
| `action` | `#16202B` | The one filled button on a screen |
| `onAction` | `#FFFFFF` | Text on that button |

Dark is the same stack inverted (`darkCanvas` `#0B0E12` … `darkAction`
`#E8ECF1`). Splash and the web theme-color follow `ink` (`#0F1419`), not a
hue.

### Accents (usharika)

| Usharika | Hex | Why this, not purple |
| --- | --- | --- |
| Ebenezer | `#0F5F52` teal | Cathedral: grounded, liturgical green's neighbour, not Advent cloth |
| Angaza | `#8A5A12` amber | Chamaguha: warmth without gold-foil kitsch |
| Makedonia | `#1B4F7A` blue | Lubaga: water, not violet |

A phone that still has the old `#2E0854` / `#8A5A00` / `#123A5C` accents is
repainted on upgrade. An accent the office chose itself is left alone.

### Vestments (church year)

Purple `#4B2E68`, green `#1E4D36`, white/gold cream, red `#8B1E2D`. Live status
is the only other hue allowed to shout (`#C0392B`), and only on a small badge.

## Type

- **Inter** 400/500/600/700 — interface. Bundled, subset to Latin.
- **Source Serif 4** 600/700 — the one display line on Home, and large numbers.

Sentence case everywhere. All-caps section labels were retired: they shout, and
Kiswahili already carries the weight.

Scale lives in `AppTheme._textTheme`. Display is 36 / 30 / 26 / 22; sans titles
are 19 / 16 / 15; body is 15.5 / 14.5 / 13.

## Space and radius

`lib/theme/tokens.dart`:

| Token | Value | Typical use |
| --- | --- | --- |
| `Insets.gutter` | 20 | Screen padding |
| `Insets.lg` | 16 | Card padding |
| `Insets.md` | 12 | Tight rows |
| `Radii.lg` | 18 | Cards |
| `Radii.md` | 14 | Inputs, small tiles |
| `Radii.pill` | 999 | Buttons, chips, badges |

No drop shadows. Elevation is a hairline against the canvas, or a surface
sitting on a slightly different grey.

## Components

Reach for these before drawing a new box:

| Widget | File | Use |
| --- | --- | --- |
| `AppCard` | `widgets/common.dart` | Hairline card, optional tap |
| `TileRow` | same | Icon + title + subtitle + chevron |
| `SectionLabel` | same | Sentence-case heading, optional trailing action |
| `BarButton` / `LocaleToggle` | same | Quiet square chrome in the app bar |
| `WatchCard` / `SermonRow` / `YoutubeThumb` | `widgets/video.dart` | Mahubiri |
| `ParishButton` | `widgets/parish.dart` | Switch usharika |

Filled buttons are the neutral `action` weight. Text buttons may take the
parish accent. Outlined buttons are ink on a hairline.

## Navigation

Five tabs, weekly surfaces only:

`Nyumbani · Mahubiri · Ibada · Nyimbo · Zaidi`

Sunday's message is one tap from anywhere (the Mahubiri tab, or the watch card
on Home). Matukio, Sadaka, Ramani and Usajili live behind Zaidi or a home
shortcut — they are not weekly enough to occupy a tab.

## Do / don't

- Do put the one primary action of a screen on a filled pill.
- Do let empty space do the grouping. A section heading plus 8 px is enough.
- Do keep Kiswahili as the native copy; English is the toggle, not the default.
- Don't fill a card, a nav bar or a button with the parish accent.
- Don't paint a screen in vestment colour. The cloth is a ribbon.
- Don't introduce a second filled hue. Live red is a badge, not a surface.
- Don't add a drop shadow, a gradient wash, or an all-caps heading.
