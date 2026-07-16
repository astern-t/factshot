# FactShot — Rules & Boundaries

**Purpose:** This document governs how code gets written on this project — by you, another developer, or an AI coding agent. If an AI agent is reading this before making changes, these rules are not suggestions — follow them exactly, and if a requested change would violate one of these rules, flag it before proceeding rather than silently breaking the rule.

**Note:** Library/tool choices live in `03-KNOWLEDGE_BASE.md`, not here. This document is about *how* to write code, not *which packages* to use.

---

## 1. Structural Rules (enforce `02-ARCHITECTURE.md`)

1. **Never create a new top-level folder** without updating `02-ARCHITECTURE.md` first. The architecture doc is the source of truth; code should match it, not the other way around.
2. **Never put business logic inside a `_screen.dart` file.** Screen files describe layout only. Anything involving data fetching, state changes, or decision logic belongs in a `providers/` file.
3. **Never bundle multiple widgets into one file "for convenience."** Even a 5-line widget gets its own file, per the architecture document. If you're tempted to combine files, that's a signal to re-check the architecture doc, not to override it.
4. **A feature-specific widget stays inside that feature's folder** until it's used in 3+ places — only then does it get promoted to `core/widgets/`.
5. **Every new screen must be registered in `app_router.dart`**, not navigated to via ad-hoc `Navigator.push` calls scattered through the code.

---

## 2. Error Handling Standards

Error handling is not optional or an afterthought — every feature that touches data (which is almost everything) must handle three states explicitly: **loading, error, and success.** Never assume a network call or data fetch will simply succeed.

### Rules:
1. **Use Riverpod's `AsyncValue` for any provider dealing with async data** (fetching articles, logging in, saving a bookmark). This forces loading/error/data handling to be explicit rather than accidentally skipped.
2. **Never show a raw exception or stack trace to the user.** All errors shown in the UI must go through `core/errors/error_handler.dart`, which maps technical errors to plain, human-readable messages (e.g. "Couldn't load news right now — pull to refresh" instead of a raw `SocketException`).
3. **Every screen that fetches data must have a defined empty state, error state, and loading state UI** — not just a happy-path design. If a screen's design doesn't show what happens when data fails to load or there's nothing to show, that's an incomplete screen, not a later fix.
4. **Network failures must be recoverable, not dead ends.** At minimum: pull-to-refresh or a visible "Retry" action. Never leave the user on a blank screen with no way forward.
5. **Log errors during development** (console/print acceptable for now) but never leave debug logging that exposes sensitive data (tokens, user info) in a shape that could ship to production.
6. **Offline behavior is not an error state.** If the device is offline, the app should show cached content with a clear "You're offline — showing saved articles" indicator, not an error message. Use `connectivity_plus` to distinguish "no internet" from "something actually broke."

---

## 3. Code Quality Standards

1. **No hardcoded strings in widget files.** User-facing text goes through `core/constants/app_strings.dart`. This isn't just style — it's what makes future multi-language support possible without a rewrite.
2. **No hardcoded colors, font sizes, or spacing values anywhere in a widget.** Everything pulls from `core/theme/`. If a value isn't in the theme files yet, add it there — don't inline a one-off value "just this once." See `06-DESIGN.md`.
3. **No magic numbers or strings for route names.** Use `route_names.dart` constants.
4. **Prefer composition over duplication.** If you're about to copy-paste a widget with minor tweaks, that's a signal it should take parameters instead.
5. **Null safety is not optional.** Don't use `!` (force-unwrap) to silence a null-safety warning unless you can explain in a comment exactly why the value is guaranteed non-null at that point.
6. **Every model class uses Freezed**, not a hand-written class with manual `copyWith`/`toJson`/`fromJson` — this avoids an entire category of easy-to-introduce bugs.

---

## 4. What to Avoid

- **GetX** — not used on this project (see `03-KNOWLEDGE_BASE.md` for reasoning: maintenance concerns, less structured for a growing codebase)
- **Direct Firebase/API calls from inside a widget or screen file** — always go through a `repository` (see `02-ARCHITECTURE.md` Section 4)
- **`setState` for anything beyond truly local, ephemeral UI state** (e.g. whether a single dropdown is currently open). Anything shared across widgets or screens goes through Riverpod.
- **Adding a new package without checking `03-KNOWLEDGE_BASE.md` first** — if it's not listed there and isn't trivially justified, flag it for a decision rather than silently adding a dependency.
- **Committing API keys, tokens, or secrets directly in code.** Use environment variables (`flutter_dotenv`) and ensure `.env` is in `.gitignore`.
- **Building UI directly against Firestore/API response shapes.** Always map raw data into the app's own Freezed models first (in the `sources/` layer) — screens should never know or care what the raw backend response looks like.

---

## 5. Boundaries for AI Agents Specifically

If you are an AI agent (Claude, Codex, Antigravity, or otherwise) working on this codebase, these boundaries apply on top of everything above:

1. **Read `07-MEMORY.md` before making any change.** It tracks what's already built and what's still pending — don't rebuild or re-decide something that's already been resolved there, and don't assume something is done just because a doc describes the plan.
2. **Update `07-MEMORY.md` after every meaningful change** — new file created, feature completed, decision made. This is not optional; it's what allows a future session (possibly a different AI agent entirely) to pick up work correctly without re-reading the whole codebase from scratch.
3. **Do not restructure `02-ARCHITECTURE.md`'s folder layout unilaterally.** If you believe the structure needs to change, propose the change and explain why — don't just implement a different structure silently.
4. **Do not make backend or content-source decisions that are marked "OPEN QUESTION" in `03-KNOWLEDGE_BASE.md`.** These require human input (Swarnil and the other developer, or Factline's editorial team). If a task requires one of these decisions to proceed, stop and ask rather than picking one arbitrarily.
5. **When given a vague instruction, prefer asking a clarifying question over guessing silently** — especially for anything touching data models, navigation structure, or the theme system, since mistakes here are expensive to unwind later.
6. **Never introduce a new state-management pattern, a second navigation approach, or a competing "shared widgets" location.** One state management library (Riverpod), one router (go_router), one shared widgets folder (`core/widgets/`) — consistency matters more than any individual improvement idea.
7. **Do not silently skip error/loading/empty states "to move faster."** Per Section 2, these are required, not optional polish — an AI agent skipping them to produce a "quick" version creates rework, not speed.
8. **When in doubt about whether something belongs in `core/` or a `feature/` folder, default to the feature folder** (see Section 1, rule 4) — it's the safer default per the architecture document.

---

## 6. Related Documents

- `02-ARCHITECTURE.md` — the structure these rules enforce
- `03-KNOWLEDGE_BASE.md` — approved libraries and tools referenced in Section 4
- `07-MEMORY.md` — must be read and updated per Section 5
