# DKMZV App — Product brief v1

**Working name:** DKMZV App  
**Church:** KKKT DKMZV — Lutheran, based in Shinyanga, Tanzania  
**Goal:** Member companion (not church ERP). Complements WhatsApp; does not replace it.  
**Platform:** Android-first. Swahili + English. Usable on slow data; offline for hymns + latest bulletin where practical.

---

## v1 features (build these)

1. **Home / Tangazo** — announcements list; pin Sunday times; push-ready structure (FCM can be stubbed if keys missing).
2. **Ibada** — weekly order of service: date, theme/sermon title, readings, outline; optional PDF/link.
3. **Nyimbo** — hymn list + search; favorites; cache last-opened hymns offline (seed 20–50 common KKKT/local hymns; admin can add later).
4. **Matukio** — event calendar (worship, choir, UW, youth, confirmation, meetings).
5. **Sadaka** — giving screen: amount tips + **M-Pesa / mobile money** instructions (paybill/lipa details configurable in admin); optional “Nimetoa” note (no full finance backend in v1).
6. **Mahubiri** — sermon list (title, date, preacher, audio/video URL or YouTube/Facebook link).
7. **Wasiliana** — church location (Shinyanga map link), office hours, role contacts (Pastor, office) — **not** a full public member directory.
8. **Pastoral request** — private form: prayer / visit request → stored for office (email or admin inbox); not a public feed.

**Admin (minimal web or in-app admin):** create/edit announcements, ibada, events, sermons, hymn entries, giving paybill numbers, pastoral inbox list.

---

## Explicit non-goals v1

- Full membership ERP, pledges ledger, assets  
- In-app live chat  
- iOS (unless trivial later)  
- Replacing WhatsApp groups  

---

## Suggested stack (Cod't may adjust)

- **Mobile:** Flutter or Kotlin + Compose (Android-first; Flutter OK if faster for SW/EN + offline)  
- **Backend:** simple API (Next/Node or Firebase) + auth for admin only; members can be light/anonymous read for public content  
- **Repo:** new GitHub repo under `allenki1eo` e.g. `dkmzv-app`

---

## Acceptance

- [ ] Member can open app and see this week’s announcements + ibada  
- [ ] Search a hymn and favorite it (persists)  
- [ ] See events calendar  
- [ ] Open giving screen with configurable M-Pesa instructions  
- [ ] Open a sermon link  
- [ ] Submit pastoral request  
- [ ] Contacts/map without dumping all members’ phones  
- [ ] UI SW + EN toggle  

---

## Design (Canvy)

- App name mark: **DKMZV** / official KKKT DKMZV emblem (cross + heart + Bible + globe). **Locked** as the launcher icon — not a geometric purple/gold substitute.
- Adaptive launcher **background is `#FFFFFF`** (not `#2E0854`). Purple stays on the splash field only.
- Splash: purple `#2E0854` field + white card with the official logo (`brand/dkmzv-splash.png`).
- Liturgical purple / green / gold remain UI accents.
- Deliver: launcher icon, splash, adaptive icon for Android `mipmap`. Exact drop paths: `docs/BRAND_ASSETS.md` and `brand/README.md`.

---

## Implementation notes (v1 shipped)

- **Mobile:** Flutter (SW+EN + offline hymns).
- **Data:** seed-first JSON (`assets/seed/church.json`) persisted locally. Members stay anonymous. Firebase/Auth optional later; FCM stub on Home.
- **Admin:** in-app, PIN `dkmzv` (demo). No member directory.
- **Congregation texture:** Usharika wa Angaza, Chamaguha, Shinyanga. Placeholder role phones only.

*Allen asked Idealy to send this to Cursor agents to create v1. Cod't builds; Canvy brand.*
