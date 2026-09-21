# Brand assets — official KKKT emblem

**Source of truth:** [`brand/`](../brand/) and [`brand/README.md`](../brand/README.md).

Extract a new pack over `brand/`, then copy into the Flutter/Android tree using the map below.

## Palette (theme)

| Token | Hex | Use |
| --- | --- | --- |
| White | `#FFFFFF` | Adaptive launcher **background** (official emblem plate) |
| Ink / splash | `#0F1419` | Splash field + in-app chrome. **Not** a hue. |
| Advent / Lent cloth | `#4B2E68` | Vestment ribbon only |
| Gold | `#B08A2E` | Metal of the church year |

Do **not** rely on `brand/ic_launcher_background_swatch.png` for the adaptive plate — use the solid colour `#FFFFFF`.

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

- background `@color/ic_launcher_background` = **`#FFFFFF`**
- foreground `@mipmap/ic_launcher_foreground`

`android/app/src/main/res/values/colors.xml`

## Splash (equivalent of flutter_native_splash)

- Android: `drawable/launch_background.xml` (+ `drawable-v21`) = near-black field `#0F1419` + `@drawable/dkmzv_splash` (white card + official emblem)
- Flutter boot: `DkmzvBrand.splashAsset` → `assets/brand/dkmzv-splash.png` (`lib/app.dart`, `lib/theme/brand.dart`)

## Archive

`brand/archive-official-emblem/` keeps a copy of the official source PNG and an AI alternate. Live launcher/splash are the official mark from `brand/` (not the geometric gold-cross pack).
