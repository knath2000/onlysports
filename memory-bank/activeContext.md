# Active Context: Dynamic Sports Match Tracker

**Version:** 1.0 (Initial)
**Date:** 2025-04-12 (Updated after web optimization)

## 1. Current Focus
*   Completed initial web load optimization investigation.
*   Pushed latest changes (optimization attempts, build script revert) to GitHub.
*   Next technical step: Continue with performance optimization (runtime profiling) or UI/UX refinement for the gradient theme.

## 2. Recent Changes (End of Phase 1 & Initial Optimizations)
*   Completed all 12 steps of the initial development plan (`PLAN.md`).
*   Initialized Memory Bank.
*   Researched API, UI, Animation Libraries.
*   Decided on Riverpod & Clean Architecture.
*   Set up project structure, theme, dependencies.
*   Implemented core data models for `football-data.org`.
*   Built Match List (Tabs) & Detail Screens.
*   Implemented basic Favorites persistence & UI toggle (using `shared_preferences` initially).
*   Set up Firebase Function proxy for web CORS.
*   Implemented basic polling for live updates.
*   Verified builds and basic functionality on Web, macOS, iOS.
*   **Integrated Hive for local persistence**, replacing `shared_preferences` for favorites and adding basic caching for match data. (2025-04-11)
*   **Implemented mandatory league selection** flow using Hive persistence. (2025-04-11)
*   **Added ability to change league selection** from main screen. (2025-04-11)
*   **Fixed score display logic** for finished matches by correcting JSON keys in `ScoreTime` model. (2025-04-11)
*   **Refactored UI Alignment** (Centered AppBar Title & List Item Text). (2025-04-11)
*   **Implemented Phase 1 of Child-Focused Redesign:** New bright theme (`lightTheme`), Nunito font integration, refactored SelectionScreen/MatchListItem/MatchListScreen structure. (2025-04-11)
*   **Fixed `vercel dev` build script** issues (`/tmp/flutter` and `public` directory conflicts). (2025-04-11)
*   **Switched Theme:** Updated `MyApp` to use a new dark `gradientTheme` with pink-violet-black radial gradient background originating from bottom-right. Applied gradient wrapper to main screens. (2025-04-11)
*   **Implemented Modal Match Details:** Replaced navigation to `MatchDetailScreen` with a modal popup (`MatchDetailModal`) shown via `showGeneralDialog` with background blur. Simplified modal background to linear gradient. (2025-04-11)
*   **Implemented Skeleton Loading:** Added `skeletonizer` package and integrated skeleton loading states into `MatchListScreen`, `MatchDetailModal`, and `SelectionScreen`. (2025-04-11)
*   **Pushed changes to GitHub** (2025-04-11)
*   **Implemented Team & League Crests:** Updated data models (`TeamRef`, `CompetitionRef`), added `cached_network_image` dependency, updated UI (`MatchListItem`, `MatchDetailModal`, `LeagueSelectorCard`), and created Vercel proxy (`api/crestProxy.ts`) to handle image CORS issues. (2025-04-11)
*   **Refactored Match List Layout:** Centered the list and constrained its maximum width on `MatchListScreen`. (2025-04-11)
*   **Improved Web Load Perception:** Added dark background to `index.html` to eliminate white flash during engine load. (2025-04-12)
*   **Implemented Deferred Loading:** Applied deferred loading to `MatchDetailModal` and `SelectionScreen` (minimal impact on bundle size observed). (2025-04-12)
*   **Cleaned Dependencies:** Removed unused `shared_preferences` package. (2025-04-12)
*   **Fixed Local Dev API Calls:** Added `.env` file requirement for `FOOTBALL_DATA_TOKEN` to resolve 404 errors when running locally via `flutter run`. (2025-04-12)
*   **Investigated Web Renderers:** Confirmed HTML renderer is used for release builds; analyzed Wasm build size (~2.03MB vs ~2.4MB for HTML); confirmed `--web-renderer` flag is unavailable for `flutter build web` in Flutter 3.29.2. (2025-04-12)
*   **Pushed optimization changes to GitHub** (2025-04-12)

## 3. Next Steps (Post Phase 1)
*   Refine UI/UX according to **gradient theme** (custom components, glossy effects?).
*   Implement complex animations using Rive (Step 3 research).
*   Implement robust filtering for match lists.
*   Improve error handling (beyond basic display).
*   Conduct performance profiling (runtime) and optimization.
*   Address TODOs in the code (layout refinement, etc.).
*   Consider features from "Future Considerations" in `projectbrief.md`.
*   **Crucially:** Update `projectbrief.md` and `productContext.md` to reflect the shift away from the original dark theme / child theme towards the current gradient theme.

## 4. Open Questions / Decisions (Post Phase 1)
*   Finalize specific component designs (glossy buttons, custom tab bar, score cards) for the gradient theme.
*   Design specific Rive animations (transitions, interactions, particles).
*   How to handle potential data migration if Hive schema changes?
*   Strategy for more robust match list caching (currently only detail caching reads from Hive first).
*   Confirm final gradient colors/stops/direction.
*   Is the ~2.4MB initial JS payload (HTML renderer) acceptable, or are further advanced optimizations needed (e.g., deferring larger features)?

*(This file will be updated frequently to reflect the current state of development, decisions made, and immediate next actions.)*