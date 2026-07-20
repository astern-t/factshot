# FactShot — Project Memory

Version: 1.1

Status:
Living Document

Purpose:
This file is the project's memory.

Every AI agent and every developer MUST read this file before writing or modifying code.

The goal of this document is to eliminate the need to scan the entire project every time work begins.

This file contains only the CURRENT state of the project.

Completed work.

Current architecture.

Open issues.

Pending tasks.

Recent decisions.

Next priority.

Whenever a meaningful change is made this file MUST be updated.

This document always represents the latest truth.

---

# Quick Project Overview

Project Name: FactShot
Owner: Swarnil Raj
Company: Factline
Platform: Flutter
Current Target: Android
Future Target: iOS
Current Stage: Prototype Development
Current Phase: Phase 1
Documentation Status:
✓ Requirements
✓ Architecture
✓ Rules
✓ Design
✓ Phases
✓ Memory

---

# Current Progress

Project Setup:
- Flutter Project: Completed
- Folder Structure: Completed (Migrated to enterprise-grade directory setup matching `docs/02-ARCHITECTURE.md`)
- Theme System: Centralized at `lib/core/theme/liquid_glass_theme.dart` (Prototype UI themed successfully)
- Navigation: Shell navigation wrapper running via `lib/features/shell/home_shell.dart`
- Core UI Widgets: Split into dedicated standalone component files under `lib/core/widgets/`

Features Implemented (Prototype UI):
- Onboarding (horizontal PageView): Completed
- Language selection (grid of languages, selection feedback, AppState persistence, settings sheet): Completed
- Login (validations, Apple login, Guest route): Completed
- Home Feed (vertical feed, category filters, swipeable articles): Completed
- Explore (category selections): Completed
- Search (real-time filtering, suggestions, trending topics): Completed
- Bookmarks (swipe-to-remove, persistent state within prototype session): Completed
- Profile/Settings (material mood customization, accent switching, Day/Night mode toggling): Completed
- Article Detail (immersive full-page text with key takeaways, sharing, bookmarks): Completed

---

# Folder Status

`lib/` Structure:
- Status: Clean (Strict adherence to Architecture rules)
- Directories:
  - `app/` (Root configurations, providers, state scopes)
  - `core/` (Theme tokens, utility routes, shared controls, feedback, article items)
  - `data/` (News data models and local feeds)
  - `features/` (Splash, Onboarding, Auth, Home Feed, Article Detail, Explore, Search, Bookmarks, Profile, Shell navigation)

---

# Current Decisions

Theme: Dark First, Glassmorphism design system
Architecture: Feature-First & Layered combination (AI-friendly, scalable)
State Management: InheritedNotifier model (AppState/AppScope) - prototype stage
Navigation: Transition-based routing via `GlassPageRoute`

---

# Known Issues / Tech Debt

- No actual API or networking layer yet (mock content index).
- Prototype state management is temporary (will scale to Riverpod or Bloc in production phases).
- No production database integration (prototype session-only memory).

---

# Current File Structure

```
lib/
├── app/
│   ├── app.dart (FactShotApp root)
│   └── app_state.dart (AppState notifier and AppScope provider)
├── core/
│   ├── theme/
│   │   └── liquid_glass_theme.dart
│   ├── utils/
│   │   └── transition_helper.dart
│   └── widgets/
│       ├── article_image/
│       ├── article_list_tile_card/
│       ├── article_meta_row/
│       ├── empty_state_card/
│       ├── factshot_background/
│       ├── glass_button/
│       ├── glass_chip/
│       ├── glass_icon_button/
│       ├── glass_message/
│       ├── glass_surface/
│       ├── glass_text_field/
│       └── skeleton_block/
├── data/
│   └── models/
│       └── article/
│           └── article_model.dart (NewsArticle entity & mockArticles mock database)
└── features/
    ├── article_detail/
    ├── auth/ (LoginScreen)
    ├── bookmarks/
    ├── explore/
    ├── home_feed/
    ├── onboarding/
    ├── profile/
    ├── search/
    ├── shell/ (MainNavigation shell wrapper)
    └── splash/
```

---

# Next Priority

1. Refine production architecture definitions (incorporate Riverpod and Hive database plugins when moving to the production phase).
2. Wire up concrete networking layers (Dio/Retrofit) and local database persistence (Hive/Isar).
3. Connect notification managers.

---

# Last Session

Date: 2026-07-20
Completed:
- Cleaned up Onboarding Screen background in dark mode: set scaffold to pure black (`0xFF000000`) and hid ambient orbs to ensure a true, distraction-free dark mode.
- Unified Onboarding Screen colors across all pages, setting them to the app's primary theme accent color (`0xFF5AB2FF`) for consistent button highlights and container indicator details.
- Updated `02-ARCHITECTURE.md` (Architecture Blueprint) to represent the current file structure and prototype state management details accurately, including the future migration roadmap to Riverpod and go_router in Phase 2.
- Verified compilation and confirmed that all unit/widget tests continue to pass.

---

# AI Instructions

Every AI agent MUST:
- Read this file first.
- Never rebuild completed work.
- Never change project architecture without updating `02-ARCHITECTURE.md`.
- Update this file after every meaningful change.