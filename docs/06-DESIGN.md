# FactShot — Design System

**Status:** v1.0 — Governs all visual decisions. Every value referenced here must live in `core/theme/` per `02-ARCHITECTURE.md` — nothing described in this document should ever be hardcoded inline in a widget.

---

## 1. Design Philosophy

FactShot should feel like a premium, confident, editorial product — closer to Apple News or a well-funded media startup than a generic template app. Two platform-specific expectations to hold simultaneously:

- **On iOS/Apple devices:** should feel at home next to native iOS apps — respecting Apple's material/depth conventions, smooth physics-based motion, restrained color use
- **On Android:** should feel equally premium, not like an iOS app awkwardly ported over — respecting Android's own motion and elevation conventions where they differ, while keeping the same brand identity

This is achieved by centralizing all styling decisions (this document) and letting Flutter's platform-adaptive capabilities handle small native differences, rather than hardcoding one platform's exact conventions everywhere.

---

## 2. Centralization Rule

**Every color, font size, spacing value, and corner radius used anywhere in the app must be defined once, in `core/theme/`, and referenced everywhere else — never redefined or hardcoded per-screen.**

This is what makes "change the whole app's look by editing one file" possible. If you decide to shift the accent color six weeks from now, that should be a one-line change in `app_colors.dart`, not a find-and-replace across 40 files.

