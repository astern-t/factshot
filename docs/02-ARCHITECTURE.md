# FactShot — Architecture Document

**Status:** v1.0 — Governs all code structure decisions. AI agents and developers must follow this structure exactly; see `04-RULES.md` for enforcement boundaries.

---

## 1. Guiding Principle

**Every distinct piece of UI or logic gets its own file. Every distinct feature gets its own folder. Nothing is bundled together "for convenience."**



**Concretely, this means:**
- A login page is not one file — it's a `login/` folder containing the page, its own widgets, and its own logic, each separated
- A button used only on one screen still gets its own file inside that screen's `widgets/` subfolder
- A button reused across many screens gets promoted to the shared/global widgets folder
- No file should mix "what the screen looks like" with "how data gets fetched" — UI and logic are always separated (this is the whole point of using Riverpod — see `03-KNOWLEDGE_BASE.md`)

---

## 2. Tech Stack Summary

| Layer | Choice |
|---|---|
| Framework | Flutter (Dart) |
| State management | Riverpod (with code generation) |
| Navigation | go_router |
| Backend | **Not yet decided** — Firebase or custom (see `03-KNOWLEDGE_BASE.md` Section 3). Architecture below is written so either choice slots into the same `data/` layer without restructuring the rest of the app. |
| Local storage | Hive (offline caching) + shared_preferences (settings) |
| Models | Freezed + json_serializable (generated immutable data classes) |

This is intentionally kept flexible on backend — the folder structure isolates backend-specific code into a `data/` layer precisely so that decision doesn't ripple through the whole codebase.

---

## 3. App Flow (High-Level User Journey)

```
Splash Screen
     ↓
[First launch?] → Onboarding (3 slides + category preference) → Login/Guest choice
     ↓ (returning user, or after onboarding)
Login Screen (Google / Phone / Continue as Guest)
     ↓
Home Shell (persistent bottom navigation)
     ├── Home Feed (swipeable card stack, category filter bar)
     │        ↓ (tap card)
     │     Article Detail
     ├── Explore (category grid)
     │        ↓ (tap category)
     │     Home Feed, pre-filtered
     ├── Search
     │        ↓ (tap result)
     │     Article Detail
     ├── Bookmarks (Saved)
     │        ↓ (tap item)
     │     Article Detail
     └── Profile
              ↓
           Settings sub-screens (Notifications, Categories, About, etc.)
```

**Deep link behavior (from Section 1 of Knowledge Base):** an external share link opens directly into Article Detail, bypassing the shell if the app is opened cold — `go_router` handles this.

---

## 4. Folder & File Structure

This is the authoritative structure. Every AI agent or developer working on this codebase follows this exactly. If a new feature doesn't fit cleanly into this structure, that's a signal to update this document first — not to improvise a one-off placement.

