# Design inspo — keep DKMZV specific

There is no dedicated “inspo” Cursor skill in this environment. Inspiration was pulled from **Canva MCP** (`search-designs`, `get-design`, `get-design-pages`, `get-design-content`) plus recorded sacred-app UX — not from a generic “church app” moodboard.

Canva searches **existing designs in the connected account**, not the public template marketplace. Queries `DKMZV`, `KKKT Angaza Canvy`, `DKMZV church liturgical`, and `Canvy KKKT purple gold` returned one church-owned piece and a pile of stock. Brand kits and DKMZV folders were empty.

## Keep: *Ibada ya* (Canva `DAHC9xBD4DY`)

Two 1080×1350 posters for **KKKT DKMZV / Ebenezer**, season **Kwaresima**, Wednesday 4 March 2026, 11:00–12:30.

What is actually good (steal this, not the Canva chrome):

| Cue | Why it is not generic | v2 move |
| --- | --- | --- |
| Season is the title (`Ibada ya Kwaresima`) | Vestment language, not “Welcome to church” | Home / Sunday-mode hero = season + this week’s theme, not the app name |
| One photograph of **this** building | Place, not a stock steeple | Optional congregation photo on Sunday mode only — Chamaguha, not a European nave |
| Time and place as quiet metadata under the photo | The building is the hero; 11:00 is secondary | Pin Sunday times as a small gold-rule caption, not a dashboard card wall |
| Two type voices: script season vs slab date | Hierarchy without icons | Script/italic for season name; slab/caps for date, hymn number, paybill |

What to reject from the same file: `@reallygreatsite` placeholders, stacked duplicate headlines, stock script-on-navy that could be any wedding invitation.

## Discard: keyword-adjacent slop

These matched the search but are not DKMZV and must not leak into the app:

- **HUDUMA services** (`DAGMi0bYqTw`) — wellness / fashion carousel (“NEW COLLECTION”, denim, yoga on a cliff)
- **KUANZIA** (`DAGQV_sxRNo`) — car-service price wheel
- Beige “company profile” decks that came back on `liturgical`

If a reference could sell handbags, skip it.

## Sacred apps (patterns, not skins)

Do **not** restyle DKMZV as Hallow (Catholic audio marketplace) or YouVersion (global Bible library). Borrow only the **loop**.

| Source | Pattern that earns its keep | DKMZV translation |
| --- | --- | --- |
| **Lectio 365** | Morning / midday / night each own a cloth; the session has a start and an end | Cloth already locks to the Lutheran year. Add **Jumapili mode** (arrive → ibada + readings + hymns → done) and optional weekday **asubuhi / jioni** prayer that is KKKT, not 24-7 Prayer IP |
| **Dwell** | Listen and Read are two modes of the **same** passage, with a resume point | Sermon + Sunday readings: one cache, one progress, not a YouTube dump |
| **Hallow** | First question changes the next screen; intention sits on the player | Pastoral form and Sunday mode: ask *prayer / visit / ibada* and route. Do not add a prayer-interest quiz |
| **YouVersion Today** | One recommended action before the library | Home already has featured ibada. v2 should hide the rest of the tab bar on Sunday morning |
| **Bible Note** | Recording, transcript, and notes stay on the same sermon | Mahubiri: cache audio + optional office notes. No AI summary unless the office writes it |

Anti-patterns from the same set: streaks that shame a missed Sunday, a content marketplace, parish social graphs, blank “ask AI” boxes pretending to be a pastor.

## What v1 already has (do not redo)

Canvy cloth (`#2E0854` / `#D4AF37` / `#FDF5E6` / `#A2AD91`) locked to the church year, gold as metal, hymnal-page Nyimbo, cloth Sadaka card, season banner, vestment preview. v2 should deepen **Sunday morning** and **office publish**, not add another palette.

## Visual rules for anything new

1. One season word on screen at a time.
2. Gold is a hairline or a cross, never a gradient fill.
3. Photographs only if they are Angaza / Chamaguha / DKMZV. No steeple stock.
4. Kiswahili first in the layout (larger, not a toggle afterthought).
5. Type sizes that a choir can read at arm’s length; no icon-only navigation on Sunday mode.