Files responsible for this (per `02-ARCHITECTURE.md`):
- `core/theme/app_colors.dart`
- `core/theme/app_typography.dart`
- `core/theme/app_spacing.dart`
- `core/theme/app_radius.dart`
- `core/theme/app_theme.dart` (combines all of the above into Flutter's `ThemeData`)

---

## 3. Brand Continuity with Factline

FactShot is a sub-brand of Factline, not a disconnected product. The visual system should share DNA with Factline's existing brand (dark navy/near-black backgrounds, confident geometric sans-serif type, a single vivid accent color used sparingly) while having its own distinct identity as the fast-reading product. See the logo exploration work already done separately for the specific mark; this document governs the app's overall UI system, which should feel like a natural extension of that same brand language — not a different product wearing Factline's name.

---

## 4. Color System

**Structure (exact hex values to be finalized against final logo/brand decision — placeholders shown reflect the direction already established in brand work to date):**

| Token | Purpose | Example value |
|---|---|---|
| `background` | Primary app background | Near-black, `#0A0A0B` |
| `surface` | Card/elevated surface base color (before glass effect applied) | Slightly lighter than background, `#141416` |
| `surfaceGlass` | The translucent glass-effect overlay color/opacity used on cards, nav bars, modals | Semi-transparent white/gray over blur |
| `accentPrimary` | The single confident brand accent — used for active states, category tags, primary buttons, links | Electric cyan-blue, matching Factline's existing accent (`#29C5F6` range) — confirm exact value against final logo |
| `textPrimary` | Primary text on dark backgrounds | Off-white, `#F5F5F7` |
| `textSecondary` | Meta text (timestamps, source names, captions) | Muted gray, `#8A8A90` |
| `success` / `error` / `warning` | Functional/system states (e.g. "saved" confirmation, error banners) | Standard semantic colors, kept separate from the brand accent so they're not confused with brand actions |

**Usage discipline:** `accentPrimary` is used sparingly and deliberately — active nav tab, category tag pills, primary CTA buttons, selection states. It should never become the dominant color of a screen; its impact comes from restraint. Everything else stays neutral (background/surface/text tones).

**Dark mode is the default and primary experience**, matching the brand direction already established. A light mode / "tint toggle" (see `01-PROJECT_REQUIREMENTS.md` Should-Have features) can be layered in later without restructuring the color system, provided colors are properly centralized per Section 2.

---

## 5. Typography

**Font choice:** A confident, geometric sans-serif for headlines (something in the character of Apple's SF Pro or a comparable geometric sans available via `google_fonts` — e.g. **Manrope** or **Inter** are strong, free, modern options that read as premium without licensing cost). Body text uses the same family or a highly compatible pairing, kept simple — one font family for the whole app is the safer default, differentiated by weight, not by mixing multiple typefaces.

**Type scale (defined once in `app_typography.dart`, referenced everywhere):**

| Style | Use | Approx size / weight |
|---|---|---|
| `displayLarge` | Splash screen wordmark, major headers | 32–36px, bold (700) |
| `headlineLarge` | Article headlines in detail view | 24–28px, bold (700) |
| `headlineMedium` | Card headlines in feed | 18–20px, semi-bold (600) |
| `titleMedium` | Section titles ("Explore Categories", "Saved") | 16–18px, semi-bold (600) |
| `bodyLarge` | Article summary text, body copy | 15–16px, regular (400) |
| `bodyMedium` | Standard UI body text | 14px, regular (400) |
| `caption` | Timestamps, source names, meta info | 12–13px, medium (500), `textSecondary` color |
| `label` | Button text, tags, chips | 13–14px, semi-bold (600), often uppercase-tracking for tags |

**Line height/spacing:** Generous line-height on body text (1.4–1.5x) for comfortable reading — this is a reading-heavy app, legibility takes priority over visual tightness.

---

## 6. Spacing Scale

A single consistent scale, defined once in `app_spacing.dart`, used for all padding/margin/gaps:

```
xs = 4
sm = 8
md = 12
lg = 16
xl = 24
xxl = 32
```

No arbitrary spacing values (e.g. `padding: 13` or `padding: 22`) should appear anywhere in the codebase — always compose from this scale.

---

## 7. Corner Radius Scale

Defined once in `app_radius.dart`:

```
sm = 8      // small elements: chips, tags
md = 16     // standard cards, buttons
lg = 20     // large cards, modals
xl = 28     // hero elements, bottom sheets
full = 999  // fully rounded (pills, circular avatars)
```

Rounded, continuous-curve geometry throughout — no sharp corners — matching the premium, Apple-adjacent direction established in earlier design exploration.

---

## 8. The "Glass" Surface System

Per earlier design direction (Liquid Glass-inspired), cards, navigation, and modals use a translucent, blurred "floating" surface rather than flat opaque colors:

- Built once as a shared `GlassSurface` widget (`core/widgets/glass_surface/`), using `BackdropFilter` + blur + subtle border highlight + soft shadow
- Every card, the bottom nav bar, and modals/bottom-sheets are built from this one shared widget — never a one-off reimplementation per screen (see `04-RULES.md` Section 3, "prefer composition over duplication")
- **Legibility takes priority over the glass effect.** If text over a glass surface is hard to read, that's a bug, not an acceptable tradeoff for aesthetics — this is a known real-world issue with heavily transparent UI and must be checked deliberately, not assumed to be fine.

---

## 9. Motion & Animation Principles

- Every interactive element (button tap, toggle, card swipe, nav switch) has deliberate, smooth motion — nothing should feel like an instant, abrupt state change
- Page transitions use one consistent transition style/timing across the whole app (defined centrally, not per-screen — see `02-ARCHITECTURE.md` router setup)
- Loading states use the shared `ShimmerSkeleton` widget instead of a blank screen or generic spinner wherever content is loading
- Motion should feel fast and premium, never sluggish — err toward shorter durations (150–300ms range for most transitions) rather than slow, showy animations that slow down actual usage

---

## 10. Platform Adaptivity Notes

- Use Flutter's platform-aware capabilities (e.g. `Theme.of(context).platform` checks, or platform-adaptive widgets) sparingly, only where a genuine native-feel difference matters (e.g. back-navigation gesture conventions)
- Do not literally clone iOS-only visual conventions (like the Liquid Glass system) onto Android without adapting them — the *brand* (color, type, spacing, glass-card language) stays consistent across both platforms, but respect that Android has its own users' expectations around navigation and motion
- This is a deliberate premium styling choice, not an attempt to make the Android app "look like iOS" — worth being able to explain this if asked, since the app is Android-first for V1 per `01-PROJECT_REQUIREMENTS.md`

---

## 11. Related Documents

- `02-ARCHITECTURE.md` Section 4 — where these theme files physically live in the codebase
- `04-RULES.md` Section 3 — the "no hardcoded values" rule this document exists to support
