# Brand assets — where Canvy drops files

**Source of truth:** [`brand/README.md`](../brand/README.md) and the files under `brand/`.

Allen locked the **official KKKT DKMZV emblem** (cross + heart + Bible + globe text) as the app icon.

## Critical colour rule

| Surface | Colour | Why |
| --- | --- | --- |
| Adaptive launcher **background** | `#FFFFFF` | Official silver/red mark stays true. **Not** `#2E0854`. |
| Launcher mipmaps | Emblem on **white plate** | `brand/mipmap-*/ic_launcher.png` (+ `_round`) |
| Adaptive foreground | `brand/ic_launcher_foreground.png` | Copied to `android/app/src/main/res/drawable-nodpi/` |
| Splash field | `#2E0854` purple | Purple is splash chrome only |
| Splash art | `brand/dkmzv-splash.png` | Purple field + white card + official logo |

## Drop / overwrite map

When Canvy ships a new pack, extract it over `brand/`, then copy:

| Pack file | App path |
| --- | --- |
| `brand/mipmap-mdpi/ic_launcher.png` | `android/app/src/main/res/mipmap-mdpi/ic_launcher.png` |
| `brand/mipmap-hdpi/ic_launcher.png` | `android/app/src/main/res/mipmap-hdpi/ic_launcher.png` |
| `brand/mipmap-xhdpi/ic_launcher.png` | `android/app/src/main/res/mipmap-xhdpi/ic_launcher.png` |
| `brand/mipmap-xxhdpi/ic_launcher.png` | `android/app/src/main/res/mipmap-xxhdpi/ic_launcher.png` |
| `brand/mipmap-xxxhdpi/ic_launcher.png` | `android/app/src/main/res/mipmap-xxxhdpi/ic_launcher.png` |
| same folders `ic_launcher_round.png` | matching `mipmap-*/ic_launcher_round.png` |
| `brand/ic_launcher_foreground.png` | `android/app/src/main/res/drawable-nodpi/ic_launcher_foreground.png` |
| `brand/dkmzv-splash.png` | `android/app/src/main/res/drawable-nodpi/dkmzv_splash.png` **and** `assets/brand/dkmzv-splash.png` |
| `brand/dkmzv-icon-master-1024.png` | `assets/brand/dkmzv-icon-master-1024.png` |
| `brand/dkmzv-playstore-512.png` | `assets/brand/dkmzv-playstore-512.png` |
| `brand/dkmzv-logo-official-source.png` | `assets/brand/dkmzv-logo-official-source.png` |

Adaptive XML (do not change the white plate):

- `android/app/src/main/res/mipmap-anydpi-v26/ic_launcher.xml`
- `android/app/src/main/res/mipmap-anydpi-v26/ic_launcher_round.xml`
- `android/app/src/main/res/values/colors.xml` → `ic_launcher_background` = `#FFFFFF`

Splash XML:

- `android/app/src/main/res/drawable/launch_background.xml` (and `drawable-v21/`) uses `@color/dkmzv_splash_field` (`#2E0854`) + `@drawable/dkmzv_splash`.

Flutter in-app splash/logo: `assets/brand/dkmzv-splash.png` and `assets/brand/dkmzv-playstore-512.png` (see `lib/theme/brand.dart`).

Web favicon: `web/favicon.png` (copy of playstore 512 for now).
