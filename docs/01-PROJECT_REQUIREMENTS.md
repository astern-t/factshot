# FactShot — Project Requirements Document

**Owner:** Swarnil Raj / Factline
**Status:** Draft v1.0 — Foundation document, referenced by all other project docs
**Last updated:** 2026-07-13

---

## 1. What We're Building

FactShot is a short-form news mobile app. Users get news stories compressed into ~60-word summaries, delivered in a fast, swipeable, card-based feed — similar in core mechanic to Inshorts, but positioned as a premium, editorially-driven product under the Factline brand.

**The core promise to the user:** *Know what happened, in the time it takes to read one paragraph.*

**One-line positioning:** FactShot is Factline's fast-reading news product — where Factline's editorial credibility meets a modern, swipe-first mobile experience.

---

## 2. Why This Exists (Product Rationale)

- Factline already operates an editorial/media publishing arm — FactShot gives that content a dedicated, mobile-first distribution channel built for how people actually consume news today (short sessions, high frequency, mobile-only).
- Short-form news apps have proven demand (Inshorts is the reference model), but most competitors either lack editorial credibility (aggregator spam) or lack modern UX polish. FactShot's differentiation is combining both.
- This document treats FactShot as a real product with real constraints — not a prototype exercise. Every feature below should be justifiable against the target user, not added because "other apps have it."

---

## 3. Target Users

### Primary persona: "The Commuter Reader"
- Age 18–35, urban/semi-urban India (initial market), smartphone-first
- Checks news in short bursts — commute, waiting in line, breaks between tasks
- Wants headlines and context, not long-form journalism, most of the time
- Values speed and trust simultaneously — wants to feel informed, not misled

### Secondary persona: "The Category Follower"
- Has specific interests (business, sports, tech) and wants a fast way to stay current in that lane without wading through a full newspaper or generic aggregator
- More likely to use search, categories, and bookmarks actively

### Explicitly NOT the primary target (for now)
- Long-form journalism readers (that audience is served by Factline's main editorial site, not this app)
- International/global-news-first users — initial focus is India-relevant news, expandable later

---

## 4. Goals for Version 1 (MVP)

1. Ship a working Android app (iOS is a later-phase goal, not V1) that delivers a genuinely fast, pleasant reading experience
2. Prove the core swipeable card feed + category filtering + bookmarking loop works and feels good
3. Establish a content pipeline (even a manual/semi-manual one) so real Factline editorial content can flow into the app
4. Get FactShot in front of real users to validate retention and reading behavior before investing in advanced features (personalization, recommendation algorithms, monetization)

## 5. Explicit Non-Goals for V1

To avoid scope creep — these are intentionally deferred, not forgotten:
- iOS app (V1 is Android-only)
- Comments, likes, or any social/community features
- Algorithmic personalized recommendations (V1 uses simple category-based filtering only)
- Monetization (ads, subscriptions) — not part of V1
- Multi-language support (V1 is English/Hindi only if editorial supports it; otherwise English only)
- User-generated content or citizen journalism submissions
- Web app version

---

## 6. Feature List

### 6.1 Must-Have for V1 (MVP)

| Feature | Description |
|---|---|
| Swipeable card feed | Vertical swipe through news cards, one story at a time — the core interaction |
| Category filtering | Horizontal category chips (Top, India, Business, Sports, Tech, Entertainment, etc.) that filter the feed |
| Article detail view | Tapping/expanding a card shows full summary + source attribution + link to original if applicable |
| Bookmark/save | Save articles to read later, accessible from a dedicated Saved tab |
| Share | Share a story card externally (WhatsApp, etc. — critical for organic growth in the Indian market) |
| Search | Search articles by keyword |
| Push notifications | Breaking news / daily digest alerts |
| Onboarding | First-time user flow explaining the app + optional category preference selection |
| Offline reading (cached) | Previously loaded articles readable without an active connection |
| Dark mode | On by default, matching brand direction; toggle available |

### 6.2 Should-Have (V1.1 / early post-launch)

| Feature | Description |
|---|---|
| User accounts (optional login) | Sync bookmarks across devices; guest mode remains fully functional without login |
| Personalized category preferences | User selects preferred categories at onboarding, feed weights toward them |
| Font size adjustment | Accessibility / reading comfort |
| Basic analytics dashboard (internal) | Understand what's being read, for how long, what's shared |

### 6.3 Could-Have (Future / V2+)

| Feature | Description |
|---|---|
| iOS app | Full parity release |
| Algorithmic personalization | Recommend based on reading behavior, not just declared category preference |
| Editorial CMS | Dedicated publishing tool for Factline's editorial team instead of manual content entry |
| Multi-language support | Hindi and regional languages |
| Trending/most-read section | Social-proof-driven discovery |
| Monetization | Native ad units between cards, or a premium tier |

### 6.4 Won't-Have (Explicitly Out of Scope, Any Version)

- Comments/community features (deliberately excluded — not the product's identity)
- User-generated content submission

---

## 7. Content Model (High-Level)

Every article/story in FactShot has, at minimum:
- Headline (short, bold)
- Summary (~60 words)
- Category (single primary category, e.g. "Technology")
- Source name + optional source URL (for "Read full story")
- Hero image
- Published timestamp
- Unique ID

**Open question, unresolved as of this document:** Where does content actually come from — Factline's own editorial team writing directly into the app's data source, or aggregation from external sources via API? This determines whether a CMS is needed for V1 or whether a simpler manual data-entry approach is sufficient short-term. **This must be resolved before backend work begins** — see `03-KNOWLEDGE_BASE.md` for the tradeoffs.

---

## 8. Success Criteria for V1

Since this is a new product, "success" for the MVP phase means:
- The app is stable (no crashes in core flows: feed scroll, bookmark, search, share)
- A test group of real users can use it for a week and give qualitative feedback on whether the reading experience "feels fast and good"
- At least one full content pipeline cycle works end-to-end (editorial writes a story → it appears correctly formatted in the app)
- App builds and installs cleanly via Google Play internal testing track

Metrics to start tracking once there are real users (not required for MVP launch, but plan for it): daily active users, average session length, articles read per session, share rate, bookmark rate, retention (Day 1 / Day 7).

---

## 9. Related Documents

- `02-ARCHITECTURE.md` — technical architecture, folder structure, tech stack
- `03-KNOWLEDGE_BASE.md` — libraries, tools, and open technical decisions
- `04-RULES.md` — coding standards, boundaries for AI-assisted development
- `05-PHASES.md` — development roadmap broken into phases
- `06-DESIGN.md` — visual design system, theming, typography
- `07-MEMORY.md` — living project state, updated continuously during development
