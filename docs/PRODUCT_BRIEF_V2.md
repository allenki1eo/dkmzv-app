# DKMZV App — Product brief v2

Companion only. Still not ERP, not WhatsApp, not a member directory.

v1 is the seed-first Android companion: Tangazo, Ibada, Nyimbo, Matukio, Sadaka (M-Pesa instructions), Mahubiri (links), Wasiliana (role phones), pastoral form → local inbox, PIN admin. See [`PRODUCT_BRIEF_V1.md`](PRODUCT_BRIEF_V1.md).

v2 is the **Sunday-morning product** plus a way for the office to publish without standing up a church database.

Design constraints: [`DESIGN_INSPO.md`](DESIGN_INSPO.md). Cloth still follows [`LITURGICAL_YEAR.md`](LITURGICAL_YEAR.md).

---

## Ship these

### 1. Jumapili mode (highest leverage)

A full-screen, keep-awake path for the next / current service:

- Hero: season name + this week’s theme (the *Ibada ya* poster move)
- Readings in reading order, large type
- Linked hymns from this ibada, opened as hymnal pages
- Sunday times as a caption, not a widget wall
- Hide the bottom tabs until the member exits

This is Lectio’s “one finite session,” applied to Lutheran worship — not a daily-prayer clone.

### 2. Office publish (replace “edit on this phone”)

v1 admin writes SharedPreferences on the device that opened it. That cannot serve Chamaguha.

- One **signed JSON bulletin** the office exports (same models as `assets/seed/church.json`)
- Members **pull** over HTTPS when data is cheap; last good bulletin stays offline
- Pastoral inbox **forwards to an office mailbox** (or a second admin device), not a public feed
- FCM: “Ibada ya kesho” / “Tangazo jipya” — the stub on Home becomes real keys, still no chat

Still no Auth for members. Admin stays a small set of office phones.

### 3. Mahubiri that survive slow data

- Cache the last N sermon audio files
- Resume position (Dwell)
- Keep YouTube/Facebook as a fallback, not the only path
- Optional office-written outline under the player — no generated “AI sermon”

### 4. Nyimbo for the room

- Keep-awake + extra-large type (choir / projector-adjacent)
- Filter by this week’s ibada numbers
- Optional pitch/tune note field (text only — no copyrighted KKKT score dump)

### 5. Sadaka without becoming finance

- Confirm the **real** paybill / Lipa numbers (v1 seed is `400200` / `000000`)
- Deep link into M-Pesa where the OS allows; keep the numbered steps
- “Nimetoa” stays a local note. No pledges ledger, no SMS parsing, no receipt vault

### 6. Ministry lanes (not a directory)

Quiet home-adjacent cards for **UW, choir, vijana, confirmation** — next rehearsal, next class, next reading. Contacts remain **role titles**, never a member phone book.

### 7. Access that matches the sanctuary

- System text-size respected (and a one-tap “herufi kubwa” on Jumapili / Nyimbo)
- TalkBack labels on season, paybill copy, pastoral submit
- SW/EN stay a first-class toggle; Kiswahili remains the default layout

---

## Explicit non-goals (still)

| Do not build | Why |
| --- | --- |
| Membership / pledges / assets ERP | Office already has paper and WhatsApp; the app is a companion |
| In-app chat or parish social graph | Replaces nothing; leaks pastoral privacy |
| Streaks, badges, “you missed Sunday” | Wrong tone for a Lutheran parish |
| AI pastor / blank spiritual chatbot | Pastoral form exists; a model is not a mchungaji |
| iOS-first | Android is the field. iOS only if Flutter cost stays near zero |
| Stock sacred imagery, new palettes, “church SaaS” chrome | Canvy + vestments are the identity |

---

## Acceptance (v2)

- [ ] On Saturday night / Sunday morning, a member can enter Jumapili mode and read this week’s ibada + hymns offline
- [ ] Office can publish a bulletin once; a second phone receives it without USB
- [ ] A sermon audio file plays after the radio is gone
- [ ] Pastoral request leaves the member phone
- [ ] Giving screen shows production Lipa numbers
- [ ] No new screen asks for another member’s private number

---

## Suggested order

1. Jumapili mode (pure client, uses today’s seed)
2. Real paybill + FCM keys
3. Bulletin pull + pastoral email
4. Sermon cache
5. Ministry lanes

Do not start a backend until (1) is in members’ hands.
