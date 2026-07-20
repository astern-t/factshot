# FactShot — Architecture Document

**Status:** v1.1 — Reflects the current prototype architecture (using InheritedNotifier & custom transitions) and outlines the migration path to v2.0 (Riverpod & go_router).

---

## 1. Guiding Principle

**Every distinct piece of UI or logic gets its own file. Every distinct feature gets its own folder. Nothing is bundled together "for convenience."**

**Concretely, this means:**
- A feature or screen is not a single file — it is a dedicated folder containing the screen file and a `widgets/` subfolder for screen-specific UI components.
- A button used only on one screen gets its own file inside that screen's `widgets/` subfolder.
- A button reused across many screens (3+ places) gets promoted to the `lib/core/widgets/` folder.
- Business/state logic is separated from visual representation — screens describe layouts and bind to the global state provider (`AppScope`), keeping event handlers clean.

---

## 2. Tech Stack Summary

| Layer | Prototype (v1.1) | Production Target (v2.0) |
|---|---|---|
| **Framework** | Flutter (Dart) | Flutter (Dart) |
| **State Management** | `AppState` / `InheritedNotifier` (`AppScope`) | Riverpod (with code generation) |
| **Navigation** | Vanilla `Navigator` + `GlassPageRoute` | `go_router` + `GlassPageRoute` |
| **Local Storage** | `shared_preferences` | Hive (offline caching) + `shared_preferences` |
| **Models** | Standard Dart data classes | Freezed + json_serializable models |
| **Backend** | In-memory Mock Data (`mockArticles`) | Firebase or Custom API (TBD) |

The current prototype codebase uses a unified `AppState` model to drive settings, preferences, and feed configurations. This keeps the prototype modular and prepares it for a clean migration to Riverpod providers in Phase 2.

---

## 3. App Flow (High-Level User Journey)

```
Splash Screen
     ↓
[First launch?] → Onboarding (3 slides + accent selection) → Language Screen (App & Content languages)
     ↓
Login Screen (Google / Apple / Continue as Guest)
     ↓
Home Shell (persistent bottom navigation)
     ├── Home Feed (swipeable cards, category filter bar, video previews)
     │        ↓ (tap card)
     │     Article Detail (TTS narration, custom text scaler, web source viewer)
     ├── Explore (category grid selection)
     │        ↓ (tap category)
     │     Home Feed (pre-filtered)
     ├── Search (history keywords, real-time query list)
     │        ↓ (tap result)
     │     Article Detail
     ├── Bookmarks (saved articles collection, swipe-to-delete)
     │        ↓ (tap item)
     │     Article Detail
     └── Profile (accessibility settings, narration pitch/gender toggles, light/dark mood selection)
```

---

## 4. Folder & File Structure

Below is the authoritative layout of the current prototype. All features are isolated in their own modules under `lib/features/`, and shared components reside in `lib/core/`.

