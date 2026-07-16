# FactShot — Development Phases

**Purpose:** Breaks the build into 5 phases. This is a working estimate, not a fixed deadline — you're learning Flutter while building, and there's a second developer whose availability/skill level isn't fully known yet. Treat the time estimates as rough scaffolding to reforecast once Phase 1 is actually underway, not a commitment to hit exactly.

**How to use this doc:** Update `07-MEMORY.md` as each phase item is completed. This doc describes the plan; `07-MEMORY.md` describes current reality.

---

## Phase 0 — Foundation & Decisions (before writing app code)

**Goal:** Resolve the open questions that everything else depends on, and get the project skeleton in place.

- [ ] Finalize backend choice: Firebase vs custom (see `03-KNOWLEDGE_BASE.md` Section 3)
- [ ] Finalize content-source approach with Factline's editorial side (Section 4)
- [ ] Confirm second developer's role split (who owns what)
- [ ] Set up Flutter project with the exact folder structure from `02-ARCHITECTURE.md` (empty files/folders are fine at this stage — structure first, content later)
- [ ] Set up version control (Git repo, branching approach — even a simple `main` + feature branches is enough for a 2-person team)
- [ ] Set up Firebase project or backend server skeleton, depending on Phase 0 decision
- [ ] Finalize logo and core brand assets (in progress separately)

**Exit criteria:** Both developers can run an empty Flutter app on their machines, folder structure matches the architecture doc, and the backend/content decisions are no longer open questions.

**Rough estimate:** 3–5 days, assuming decisions move quickly once the meeting happens.

---

## Phase 1 — Core UI Shell (no real data yet)

**Goal:** Build every screen with the correct visual design, using mock/dummy data, fully navigable. This is the "looks and feels finished" milestone, even though nothing is real yet.

- [ ] Theme system built (`core/theme/` — colors, typography, spacing, matching `06-DESIGN.md`)
- [ ] Shared widgets built (`GlassSurface`, `PrimaryButton`, `LoadingIndicator`, `ShimmerSkeleton`, `ErrorView`)
- [ ] Splash screen
- [ ] Onboarding flow (3 slides, swipeable, working navigation)
- [ ] Login screen (UI only — buttons don't need to authenticate yet, just navigate forward)
- [ ] Home Shell + bottom navigation, all 5 tabs reachable
- [ ] Home Feed screen with swipeable card stack (mock articles)
- [ ] Category filter bar (UI functional — filters the mock data client-side)
- [ ] Article Detail screen
- [ ] Explore screen
- [ ] Search screen (UI + filtering mock data, no real backend search yet)
- [ ] Bookmarks screen (bookmarking mock articles works and persists during the session)
- [ ] Profile/Settings screen

**Exit criteria:** A stakeholder can click through the entire app start to finish and it feels complete, even though every piece of content is fake and nothing is saved permanently yet.

**Rough estimate:** 2–3 weeks, given you're both learning Flutter concurrently. This is the largest phase — budget the most time here.

---

## Phase 2 — Real Data & Persistence

**Goal:** Replace mock data with the real backend, and make state actually persist.

- [ ] Backend connected (Firestore or custom API, per Phase 0 decision)
- [ ] `data/repositories/` and `data/sources/` implemented per `02-ARCHITECTURE.md`
- [ ] Real articles flowing from the chosen content source into the Home Feed
- [ ] Bookmarks persist properly (Hive for local-only, or synced to backend if user is logged in)
- [ ] Search connected to real data
- [ ] Local caching for offline reading (Hive) implemented and tested by actually turning off WiFi
- [ ] Basic authentication working (Google sign-in / phone / guest mode) if backend supports it
- [ ] Error/loading/empty states verified for every data-driven screen (per `04-RULES.md` Section 2 — not optional)

**Exit criteria:** The app works with real content, survives a poor/no network connection gracefully, and bookmarks/preferences actually persist between app restarts.

**Rough estimate:** 1.5–2 weeks, longer if the custom-backend path was chosen instead of Firebase.

---

## Phase 3 — Notifications, Polish & Missing Features

**Goal:** Add the remaining V1 must-have features and do a real quality pass.

- [ ] Push notifications (breaking news / daily digest) via FCM
- [ ] Share functionality (native share sheet, deep-linkable article URLs)
- [ ] Dark mode toggle wired to actually affect the whole app (not just a static switch)
- [ ] Pull-to-refresh on Home Feed
- [ ] Animation/transition polish pass across all screens (per `06-DESIGN.md`)
- [ ] Full audit against `01-PROJECT_REQUIREMENTS.md` Section 6.1 — confirm every "Must-Have for V1" feature is actually implemented and working, not just visually implied
- [ ] Performance pass: check for janky scrolling, slow image loads, unnecessary rebuilds

**Exit criteria:** Every Must-Have feature from the requirements doc works end-to-end, and the app feels smooth and premium, not just functional.

**Rough estimate:** 1.5–2 weeks.

---

## Phase 4 — Testing, Stability & Internal Release

**Goal:** Get the app stable and installable for a real test group.

- [ ] Manual QA pass across all core flows (feed scroll, bookmark, search, share, notifications, offline mode)
- [ ] Fix crashes/bugs found during QA
- [ ] Basic automated tests for critical logic (repositories, providers — not full UI test coverage, that's a later investment)
- [ ] App icon, splash branding, and Play Store listing assets finalized
- [ ] Build signed release APK/App Bundle
- [ ] Set up Google Play internal testing track
- [ ] Distribute to a small real test group (friends, colleagues, or a soft internal Factline rollout) and collect qualitative feedback

**Exit criteria:** Matches the Success Criteria section in `01-PROJECT_REQUIREMENTS.md` — stable, real users have tried it for at least a week, and there's a working end-to-end content pipeline.

**Rough estimate:** 1–1.5 weeks.

---

## Total Rough Estimate

**~6–9 weeks** from Phase 0 kickoff to internal test release, assuming steady part-time-to-full-time effort from two developers, one of whom (you) is learning Flutter concurrently. This will almost certainly shift once Phase 1 is underway and you have a real sense of pace — **re-forecast after Phase 1**, don't treat this as a hard commitment communicated to stakeholders yet.

## What Could Realistically Push This Longer
- Backend decision (Phase 0) takes longer than expected to resolve
- Content pipeline (editorial side) isn't ready even if the app is
- Learning curve on Riverpod/Flutter is steeper than expected for either developer
- Second developer's actual availability/skill level differs from what's assumed today

---

## Related Documents

- `01-PROJECT_REQUIREMENTS.md` — the feature list these phases are building toward
- `07-MEMORY.md` — actual current progress against this plan, updated continuously
