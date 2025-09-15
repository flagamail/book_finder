# App Theme — Book Finder

## Purpose

This document defines the visual system for *Book Finder*: an elegant, readable, and accessible theme tailored for a calm, bookish mobile experience. It provides design tokens (colors, typography, spacing, motion), usage guidance, accessibility notes, and quick examples for consistent implementation across the app.

Design goals

* Elegant & modern: refined type and restrained color palette.
* High legibility for long-form and list content.
* Calm, bookish character: warm neutrals and subtle texture cues.
* Accessible: meet WCAG AA for primary text; list exceptions documented.

---

## Brand attributes (tone)

* **Calm** — soft contrasts, minimal visual noise.
* **Refined** — restrained palette, serif/neutral type pairing for personality.
* **Reliable** — consistent spacing, clear hierarchy, predictable motion.

---

## Color palette (tokens)

Primary tokens (used in `ColorScheme` and as tokens in `design-tokens.json`):

* `primary` — #4A4E69 — Usage: primary actions, AppBar icons, FAB background.
* `primaryContainer` — #E6E3F2 — Usage: subtle container backgrounds for cards or selected chips in light mode.
* `onPrimary` — #FFFFFF — Usage: text/icons on primary backgrounds.
* `secondary` — #9A8C98 — Usage: secondary actions, subtle accents, metadata (author names).
* `background` — #F7F5F2 — Usage: app scaffold background (light mode).
* `surface` — #FFFFFF — Usage: cards, list tiles, sheets.
* `onSurface` — #1F1D2B — Usage: primary body text on `surface`/`background`.
* `muted` — #6E6B76 — Usage: secondary text, hints, placeholders.
* `accent` — #C08497 — Usage: small highlights (favorite icon, subtle badges).
* `danger` / `error` — #B00020 — Usage: destructive actions and error states.

### Dark mode counterparts

* `primary` — #BFC4FF
* `primaryContainer` — #303047
* `onPrimary` — #0F1724
* `background` — #0F1114
* `surface` — #111318
* `onSurface` — #E6E7EB
* `muted` — #9DA0A6
* `accent` — #E8A0B6
* `error` — #FF6B6B

**Usage rules**

* Prefer `surface` for elevated UI elements (cards, tiles).
* Reserve `background` for broad canvas.
* Use `primary` for high-value CTAs.
* Use `accent` sparingly; not for main CTAs.
* Always pair colored backgrounds with the appropriate `on*` token for legibility.

---

## Typography tokens

Pair a refined serif for book titles with a neutral sans for UI: e.g., *Merriweather* (titles) + *Inter* (UI/body). Provide web-safe fallbacks (Georgia, system sans).

Scale (mobile-focused):

* `display` — 28sp / 700 / line-height 1.2 — use for major headers on details.
* `headline` — 20sp / 600 / line-height 1.25 — detail screen headings.
* `title` — 16sp / 600 / line-height 1.3 — list item title.
* `body` — 14sp / 400 / line-height 1.4 — paragraph and metadata.
* `label` — 12sp / 500 / line-height 1.2 — buttons, chips.
* `caption` — 11sp / 400 / line-height 1.2 — minor metadata.

**Usage**

* Book titles (list): `title` with serif fallback weight tuned for legibility.
* Author and metadata: `body`/`label` in muted color.
* App chrome and small UI text: use sans `body`/`label` for clarity.

---

## Spacing & layout

Adopt an 8-point base scale: 4, 8, 12, 16, 24, 32, 40.

Guidelines:

* Screen padding: 16 (top/bottom), 16 (left/right) on mobile.
* List vertical gap: 12 between items.
* Card internal padding: 16.
* Thumb / icon padding: 12.
* Large gutters for comfortable reading: increase horizontal padding to 24 on wide phones/tablets.

---

## Elevation & shadows

Keep shadows subtle and layered.

Token examples:

* `elevation-0` — none (flat).
* `elevation-1` — Card: offset(0,2), blur 6, color black @ 6% opacity.
* `elevation-2` — Raised sheet: offset(0,4), blur 12, color black @ 8% opacity.

Use elevation sparingly — prefer contrast via `surface` and `primaryContainer` rather than heavy shadows.

---

## Radii & shapes

* Small radius (chips / buttons): 8px.
* Card radius (list tiles / cards): 12px.
* Large radius (dialogs / featured panels): 20px.

---

## Iconography

* Use a single icon family for coherence (Material icons acceptable).
* Icon sizes: 24 (default), 20 (dense), 28–32 (hero / app bar actions).
* Line icons for neutral UI; filled icons for strong actions (favorite / saved).

---

## Images & thumbnails

* Thumbnails: use 64×96 (3:2 portrait) for list tiles; scale with device pixel ratio.
* Details hero: 250–320 width with responsive scaling.
* Use `covers.openlibrary.org` images when available; fall back to a neutral placeholder tile using `muted` background and a subtle book icon.
* Provide `alt`/semantics label for images: `Book cover for <title> by <author>`.

---

## Motion & animation

Define three durations and easing presets:

* `short` — 120ms — quick feedback (button ripple, compact fades).
* `medium` — 240ms — primary UI transitions (list fades, page transitions).
* `long` — 420ms — emphasis transitions (details cover entry).

Easing:

* `standard` — Curves.easeOutCubic for page/content transitions.
* `gentle` — Curves.easeInOut for looping or subtle rotations.

Book cover animation (recommended):

* Entry: subtle Y-axis rotation of ±4° using `long` duration with `gentle` easing OR a micro-tilt sequence (100ms tilt in, 320ms settle).
* Continuous (optional): slow loop ±2° with period ≈ 6–8s at extremely low amplitude — avoid motion sickness. Provide an accessibility toggle to disable continuous motion.

---

## Theme extensions & tokens

Create a `ThemeExtension` for non-standard tokens. Example extension tokens to include:

* `AppShimmerStyle` — baseColor / highlightColor / period.
* `CardStyle` — borderRadius / elevationToken / paddingToken.

Store and use these via `Theme.of(context).extension<AppShimmerStyle>()` so tokens remain accessible in widgets.

---

## Accessibility & contrast

* Primary body text (`onSurface` on `surface`) must meet contrast **≥ 4.5:1**.
* Large display text (≥ 18.66pt at 700 weight or 24px) must meet **≥ 3:1**.
* Muted text may fall below 4.5:1 but should not go below 3:1 for readability.

**Action items**

* Run contrast checks for every `on*` pairing in `design-tokens.json`.
* Provide accessible motion toggle in Settings and respect `MediaQuery.disableAnimations`.

---

## Example usage snippets (conceptual)

* **List tile**: `Card(surface)` with radius 12, padding 16; left thumbnail (64×96), title `title` (serif), subtitle `body` (muted).
* **Details header**: large cover image with `display` title underneath, subtle rotation on entry, save button using `primary`.

