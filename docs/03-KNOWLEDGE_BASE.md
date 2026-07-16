# FactShot — Knowledge Base

**Purpose of this document:** This is your reference file for understanding what tools/libraries this project uses, why, and what's still undecided. Read this before your technical meeting so you understand the *why* behind every recommendation — not just the name of the library.

**Status:** Living document — update as decisions get made. Every entry marked "OPEN QUESTION" needs a decision before the relevant phase of work begins (see `05-PHASES.md`).

---

## 1. Core Stack (Decided)

| Layer | Choice | Why |
|---|---|---|
| Framework | **Flutter** (Dart) | Already decided by you — single codebase for Android/iOS, excellent for animation-heavy, custom-UI apps like a card-swipe feed |
| Language | **Dart** | Required by Flutter — not optional, it's the only language Flutter uses |
| State Management | **Riverpod** (with code generation, `@riverpod` annotation) | Free, open-source, the 2026 community-standard default for new Flutter apps. Compile-time safe (catches errors before you run the app), doesn't require passing `BuildContext` around, and has first-class support for async data (loading/error/data states) — which matters a lot since almost every screen in FactShot is fetching articles from somewhere. Provider (the simpler alternative) is now considered legacy for anything beyond trivial apps. |
| Navigation | **go_router** | Official Flutter-recommended routing package. Handles deep links cleanly (important: someone shares an article link via WhatsApp, and it should open directly to that article inside the app, not just to the home screen) |
| Local storage (cache/offline) | **Hive** or **Isar** (decide during Phase 2 — see open question below) | For caching articles so they're readable offline |
| Fonts | **Google Fonts package** (`google_fonts`) | Lets you use custom typography (see `06-DESIGN.md`) without manually bundling font files |

---

## 2. State Management — Why Riverpod, Explained Simply

Think of state management as "the system that keeps different parts of the app in sync when data changes." Example: user bookmarks an article on the detail screen — the feed screen AND the Saved screen both need to reflect that instantly.

**Riverpod vs the alternatives, in plain terms:**

- **Provider** — the older, simpler approach. Fine for tiny apps, but it requires a `BuildContext` (a reference to "where you are in the widget tree") to read data, which gets awkward once you have things like a background sync service or a data-fetching layer that isn't directly tied to a screen.
- **Riverpod** — the modern evolution of Provider, by the same original author. Works without `BuildContext`, catches more mistakes at compile time (before you even run the app), and has a clean built-in pattern (`AsyncValue`) for handling "loading / error / loaded" states — which is exactly what every screen in FactShot needs, since every screen is ultimately showing data fetched from somewhere.
- **Bloc** — more rigid and verbose (separates every action into explicit "events" and "states"). Used by larger teams who need strict audit trails of state changes. Overkill for a 2-person team building an MVP.
- **GetX** — avoid. Convenient short-term, but has known long-term maintainability problems and is not considered a safe choice for a new production app in 2026.

**Bottom line for your meeting:** If the other developer suggests Provider or GetX, you now know enough to ask *"why not Riverpod, given it's async-first and we'll be fetching data on almost every screen?"* — that's a legitimate, informed question, not a guess.

---

## 3. Backend — OPEN QUESTION (Not Yet Decided)

This is the single biggest undecided technical decision. Everything else (auth, notifications, storage, hosting cost, and how much backend code you personally need to write/maintain) cascades from this.

### Option A: Firebase (Backend-as-a-Service)
- **What it is:** Google's managed backend platform — Firestore (database), Firebase Auth (login), Cloud Functions (server-side logic), Firebase Cloud Messaging/FCM (push notifications), Firebase Storage (images), all pre-built and hosted by Google.
- **Pros:** Fastest path to a working MVP for a 2-person team. No server to provision, patch, or scale manually. Deep, official Flutter integration (`firebase_core`, `cloud_firestore`, etc. are all official, well-maintained packages). Generous free tier for early-stage apps.
- **Cons:** Vendor lock-in (harder to migrate away later). Firestore's query capabilities are more limited than a relational database for complex queries. Costs can grow as usage scales.
- **Best if:** Neither of you wants to also become a backend/DevOps engineer right now, and you want to focus your limited time on the Flutter app itself.

### Option B: Custom backend (Node.js + MongoDB, or similar)
- **What it is:** You build and host your own API server that the Flutter app talks to.
- **Pros:** Full control over data structure and business logic. No vendor lock-in. Better fit if content/data relationships become complex later (e.g. advanced search, recommendation systems).
- **Cons:** You (or the other developer) now own server hosting, scaling, security patching, and uptime — on top of building the app. Auth, push notifications, and file storage all need to be wired up manually or via additional services. Meaningfully more work for a 2-person team on a tight timeline.
- **Best if:** The other developer has real production experience running a Node.js/MongoDB (or similar) backend and Factline specifically wants full data ownership from day one.

### Recommendation (non-binding — confirm with the other developer)
For a 2-person team building an MVP, **Firebase is the pragmatic starting choice.** It removes an entire job (backend infrastructure) so both of you can focus on the app and content pipeline. This isn't a permanent decision — apps commonly start on Firebase and migrate to a custom backend later once there's real usage data justifying the investment.

