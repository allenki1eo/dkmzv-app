# DKMZV App

Member companion for **KKKT DKMZV** — Lutheran / KKKT, Shinyanga, Tanzania.

**Usharika wa Ebenezer** is the cathedral / main church, then **Angaza** (Chamaguha) and **Makedonia** (Lubaga).

Android-first · Kiswahili + English · Works on slow data · Offline hymns and last-opened ibada.

This is **not** church ERP, not a public member phone directory, and not a WhatsApp replacement.

Product spec: [`docs/PRODUCT_BRIEF_V1.md`](docs/PRODUCT_BRIEF_V1.md) · v2: [`docs/PRODUCT_BRIEF_V2.md`](docs/PRODUCT_BRIEF_V2.md).

## What it does

| Tab / screen | Purpose |
| --- | --- |
| **Tangazo / Home** | Announcements + pinned Sunday times. Choose Ebenezer / Angaza / Makedonia. Live mahubiri banner when a stream is marked live. FCM is stubbed until keys exist. |
| **Ibada** | Weekly order of service (date, theme, readings, outline, optional link). Last opened stays on device. |
| **Nyimbo** | 36 seed hymns, search, favorites, recently opened (all offline). |
| **Matukio** | Calendar: worship, choir, UW, youth, confirmation, meetings. |
| **Sadaka** | Configurable M-Pesa / Lipa / paybill instructions + optional **Nimetoa** note. No finance backend. |
| **Mahubiri** | YouTube live + archive: watch in-app (when the URL is a video) and **share the link**. Office pastes the phone’s live URL. |
| **Masharika** | Ebenezer (kanisa kuu), Angaza, Makedonia. |
| **Ramani ya jumuiya** | OpenStreetMap. Tap to ping a home during jumuiya (household label only — no phone dump). |
| **Sajili mwanachama** | Light registration on this phone for the office. Not a public directory. |
| **Wasiliana** | OSM map, office hours, **Pastor + office only**. |
| **Ombi la kichungaji** | Private prayer/visit form → admin inbox on this phone. |
| **Msimamizi** | PIN-gated CRUD for all of the above. |

Members stay anonymous unless they fill the light registration form. There is no Firebase login. Content is **seed-first** (bundled JSON) and edited locally. v1 installs on a phone pick up Ebenezer / Angaza / Makedonia automatically.

## Run (Android)

```bash
flutter pub get
flutter run
```

On a device or emulator. First install uses the official KKKT DKMZV emblem on a **white** adaptive plate (`#FFFFFF`). Purple `#2E0854` is the splash field only.

Web (for a quick desktop look — Android remains the product):

```bash
flutter run -d chrome
# or
flutter build web
```

Tests:

```bash
flutter test
flutter analyze
```

## Admin

1. **Zaidi → Msimamizi**
2. Demo PIN: `dkmzv` (change it after you try the app)
3. Edit announcements, ibada, events, sermons (live flag + YouTube URL), hymns, M-Pesa numbers, Sunday times, role contacts, church copy, registrations, jumuiya pins, pastoral inbox
4. **Rudisha mbegu** restores `assets/seed/church.json`

Giving paybill / till numbers in the seed are **samples** (`400200` / `000000`). Replace them in Admin before anyone actually sends money.

Role phones in the seed are placeholders (`+255 700 000 001`, `+255 700 000 002`) — **not** real private numbers.

## Seed content

`assets/seed/church.json` is realistic Shinyanga KKKT texture:

