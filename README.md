# DKMZV App

Member companion for **KKKT DKMZV** — Lutheran / KKKT, Shinyanga, Tanzania.

**Usharika wa Ebenezer** is the cathedral / main church, then **Angaza** (Chamaguha) and **Makedonia** (Lubaga).

Android-first · Kiswahili + English · Works on slow data · Offline hymns and last-opened ibada.

This is **not** church ERP, not a public member phone directory, and not a WhatsApp replacement.

Product spec: [`docs/PRODUCT_BRIEF_V3.md`](docs/PRODUCT_BRIEF_V3.md) · architecture: [`docs/ARCHITECTURE.md`](docs/ARCHITECTURE.md) · design: [`docs/DESIGN_SYSTEM.md`](docs/DESIGN_SYSTEM.md).

## What it does

| Tab / screen | Purpose |
| --- | --- |
| **Nyumbani** | One serif headline, season ribbon, **watch card** for Sunday's sermon, four shortcuts, Sunday times, two upcoming events, two announcements. |
| **Mahubiri** | YouTube live + archive: poster thumbnails, watch in-app, share the link. Channel-level live if the office has pasted a `UC…` id. |
| **Ibada** | Weekly order of service (date, theme, readings, outline, optional link). Last opened stays on device. |
| **Nyimbo** | 36 seed hymns, search, favorites, recently opened (all offline). |
| **Zaidi** | Matukio, Sadaka, masharika, ramani, usajili, pastoral, contact, Mwonekano, Msimamizi. |
| **Sadaka** | Grouped offerings: **bahasha** (ujenzi, utumishi, imarisha usharika — marked *exempt*), **fungu la kumi**, **shukrani**, sadaka za ibada. M-Pesa + optional Stripe Payment Link per kind. |
| **Ramani ya jumuiya** | OpenStreetMap with **geofence circles** per jumuiya, homes-inside counts, and tap-to-ping (household label only). |
| **Usajili wa waumini** | Jina, kaya, jumuiya, hadhi, ubatizo/kipaimara. Stays on this phone. Not a public directory. |
| **Mwonekano** | Light / dark / system, five optional wallpapers, parish accent. |
| **Msimamizi** | Dashboard + **YouTube ya usharika** desk (paste a watch/live link, publish or go live) and PIN-gated CRUD. |

Members stay anonymous unless they fill the light registration form. There is no Firebase login. Content is **seed-first** (bundled JSON) and edited locally. Older installs migrate in place: v1 phones pick up Ebenezer / Angaza / Makedonia, v2 phones pick up the offering groups, v3 phones lose the purple chrome.

The chrome is a **neutral slate**. Each usharika carries a quiet accent used as punctuation (Ebenezer teal, Angaza amber, Makedonia blue) while vestments stay locked to the church year. Typography is bundled **Inter** + **Source Serif 4**, subset to Latin (about 320 KB).

## Run (Android)

```bash
flutter pub get
flutter run
```

On a device or emulator. First install uses the official KKKT DKMZV emblem on a **white** adaptive plate (`#FFFFFF`). The splash field is the same near-black as the in-app ink (`#0F1419`).

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
3. **YouTube ya usharika** is the first tile: paste a watch / youtu.be / live / shorts link, see the poster, publish it to Mahubiri or flip it live. Optionally paste the parish channel (`UC…` or `@handle`) once so live plays without a weekly link. Everything else (announcements, ibada, events, hymns, M-Pesa, offering kinds, Stripe links, Sunday times, masharika, jumuiya geofences, registrations, home pins, pastoral inbox) is in the grouped lists below.
4. **Rudisha mbegu** restores `assets/seed/church.json`

Giving paybill / till numbers in the seed are **samples** (`400200` / `000000`). Replace them in Admin before anyone actually sends money.

Card payment is **Stripe Payment Links** only: create the link in the Stripe dashboard, paste the `https://buy.stripe.com/...` URL in **Msimamizi → Lipa kwa kadi** (or per offering kind), and the app opens it. No Stripe keys or SDK ship in the APK.

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

Chrome is achromatic. Hue is reserved for the usharika accent (punctuation) and for vestments (a ribbon). Full rules: [`docs/DESIGN_SYSTEM.md`](docs/DESIGN_SYSTEM.md).

| Token | Hex | Role |
| --- | --- | --- |
| Ink / splash | `#0F1419` | Near-black chrome, splash field |
| Canvas | `#F5F6F8` | Page background |
| White | `#FFFFFF` | Cards + adaptive launcher plate |
| Ebenezer accent | `#0F5F52` | Teal punctuation (kanisa kuu) |
| Angaza accent | `#8A5A12` | Amber punctuation (Chamaguha) |
| Makedonia accent | `#1B4F7A` | Blue punctuation (Lubaga) |
| Advent / Lent cloth | `#4B2E68` | Vestment ribbon only |
| Ordinary-time green | `#1E4D36` | Vestment ribbon |
| Festival cream / gold | `#E8D6A8` + `#B08A2E` | Christmas, Easter, Trinity, All Saints |
| Red | `#8B1E2D` | Pentecost, Palm, Good Friday, Reformation |

Gold is the **metal** in every season. See [`docs/LITURGICAL_YEAR.md`](docs/LITURGICAL_YEAR.md).

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

Download: [v3-sideload release](https://github.com/allenki1eo/dkmzv-app/releases/tag/v3-sideload) → `dkmzv-app-arm64.apk` (typical 15–25 MB). Older 32-bit phones use the `armv7` artifact on [Actions](https://github.com/allenki1eo/dkmzv-app/actions/workflows/debug-apk.yml). Debug-signed for parish install, not Play.

## Optional later: Firebase

v1 does not require a Google services file.

When Allen is ready:

1. Add `google-services.json` under `android/app/`
2. Enable Auth (admin only) + Firestore
3. Keep the same models; swap `ChurchStore.persist` for a remote collection
4. FCM stub lives on the home screen copy (`fcmConfigured` in seed settings) — flip it when keys exist

## Non-goals (still)

Membership ERP, pledges ledger, assets, in-app chat, iOS-first, replacing WhatsApp groups.