```
factshot/
│
├── lib/
│   │
│   ├── main.dart                          # App entry point ONLY — sets up ProviderScope, runs app. No logic here.
│   │
│   ├── app/
│   │   ├── app.dart                       # Root MaterialApp widget, theme + router wiring
│   │   └── router/
│   │       ├── app_router.dart            # go_router configuration — all routes defined here
│   │       └── route_names.dart           # Route name constants (avoid magic strings)
│   │
│   ├── core/                              # Shared, app-wide code that isn't feature-specific
│   │   ├── theme/
│   │   │   ├── app_colors.dart            # ALL color values — the single source of truth (see 06-DESIGN.md)
│   │   │   ├── app_typography.dart        # ALL text styles
│   │   │   ├── app_spacing.dart           # Spacing scale constants (4/8/12/16/24/32)
│   │   │   ├── app_radius.dart            # Corner radius constants
│   │   │   └── app_theme.dart             # Combines the above into Flutter's ThemeData — this is what main.dart consumes
│   │   │
│   │   ├── constants/
│   │   │   ├── app_strings.dart           # Static text (avoid hardcoding strings in widgets)
│   │   │   └── app_assets.dart            # Asset path constants (image/icon paths)
│   │   │
│   │   ├── utils/
│   │   │   ├── date_formatter.dart        # e.g. "3 min ago" logic
│   │   │   └── validators.dart            # Input validation helpers (e.g. phone number format)
│   │   │
│   │   ├── errors/
│   │   │   ├── app_exception.dart         # Custom exception types (see 04-RULES.md for error handling standards)
│   │   │   └── error_handler.dart         # Centralized error-to-user-message mapping
│   │   │
│   │   └── widgets/                       # ONLY widgets used across 3+ features. Not a dumping ground.
│   │       ├── glass_surface/
│   │       │   └── glass_surface.dart     # The shared "glass card" building block (see 06-DESIGN.md)
│   │       ├── primary_button/
│   │       │   └── primary_button.dart
│   │       ├── loading_indicator/
│   │       │   └── loading_indicator.dart
│   │       ├── shimmer_skeleton/
│   │       │   └── shimmer_skeleton.dart
│   │       └── error_view/
│   │           └── error_view.dart
│   │
│   ├── data/                              # Everything about WHERE data comes from — isolated from UI entirely
│   │   ├── models/
│   │   │   ├── article/
│   │   │   │   └── article_model.dart     # Freezed model — one model, one folder, one file
│   │   │   ├── user/
│   │   │   │   └── user_model.dart
│   │   │   └── category/
│   │   │       └── category_model.dart
│   │   │
│   │   ├── repositories/                  # The abstraction layer between features and raw data sources
│   │   │   ├── article_repository.dart    # Defines HOW to get articles — features call this, never the raw data source directly
│   │   │   ├── auth_repository.dart
│   │   │   └── bookmark_repository.dart
│   │   │
│   │   └── sources/                       # The actual implementation — swappable if backend choice changes
│   │       ├── remote/
│   │       │   └── article_remote_source.dart   # Firebase/API calls live here specifically
│   │       └── local/
│   │           └── article_local_source.dart    # Hive/cache calls live here specifically
│   │
│   ├── features/                          # One folder per feature/screen. This is the bulk of the app.
│   │   │
│   │   ├── splash/
│   │   │   ├── splash_screen.dart
│   │   │   └── widgets/
│   │   │       └── splash_logo_animation.dart
│   │   │
│   │   ├── onboarding/
│   │   │   ├── onboarding_screen.dart
│   │   │   ├── widgets/
│   │   │   │   ├── onboarding_slide.dart
│   │   │   │   └── page_indicator_dots.dart
│   │   │   └── providers/
│   │   │       └── onboarding_provider.dart
│   │   │
│   │   ├── auth/
│   │   │   ├── login_screen.dart          # The screen itself — layout only
│   │   │   ├── widgets/
│   │   │   │   ├── google_signin_button.dart
│   │   │   │   ├── phone_signin_button.dart
│   │   │   │   └── guest_continue_link.dart
│   │   │   └── providers/
│   │   │       └── auth_provider.dart     # Login logic lives here, NOT in the widget file
│   │   │
│   │   ├── home_feed/
│   │   │   ├── home_feed_screen.dart
│   │   │   ├── widgets/
│   │   │   │   ├── news_card/
│   │   │   │   │   └── news_card.dart
│   │   │   │   ├── category_filter_bar/
│   │   │   │   │   └── category_filter_bar.dart
│   │   │   │   ├── category_chip/
│   │   │   │   │   └── category_chip.dart
│   │   │   │   └── card_action_row/         # bookmark/share icons row on each card
│   │   │   │       └── card_action_row.dart
│   │   │   └── providers/
│   │   │       ├── feed_provider.dart
│   │   │       └── category_filter_provider.dart
│   │   │
│   │   ├── article_detail/
│   │   │   ├── article_detail_screen.dart
│   │   │   ├── widgets/
│   │   │   │   ├── article_hero_image.dart
│   │   │   │   ├── article_byline.dart
│   │   │   │   └── article_action_bar.dart
│   │   │   └── providers/
│   │   │       └── article_detail_provider.dart
│   │   │
│   │   ├── explore/
│   │   │   ├── explore_screen.dart
│   │   │   └── widgets/
│   │   │       └── category_grid_card.dart
│   │   │
│   │   ├── search/
│   │   │   ├── search_screen.dart
│   │   │   ├── widgets/
│   │   │   │   ├── search_bar_field.dart
│   │   │   │   ├── trending_search_chip.dart
│   │   │   │   └── recent_search_row.dart
│   │   │   └── providers/
│   │   │       └── search_provider.dart
│   │   │
│   │   ├── bookmarks/
│   │   │   ├── bookmarks_screen.dart
│   │   │   ├── widgets/
│   │   │   │   ├── bookmark_list_item.dart
│   │   │   │   └── bookmarks_empty_state.dart
│   │   │   └── providers/
│   │   │       └── bookmarks_provider.dart
│   │   │
│   │   ├── profile/
│   │   │   ├── profile_screen.dart
│   │   │   ├── widgets/
│   │   │   │   ├── profile_header.dart
│   │   │   │   └── settings_row.dart
│   │   │   └── providers/
│   │   │       └── profile_provider.dart
│   │   │
│   │   └── shell/
│   │       ├── home_shell.dart            # The persistent bottom-nav wrapper around the 5 main tabs
│   │       └── widgets/
│   │           └── bottom_nav_bar.dart
│   │
│   └── l10n/                              # Reserved for future multi-language support (not used in V1, folder exists so structure doesn't need to change later)
│
├── assets/
│   ├── images/
│   ├── icons/
│   └── fonts/
│
├── test/                                  # Mirrors lib/ structure exactly — see 04-RULES.md
│
└── pubspec.yaml
```