- Three congregations: **Ebenezer** (cathedral, Old Shinyanga Road), **Angaza** (Chamaguha, OSM node), **Makedonia** (Lubaga neighbourhood, approximate pin)
- Maps: [OpenStreetMap](https://www.openstreetmap.org/?mlat=-3.669681&mlon=33.427495#map=16/-3.669681/33.427495) (not Google)
- Diocese named as Dayosisi Mashariki ya Ziwa Viktoria (DKMZV / ELVD)
- 36 hymns: public-domain Lutheran/gospel texts plus short original liturgical Swahili for demo. **Not** a dump of a copyrighted KKKT hymnal. Office can replace titles/numbers later.

## Brand

**Source of truth:** [`brand/`](brand/) (official KKKT emblem). Drop map: [`docs/BRAND_ASSETS.md`](docs/BRAND_ASSETS.md).

### Palette

| Token | Hex | Church year |
| --- | --- | --- |
| Deep purple | `#2E0854` | Advent + Lent vestment; **splash field only** (not the adaptive plate) |
| White | `#FFFFFF` | Adaptive launcher background (official emblem plate) |
| Forest green | `#1E4D36` | Time after Pentecost / Epiphany |
| Sage | `#A2AD91` | Secondary green |
| White / gold cloth | `#F4E6C1` + `#D4AF37` | Christmas, Easter, Trinity, All Saints |
| Red | `#8B1E2D` | Pentecost, Palm Sunday, Good Friday, Reformation |
| Cream | `#FDF5E6` | Parchment surfaces |

Gold is the **metal** (cross, rules) in every season. See [`docs/LITURGICAL_YEAR.md`](docs/LITURGICAL_YEAR.md).

### Exact copy paths

After extracting a pack over `brand/`:

| From | To |
| --- | --- |
| `brand/mipmap-{mdpi,hdpi,xhdpi,xxhdpi,xxxhdpi}/ic_launcher.png` | `android/app/src/main/res/mipmap-*/ic_launcher.png` |
| same `ic_launcher_round.png` | matching `mipmap-*/ic_launcher_round.png` |
| `brand/ic_launcher_foreground.png` | `android/app/src/main/res/mipmap-xxxhdpi/ic_launcher_foreground.png` |
| Adaptive background | solid `#FFFFFF` in `android/app/src/main/res/values/colors.xml` (`ic_launcher_background`) — official emblem plate; not the tiny swatch PNG |
| `mipmap-anydpi-v26/ic_launcher.xml` (+ round) | background `@color/ic_launcher_background`, foreground `@mipmap/ic_launcher_foreground` |
| `brand/dkmzv-splash.png` | `assets/brand/dkmzv-splash.png` and `android/.../drawable-nodpi/dkmzv_splash.png` |
| `brand/dkmzv-icon-master-1024.png` | `assets/brand/dkmzv-icon-master-1024.png` |
| `brand/dkmzv-playstore-512.png` | `assets/brand/dkmzv-playstore-512.png` |

Those three Flutter files are listed under `flutter:` `assets:` in `pubspec.yaml`. Splash uses `assets/brand/dkmzv-splash.png` (in-app + Android `launch_background.xml`).

Official emblem source + an AI alternate sit in `brand/archive-official-emblem/` as a backup. The live launcher is the same mark from `brand/`.

CI builds a **release** APK split by CPU, not a 149 MB debug fat file:

```bash
flutter build apk --release --split-per-abi
# phones: build/app/outputs/flutter-apk/app-arm64-v8a-release.apk
```

Download: [v1-sideload release](https://github.com/allenki1eo/dkmzv-app/releases/tag/v1-sideload) → `dkmzv-app-arm64.apk` (typical 15–25 MB). Older 32-bit phones use the `armv7` artifact on [Actions](https://github.com/allenki1eo/dkmzv-app/actions/workflows/debug-apk.yml). Debug-signed for parish install, not Play.

## Optional later: Firebase

v1 does not require a Google services file.

When Allen is ready:

1. Add `google-services.json` under `android/app/`
2. Enable Auth (admin only) + Firestore
3. Keep the same models; swap `ChurchStore.persist` for a remote collection
4. FCM stub lives on the home screen copy (`fcmConfigured` in seed settings) — flip it when keys exist

## Non-goals (still)

Membership ERP, pledges ledger, assets, in-app chat, iOS-first, replacing WhatsApp groups.
