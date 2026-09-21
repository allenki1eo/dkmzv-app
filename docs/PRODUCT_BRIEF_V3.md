# DKMZV App — v3 brief (parish identity, giving groups, geofences)

v3 keeps everything v1/v2 shipped and fine-tunes the product around four asks:
each usharika should feel like itself, waumini should be registerable properly,
the offerings should follow how KKKT actually books money, and the jumuiya map
should show boundaries, not just dots.

## 1. Every usharika has its own look

Each `Congregation` now carries an identity: `accentHex`, `motif`, and a
bilingual tagline.

| Usharika | Accent | Motif | Tagline (SW) |
| --- | --- | --- | --- |
| Ebenezer (kanisa kuu) | `#0F5F52` teal | cathedral | Kanisa kuu la dayosisi |
| Angaza (Chamaguha) | `#8A5A12` amber | sunrise | Nuru katika Chamaguha |
| Makedonia (Lubaga) | `#1B4F7A` blue | village | Wito wa Makedonia, Lubaga |

The accent is punctuation — icons, selected states, small badges. It does
**not** fill a card, a button or the navigation bar, and it does **not** touch
the vestments: the season ribbon and the church-year screen stay locked to the
liturgical calendar. Chrome itself is a neutral slate (`#0F1419` ink on
`#F5F6F8` canvas). Full rules: `docs/DESIGN_SYSTEM.md`.

Switching parish is one tap from the app bar on Home, Zaidi, the map and Admin.

## 2. Light and dark, and a wallpaper you choose

- `Mwonekano` (Zaidi → Mwonekano): **Ya simu / Mwanga / Giza** plus a plain
  dark-mode switch. Stored in `settings.themeMode`.
- Five backgrounds: **Sadifu** (plain), **Maua**, **Mapambazuko**, **Kitenge**,
  **Usiku**. Stored in `settings.backgroundId`.
- Wallpapers are compressed WebP (about 100 KB for all five) and painted under a
  scrim so text keeps its contrast in both brightnesses.

## 3. Professional typography

Bundled, subset to Latin so the APK stays small (about 320 KB of fonts):

- **Inter** (400/500/600/700) for the interface.
- **Source Serif 4** (600/700) for headlines and numbers.

No runtime font download, so the app still opens on weak Shinyanga data. Both
families are SIL Open Font License; licence files sit in `assets/fonts/`.

## 4. Usajili wa waumini

`MemberRecord` grew the fields the office asks for on paper: **kaya**
(household), jinsia, hadhi (mwanachama / kijana / mtoto / mgeni), amebatizwa,
amekipaimara, mwaka wa kuzaliwa — alongside name, usharika, jumuiya and the
office-only phone.

Admin gets a searchable roster (name, kaya, jumuiya or phone). Registration
still lives on the phone: no server, no public directory, and the map never
shows a phone number.

## 5. Sadaka: bahasha, fungu la kumi, shukrani

Offerings are modelled as `GivingCategory` in four groups:

| Group | Categories | Exempt |
| --- | --- | --- |
| `bahasha` | Ujenzi, Utumishi, Imarisha Usharika, Bahasha nyingine | **yes** |
| `fungu` | Fungu la kumi | no |
| `shukrani` | Sadaka ya shukrani | no |
| `sadaka` | Sadaka ya Jumapili, Huduma ya wagonjwa | no |

Bahasha envelopes are flagged `exempt` and shown with an **Exempt** badge; they
are never merged with fungu la kumi or shukrani, including in the member's own
"Kumbukumbu zangu" totals.

**Payments.** M-Pesa / paybill stays as it was. Card payment uses **Stripe
Payment Links**: the office pastes a link per category (or one default) in
**Msimamizi → Lipa kwa kadi**, and the app opens it. No Stripe SDK and no secret
key ships in the APK. Until a link exists, the card button stays disabled with a
plain note.

## 6. Jumuiya geofences on the map

`Jumuiya` now has `radiusMeters` (100–2000 m, set with a slider in Admin) and a
colour. The map draws each jumuiya as a coloured circle:

- **Jumuiya zote** shows every fence in the usharika at once.
- Selecting one shows its fence, its meeting note, and counts of **Nyumba ndani**
  and **Nje ya mpaka**.
- Dropping a home pin inside another jumuiya's fence files the home under that
  jumuiya automatically (haversine distance, `store.jumuiyaAt`).

Still no GPS permission: homes are dropped by tapping the map, and pins carry a
household label only.

## 7. Msimamizi worth opening

The admin home is now a dashboard: six stat tiles (waumini, jumuiya, nyumba,
matangazo, mahubiri, inbox), a **YouTube ya usharika** desk at the top — paste
any watch / youtu.be / live / shorts link, see the poster, publish it to
Mahubiri or flip it live, and optionally set the parish channel (`UC…`) once so
the live stream plays without a weekly paste — plus grouped sections (Maudhui,
Watu na jumuiya, Sadaka na malipo, Mipangilio). New editors: Masharika, Jumuiya
(with the geofence slider), Aina za sadaka, Lipa kwa kadi.

## 8. Where Sunday's message lives

Mahubiri is a first-class tab. Home shows a **watch card** (live stream if the
office flipped the switch, otherwise the newest sermon). Tapping it plays the
YouTube embed in-app via `webview_flutter`; sharing sends the original link.
Poster frames come from `i.ytimg.com` and degrade to a placeholder offline.

## What did not change

Swahili stays the default language, the liturgical colour lock stands, content is
still seed-first on the phone, and the app is still not ERP, not a phone
directory, and not a WhatsApp replacement.

## Data migration

`ChurchData.version` is `4`. `ChurchStore.migrateV2` fills only what is missing
or retired — congregations and jumuiyas for v1 installs, offering categories and
payment config for v2, the purple-free accents for v3 — so office edits made on
a phone survive the upgrade. An accent the office chose itself is never
overwritten.