**Action item:** Ask the other developer directly: *"Do you have production experience running a Node.js/MongoDB backend, or should we start with Firebase and revisit this after we have real traction?"* His answer should settle this.

---

## 4. Content Source — OPEN QUESTION (Not Yet Decided)

How does an article actually get from "Factline's editorial team wrote it" to "it appears in the app"?

### Option A: Manual/direct entry (simplest for V1)
- Editorial team (or you) manually adds articles directly into Firestore (or your chosen database) via a simple admin screen or even the Firebase Console itself.
- Fastest to set up, but doesn't scale well and isn't friendly for non-technical editorial staff long-term.

### Option B: Headless CMS
- Tools like **Strapi** (open-source, self-hosted or cloud), **Contentful**, or **Sanity** give editorial staff a proper dashboard to write and publish articles, which the app then pulls via API.
- More setup work upfront, but is the right long-term answer if Factline's editorial team will be publishing to FactShot regularly and shouldn't need developer help to do it.

### Option C: Aggregation from external sources
- Pull/summarize news from external APIs or sources rather than original editorial writing.
- Raises questions about licensing, attribution, and content quality control — and moves away from Factline's editorial-credibility differentiator mentioned in `01-PROJECT_REQUIREMENTS.md`. Not recommended as the primary approach given Factline's existing editorial strength, but could supplement original content later.

**Action item:** This needs an answer from Factline's editorial/business side, not just the dev team — it affects the backend choice too (a headless CMS pairs more naturally with a custom backend or Firebase depending on the tool).

---

## 5. Full Library List (Flutter/Dart packages)

These are the concrete `pubspec.yaml` packages the project will likely need. Organized by purpose so you understand what each one is *for*, not just its name.

### UI & Design
| Package | Purpose |
|---|---|
| `google_fonts` | Custom typography without manually bundling font files |
| `flutter_svg` | Render SVG icons/logo cleanly at any size |
| `cached_network_image` | Load and cache article images efficiently — critical for a feed with many images, avoids re-downloading the same image repeatedly |
| `shimmer` | Loading-skeleton placeholder animation while content loads, instead of a blank screen or spinner |
| `flutter_animate` | Simplifies building the smooth micro-animations the design calls for |

### State & Architecture
| Package | Purpose |
|---|---|
| `flutter_riverpod` + `riverpod_annotation` | State management (see Section 2) |
| `riverpod_generator` (dev dependency) | Code generation for Riverpod's `@riverpod` annotation — reduces boilerplate |
| `go_router` | Navigation/routing, including deep links |
| `freezed` + `json_serializable` (dev dependencies) | Generates clean, immutable data model classes (e.g. `Article`, `User`) from simple class definitions — reduces manual boilerplate and bugs from hand-written model classes |

### Backend/Data (depends on Section 3 decision)
| Package | Purpose |
|---|---|
| `firebase_core`, `cloud_firestore`, `firebase_auth`, `firebase_messaging`, `firebase_storage` | If Firebase is chosen — official Flutter/Firebase integration packages |
| `dio` | If a custom backend is chosen — a robust HTTP client for calling your own API (better than Flutter's built-in `http` package for real apps: supports interceptors, timeouts, retries) |

### Local Storage/Offline
| Package | Purpose |
|---|---|
| `hive` + `hive_flutter` | Lightweight, fast local storage for caching articles/bookmarks — good default choice for this app's needs |
| `shared_preferences` | Simple key-value storage for small settings (e.g. dark mode toggle, onboarding-complete flag) |

### Utilities
| Package | Purpose |
|---|---|
| `intl` | Date/time formatting ("3 min ago", proper date display) |
| `share_plus` | Native share sheet integration (WhatsApp share is critical for this app's growth) |
| `url_launcher` | Opening external article source links in a browser |
| `connectivity_plus` | Detect online/offline state, to drive the offline-caching behavior |
| `flutter_dotenv` | Manage environment variables/secrets (API keys) safely, kept out of source control |

### Testing
| Package | Purpose |
|---|---|
| `mocktail` | Mocking dependencies in tests |
| `flutter_test` (built-in) | Flutter's standard testing framework |

**Note:** Don't install all of these on day one. Add packages as each phase actually needs them (see `05-PHASES.md`) — installing everything upfront makes the project harder to understand and increases the chance of version conflicts.

---

## 6. Things You Genuinely Don't Need to Learn Deeply Right Now

To manage your limited prep time honestly — you do **not** need to become an expert in these before your meeting. Understanding what they are is enough:

- Firebase Cloud Functions internals — only relevant once backend logic gets complex
- Dart's advanced language features (generics, mixins, isolates) — you'll pick these up naturally while building
- CI/CD pipelines — relevant later, not for MVP
- iOS-specific build configuration — V1 is Android-only

## 7. What's Genuinely Worth Understanding Before the Meeting

- What "state management" solves and why Riverpod is the modern default (Section 2)
- The Firebase vs custom backend tradeoff (Section 3) — you don't need to decide it alone, but you should understand the tradeoff
- That there's an unresolved content-source question (Section 4) that isn't really a "dev" decision — it needs Factline's editorial input

---

## 8. Related Documents

- `02-ARCHITECTURE.md` — how these tools fit into the actual project structure
- `04-RULES.md` — coding standards and boundaries once building begins
- `05-PHASES.md` — when each library/decision actually gets introduced