```
factshot/
│
├── lib/
│   │
│   ├── main.dart                          # App entry point - runs FactShotApp
│   │
│   ├── app/                               # App-wide configurations and state providers
│   │   ├── app.dart                       # Root MaterialApp widget and light/dark theme wiring
│   │   └── app_state.dart                 # AppState ChangeNotifier and AppScope inherited provider
│   │
│   ├── core/                              # Shared, app-wide code
│   │   ├── theme/
│   │   │   └── liquid_glass_theme.dart    # Central styling system (typography, colors, spacing, borders)
│   │   │
│   │   ├── utils/
│   │   │   ├── article_translations.dart   # Translation helpers for news article keys
│   │   │   ├── narration_service.dart     # Text-to-speech simulation engine
│   │   │   ├── transition_helper.dart     # GlassPageRoute custom animations
│   │   │   └── translations.dart          # Localized language dictionary maps
│   │   │
│   │   └── widgets/                       # Standalone shared UI controls (used in 3+ features)
│   │       ├── article_image/             # Image loaders with animation
│   │       ├── article_list_tile_card/    # Structured card layout for bookmarks/search
│   │       ├── article_meta_row/          # Subtitles showing source and timestamps
│   │       ├── empty_state_card/          # Informational graphics for blank screens
│   │       ├── fact_listen_waveform/      # Narration audio visualizer waveform
│   │       ├── factshot_background/       # Unified theme background scaffold container
│   │       ├── glass_button/              # Glassmorphic flat controls
│   │       ├── glass_chip/                # Filter tags and accents
│   │       ├── glass_icon_button/         # Glassmorphic rounded icons
│   │       ├── glass_message/             # Animated overlay popup message pill
│   │       ├── glass_surface/             # Main blur container shell
│   │       ├── glass_text_field/          # Blurry input fields
│   │       ├── pressable_scale/           # Scaling gesture haptic wrapper
│   │       └── skeleton_block/            # Shimmer loading skeleton shapes
│   │
│   ├── data/                              # Data storage & models
│   │   └── models/
│   │       └── article/
│   │           └── article_model.dart     # NewsArticle entity declaration & mock database
│   │
│   └── features/                          # Feature modules
│       ├── article_detail/
│       │   └── article_detail_screen.dart # Detail layout, font resizing, action bar, and audio controls
│       │
│       ├── auth/
│       │   └── presentation/
│       │       ├── screens/
│       │       │   └── login_screen.dart  # Sign-in UI
│       │       └── widgets/
│       │           ├── apple_login_card.dart
│       │           ├── google_login_card.dart
│       │           ├── guest_login_card.dart
│       │           ├── login_background.dart
│       │           ├── login_logo.dart
│       │           ├── privacy_footer.dart
│       │           └── welcome_header.dart
│       │
│       ├── bookmarks/
│       │   └── bookmarks_screen.dart      # Bookmark screen with dismissible/swipeable actions
│       │
│       ├── explore/
│       │   └── explore_screen.dart        # Explore dashboard containing category grids
│       │
│       ├── home_feed/
│       │   └── home_feed_screen.dart      # Primary news swiper feed & view mode selection
│       │
│       ├── language/
│       │   └── language_screen.dart       # App interface & content language onboarding selector
│       │
│       ├── onboarding/
│       │   └── onboarding_screen.dart     # PageView slide presentation & features highlight
│       │
│       ├── profile/
│       │   └── profile_screen.dart        # App personalization toggles & sliders
│       │
│       ├── search/
│       │   └── search_screen.dart         # Query bar with dynamic results list and search history
│       │
│       ├── shell/
│       │   └── home_shell.dart            # Main navigation shell with bottom bar configuration
│       │
│       └── splash/
│           # Empty directory for future animated splash implementation
│
├── assets/                                # Resource files (logos, svg vectors)
├── test/
│   └── widget_test.dart                   # Mirrors structure of lib/
└── pubspec.yaml
```

---

## 5. Why This Structure (Explaining the Reasoning)

- **One file per component, no exceptions.** Keeping files small and specific reduces git conflicts and makes it easy to locate the source of visual elements or bugs.
- **Strict core vs feature distinction:** If a widget is used solely in `auth`, it remains in `features/auth/presentation/widgets/`. Once a component is reused across 3 or more features (such as `GlassButton` or `GlassSurface`), it is moved to `core/widgets/`.
- **Prepared for Migration:** While the app currently uses a centralized `AppState` model, this matches the business logic segregation rule. In Phase 2, the `app_state.dart` variables will cleanly map to individual Riverpod StateProviders/NotifierProviders (e.g. `bookmarksProvider`, `themeModeProvider`, `appLanguageProvider`), and the ad-hoc Navigator pushes will be mapped to a clean go_router file.

---

## 6. Naming Conventions

- **Files:** `snake_case.dart`
- **Folders:** `snake_case`
- **Classes:** `PascalCase`
- **Widgets:** Filename must match the name of the main class defined inside it (e.g. `LoginScreen` lives in `login_screen.dart`).

---

## 7. Related Documents

- `01-PROJECT_REQUIREMENTS.md` — requirements details
- `03-KNOWLEDGE_BASE.md` — technical stack comparisons and package lists
- `04-RULES.md` — coding rules, error management, and boundaries
- `07-MEMORY.md` — latest development summaries and logs
