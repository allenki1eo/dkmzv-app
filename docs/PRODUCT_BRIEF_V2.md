# DKMZV App — Product brief v2

Fine-tune of shipped v1 (same screens, brand, liturgical lock). Not a rewrite.

## Additions

1. **Mahubiri live (YouTube)** — Most sermons stream live from a phone. Members watch in-app when the office pastes a YouTube watch / live / youtu.be URL, and can **share the link**. Search URLs still open YouTube outside.
2. **Masharika** — **Usharika wa Ebenezer** is the cathedral / main church, then **Angaza** (Chamaguha) and **Makedonia** (Lubaga). Home chips pick the active congregation.
3. **Member registration** — Light form on this phone (name, congregation, jumuiya, optional office-only phone). Not a public member directory. Not ERP.
4. **Jumuiya maps (OpenStreetMap)** — Church + jumuiya pins. During jumuiya, a registered member can tap the map to ping a home. Pins show a household label only (no phone numbers). Makedonia’s pin is labelled approximate until the office corrects it.

## Still out of scope

- Church ERP, pledges ledger, assets
- In-app chat / WhatsApp replacement
- Public dump of member phones
- Real private pastor numbers (seed stays placeholder)
- Google Maps (OSM only)

## Maps

Tiles: `https://tile.openstreetmap.org/{z}/{x}/{y}.png`  
User-Agent / package: `tz.kkkt.dkmzv.dkmzv_app`  
Attribution: © OpenStreetMap contributors  
No GPS permission — tap-to-drop only.

## Data

Seed `assets/seed/church.json` is version 2. Existing v1 `church_data_v1` on a phone is migrated: empty congregation lists are filled from seed; hymns, notes, and admin edits stay.
