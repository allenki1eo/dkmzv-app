# DKMZV App — architecture

Android-first Flutter companion for KKKT DKMZV (Shinyanga / Chamaguha). One
codebase, three masharika, Swahili first, usable on a cheap phone with weak
data. Not an ERP, not a WhatsApp replacement, not a public member directory.

## The shape of it

```
┌──────────────────────────────────────────────────────────┐
│ presentation      lib/screens/**        screens + flows  │
│                   lib/widgets/**        shared components│
├──────────────────────────────────────────────────────────┤
│ design system     lib/theme/**          tokens, palette, │
│                                         ThemeData, season│
├──────────────────────────────────────────────────────────┤
│ state             lib/data/store.dart   ChurchStore       │
│                   (ChangeNotifier, one app-wide instance) │
├──────────────────────────────────────────────────────────┤
│ domain            lib/data/models.dart  plain Dart models │
│                   lib/data/youtube.dart pure link parsing │
│                   lib/theme/liturgical  church-year rules │
├──────────────────────────────────────────────────────────┤
│ platform          SharedPreferences · seed asset ·        │
│                   url_launcher · share_plus · webview ·   │
│                   flutter_map (OpenStreetMap tiles)       │
└──────────────────────────────────────────────────────────┘
```

Dependencies point downwards only. A screen never touches SharedPreferences,
and nothing below `state` imports Flutter widgets except the theme layer.

### presentation

`lib/screens/` holds one file per screen; `lib/widgets/` holds everything used
by more than one. Screens read state with `context.watch<ChurchStore>()` and
write it by calling a store method — there is no controller layer in between,
which is the right trade at this size.

Navigation is a five-tab `AppShell` (`Nyumbani · Mahubiri · Ibada · Nyimbo ·
Zaidi`) with `Navigator.push` for everything deeper. Tabs are the weekly
surfaces; anything monthly lives behind Zaidi.

### design system

`lib/theme/tokens.dart` is the spacing and radius scale. `lib/theme/brand.dart`
is the palette and the `Surfaces` stack for the active brightness.
`lib/theme/app_theme.dart` turns *(parish accent, brightness)* into one
`ThemeData`. `lib/theme/liturgical.dart` is the church-year calendar and its
vestment colours. Rules are documented in `DESIGN_SYSTEM.md`.

### state

`ChurchStore` is a single `ChangeNotifier` provided at the root. It owns the
whole `ChurchData` aggregate, exposes read-only views (`watchNow`,
`givingTotalsByGroup`, `pinsInsideGeofence`) and mutating methods that end in
`persist()`. Every write goes through `persist()`, so saving and notifying can
never drift apart.

`ChurchStore.memory()` builds the same store without SharedPreferences, which
is how the tests run.

### domain

Models are hand-written `fromJson` / `toJson` with defensive coercion (`_s`,
`_i`, `_b`), because the seed and stored JSON are edited by hand and a wrong
type must not crash a phone in a service. There is no code generation.

Pure logic lives in files with no Flutter import — `youtube.dart` link parsing
and `hymn_search.dart` — so it is testable in plain Dart.

### data flow

```
assets/seed/church.json ──first run──▶ ChurchData ──▶ SharedPreferences
                                           │
             office edits in Msimamizi ────┤
                                           ▼
                                      ChurchStore ──notifyListeners──▶ UI
```

The seed is the factory default. `ChurchStore.load()` reads stored JSON if it
exists, otherwise seeds it. Every upgrade runs `migrateV2`, which fills only
what is missing or retired so office edits survive — see *Migration* below.

## Offline behaviour

Everything the app shows on a Sunday is local: hymns, liturgy, bulletins,
announcements, giving instructions, jumuiya pins. Three things need the
network, and each degrades quietly:

| Needs network | Degrades to |
| --- | --- |
| YouTube playback (`webview_flutter`) | Poster frame + "open YouTube" button |
| Sermon poster frames (`i.ytimg.com`) | Neutral placeholder tile |
| Map tiles (OpenStreetMap) | Blank canvas; fences and pins still draw |

No GPS permission is requested. Homes are pinned by tapping the map.

## Migration

`dataVersion` is the contract. `ChurchStore.migrateV2` runs on every load and
is additive by rule:

- v1 phones have no masharika or jumuiyas → filled from the seed.
- v2 phones have no offering categories or payment config → filled from seed.
- v3 phones carry the old purple accents → repainted, but an accent the office
  chose itself is left untouched (`_retiredAccents`).

Never overwrite a non-empty field the office could have edited. When a new
field arrives, add it to the model with a default, add a targeted fill here,
and add a test that a phone from the previous version survives it.

## Money and privacy

Card giving is **Stripe Payment Links** — the office pastes a `buy.stripe.com`
URL per offering kind. No Stripe SDK, no secret key in the APK, no card data
touching the app. M-Pesa stays as copyable instructions.

Member records, home pins and giving notes are phone-local. Pins carry a
household label and never a phone number; `HomePin.toJson` has no phone field
at all, and a test asserts that.

## Testing

`test/widget_test.dart` mixes widget flows with plain Dart unit tests over the
store. The rule is that anything a churchwarden could get wrong at 07:00 on a
Sunday deserves a test: link parsing, offering grouping, geofence membership,
migration, and the palette staying neutral.

Run `flutter analyze && flutter test` before every commit.

## Where to add things

| Adding | Goes in |
| --- | --- |
| A new screen | `lib/screens/`, reachable from Zaidi unless it is weekly |
| A reusable block | `lib/widgets/common.dart` (or `video.dart`, `parish.dart`) |
| A colour or radius | `lib/theme/tokens.dart` / `brand.dart` — never inline |
| A stored field | model + seed + migration fill + test |
| An office-editable field | the matching editor in `lib/screens/admin/` |

## Known edges

- `ChurchStore` is large. If it passes ~1000 lines again, split it by feature
  into mixins over the same `ChurchData` before reaching for a new framework.
- The whole aggregate is re-encoded on every `persist()`. Fine at parish scale;
  revisit if the roster grows into thousands of members.
- There is no remote sync. When it arrives, it belongs behind a repository
  interface under `lib/data/`, with `ChurchStore` unchanged above it.
