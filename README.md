# DKMZV App

Member companion for **KKKT DKMZV — Usharika wa Angaza** (Lutheran / KKKT, Chamaguha, Shinyanga, Tanzania).

Android-first · Kiswahili + English · Works on slow data · Offline hymns and last-opened ibada.

This is **not** church ERP, not a member directory, and not a WhatsApp replacement.

Product spec: [`docs/PRODUCT_BRIEF_V1.md`](docs/PRODUCT_BRIEF_V1.md).

## What v1 does

| Tab / screen | Purpose |
| --- | --- |
| **Tangazo / Home** | Announcements + pinned Sunday times. FCM is stubbed until keys exist. |
| **Ibada** | Weekly order of service (date, theme, readings, outline, optional link). Last opened stays on device. |
| **Nyimbo** | 36 seed hymns, search, favorites, recently opened (all offline). |
| **Matukio** | Calendar: worship, choir, UW, youth, confirmation, meetings. |
| **Sadaka** | Configurable M-Pesa / Lipa / paybill instructions + optional **Nimetoa** note. No finance backend. |
| **Mahubiri** | Sermon list with YouTube / Facebook / audio links. |
| **Wasiliana** | Shinyanga map, office hours, **Pastor + office only**. |
| **Ombi la kichungaji** | Private prayer/visit form → admin inbox on this phone. |
| **Msimamizi** | PIN-gated CRUD for all of the above. |

Members are anonymous. There is no Firebase login in v1. Content is **seed-first** (bundled JSON) and edited locally. Optional Firestore/Auth can be wired later without changing screens.

## Run (Android)

```bash
flutter pub get
flutter run
```

On a device or emulator. First install uses the official KKKT DKMZV launcher icon on a **white** plate.

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
3. Edit announcements, ibada, events, sermons, hymns, M-Pesa numbers, Sunday times, role contacts, church copy, pastoral inbox
4. **Rudisha mbegu** restores `assets/seed/church.json`

Giving paybill / till numbers in the seed are **samples** (`400200` / `000000`). Replace them in Admin before anyone actually sends money.

Role phones in the seed are placeholders (`+255 700 000 001`, `+255 700 000 002`) — **not** real private numbers.

## Seed content

`assets/seed/church.json` is realistic Shinyanga KKKT texture:

- Congregation framed as **Usharika wa Angaza**, Ushirika / Chamaguha, Shinyanga Urban
- Map: [Chamaguha coordinates](https://www.google.com/maps?q=-3.67011,33.44624)
- Diocese named as Dayosisi Mashariki ya Ziwa Viktoria (DKMZV / ELVD)
- 36 hymns: public-domain Lutheran/gospel texts plus short original liturgical Swahili for demo. **Not** a dump of a copyrighted KKKT hymnal. Office can replace titles/numbers later.

## Brand / Canvy

Official church emblem is locked as the app icon.

- **Source of truth:** [`brand/`](brand/) (keep this folder in the repo)
- **Exact drop paths:** [`docs/BRAND_ASSETS.md`](docs/BRAND_ASSETS.md) and [`brand/README.md`](brand/README.md)

Do **not** put purple `#2E0854` on the adaptive-icon background. Purple is splash field only. Adaptive background is `#FFFFFF`.

## Optional later: Firebase

v1 does not require a Google services file.

When Allen is ready:

1. Add `google-services.json` under `android/app/`
2. Enable Auth (admin only) + Firestore
3. Keep the same models; swap `ChurchStore.persist` for a remote collection
4. FCM stub lives on the home screen copy (`fcmConfigured` in seed settings) — flip it when keys exist

## Non-goals (still)

Membership ERP, pledges ledger, assets, in-app chat, iOS-first, replacing WhatsApp groups.