---

## 5. Why This Structure (Explaining the Reasoning)

**One file per component, no exceptions, even for small things.** A button that looks like 5 lines of code still gets its own file. This feels excessive at first, but the payoff is: when you or an AI agent needs to change "the bookmark icon behavior," there's exactly one obvious file to open — `card_action_row.dart` or wherever it specifically lives — instead of hunting through a 400-line screen file.

**`features/` vs `core/` — the rule for where something goes:**
- If it's used on exactly one screen → it lives inside that feature's own `widgets/` folder
- If it's used across 3 or more different features → it gets promoted to `core/widgets/`
- When in doubt, start it inside the feature folder. Promoting something later is a simple move; de-tangling a shared widget that grew too many special cases is not.

**`data/` is isolated from `features/` on purpose.** This is what makes the "Firebase vs custom backend" decision (still open — see `03-KNOWLEDGE_BASE.md`) safe to defer. Features never call Firebase or an API directly — they only ever talk to a `repository`. If the backend choice changes later, only the `sources/` folder needs to change; no feature code is touched.

**`providers/` inside each feature folder** is where Riverpod logic lives, always separate from the `_screen.dart` file. The screen file should only describe layout — "what does this look like" — and read from providers. Business logic ("what happens when the user taps bookmark") lives in the provider, not the widget's `onPressed` callback.

---

## 6. Naming Conventions

- Files: `snake_case.dart`
- Folders: `snake_case`
- Classes: `PascalCase`
- One public widget class per file, and the filename matches the class name (e.g. `NewsCard` class lives in `news_card.dart`)
- Providers named descriptively with a `Provider` suffix (e.g. `feedProvider`, `bookmarksProvider`)

---

## 7. Related Documents

- `03-KNOWLEDGE_BASE.md` — full library list and reasoning behind each tech choice referenced here
- `04-RULES.md` — coding standards, error handling approach, and boundaries when AI agents modify this structure
- `07-MEMORY.md` — tracks which parts of this structure are actually built vs still planned
