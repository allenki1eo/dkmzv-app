# Brand assets — where Canvy drops files

**Source of truth:** [`brand/`](../brand/) and [`brand/README.md`](../brand/README.md).

Extract a new pack over `brand/`, then copy into the Flutter/Android tree using the map below.

## Palette (theme)

| Token | Hex | Use |
| --- | --- | --- |
| Deep purple | `#2E0854` | Adaptive launcher **background**, splash field, app bars |
| Gold | `#D4AF37` | Cross / accents |
| Cream | `#FDF5E6` | Surfaces / wordmark |
| Sage | `#A2AD91` | Subtitle / secondary accents |

Do **not** rely on `brand/ic_launcher_background_swatch.png` for the adaptive plate — use the solid colour `#2E0854`.

## Exact drop map

| Pack file | App path |
| --- | --- |
| `brand/mipmap-mdpi/ic_launcher.png` | `android/app/src/main/res/mipmap-mdpi/ic_launcher.png` |
| `brand/mipmap-mdpi/ic_launcher_round.png` | `android/app/src/main/res/mipmap-mdpi/ic_launcher_round.png` |
| same for `hdpi`, `xhdpi`, `xxhdpi`, `xxxhdpi` | matching `mipmap-*` |
| `brand/ic_launcher_foreground.png` | `android/app/src/main/res/mipmap-xxxhdpi/ic_launcher_foreground.png` (also copied to `drawable-nodpi/`) |
| `brand/dkmzv-splash.png` | `assets/brand/dkmzv-splash.png` **and** `android/app/src/main/res/drawable-nodpi/dkmzv_splash.png` |
| `brand/dkmzv-icon-master-1024.png` | `assets/brand/dkmzv-icon-master-1024.png` |
| `brand/dkmzv-playstore-512.png` | `assets/brand/dkmzv-playstore-512.png` |

Registered in `pubspec.yaml` under `flutter:` → `assets:`.

## Adaptive icon XML

`android/app/src/main/res/mipmap-anydpi-v26/ic_launcher.xml` (+ `_round`):

- background `@color/ic_launcher_background` = **`#2E0854`**
- foreground `@mipmap/ic_launcher_foreground`

`android/app/src/main/res/values/colors.xml`

## Splash (equivalent of flutter_native_splash)

- Android: `drawable/launch_background.xml` (+ `drawable-v21`) = purple field `#2E0854` + `@drawable/dkmzv_splash`
- Flutter boot: `DkmzvBrand.splashAsset` → `assets/brand/dkmzv-splash.png` (`lib/app.dart`, `lib/theme/brand.dart`)

## Archive

`brand/archive-official-emblem/` holds the earlier official KKKT DKMZV silver/red emblem (Allen lock). Current launcher/splash are this Canvy v1 gold-cross pack.
