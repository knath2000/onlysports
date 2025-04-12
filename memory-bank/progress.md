# Progress Tracker: Dynamic Sports Match Tracker

**Version:** 1.0 (Initial)
**Date:** 2025-04-12 (Updated after web optimization)

## 1. Current Status (Post-Phase 1 Refinements & Optimization)
*   Initial implementation of gradient background theme complete.
*   Match details now shown in a modal popup with background blur.
*   Skeleton loading screens (`skeletonizer`) implemented for main loading states.
*   Local dev environment (`vercel dev`) issues resolved (requires `.env` file).
*   Application builds and runs on Web, macOS, iOS with basic functionality.
*   Initial web load optimization investigation completed.
*   Web initial load perception improved (dark background instead of white flash).
*   Deferred loading applied to modal/selection screen (minimal size impact).
*   Dependencies cleaned (`shared_preferences` removed).
*   Web renderer investigation completed (HTML vs Wasm size comparison, build flag limitations identified).

## 2. What Works
*   Displaying Upcoming/Previous Matches via Tabs (with gradient background).
*   Fetching data from football-data.org via Vercel Proxy (`vercel dev` locally requires `.env`).
*   Displaying match details in a modal popup with background blur.
*   Adding/Removing favorite teams using Hive persistence (via star button).
*   Drag-and-drop favoriting (MatchListItem -> Drop Target on MatchListScreen).
*   Filtering match list by favorites (using toggle button).
*   Basic caching of fetched match details and lists using Hive.
*   Cross-platform builds (Web, macOS, iOS).
*   Mandatory initial league selection screen (with visual selector).
*   Ability to change league selection from main screen (via edit button).
*   Skeleton loading states using `skeletonizer` for lists and modal.
*   Displaying Team Crests & League Emblems (via Vercel proxy for CORS).
*   Centered Match List with constrained width.
*   Dark background shown immediately on web load (improved perception).

## 3. What's Next (High Level)
*   UI/UX Polish (Refine gradient theme, custom components, glossy effects?).
*   Implement complex animations using Rive.
*   Implement robust filtering for match lists.
*   Improve error handling.
*   Conduct runtime performance profiling and optimization.
*   Code Refinement (Address TODOs).
*   Update core Memory Bank docs (`projectbrief.md`, `productContext.md`) to match current gradient theme direction.

## 4. Known Issues / Blockers
*   Polling for live updates is basic and subject to rate limits/API update frequency.
*   UI lacks final polish (custom components, glossy effects, refined animations).
*   Filtering logic is basic (only home/away team ID via toggle).
*   Drag-and-drop target area is the whole list view, could be refined.
*   Skeleton loading appearance might need tweaking.
*   Web initial JS payload (HTML renderer) is ~2.4MB; further reduction requires advanced techniques or deferring larger features.
*   Cannot explicitly force web renderer (HTML/CanvasKit) via build flags in Flutter 3.29.2.

## 5. Key Milestones Reached (Phase 1 & Initial Optimizations)
*   Project Plan Finalized (2025-04-11)
*   Memory Bank Initialized (2025-04-11)
*   Phase 1 Core Functionality Implemented (Basic) (2025-04-11)
*   Cross-Platform Builds Successful (2025-04-11)
*   Web App Deployed & Working via Vercel (using Serverless Function Proxy) (2025-04-11)
*   Integrated Hive for Favorites & Match Caching (2025-04-11)
*   Implemented Mandatory League Selection & Change Flow (2025-04-11)
*   Fixed Previous Match Score Display Logic (Corrected JSON keys) (2025-04-11)
*   Refactored UI Alignment (Centered AppBar Title & List Item Text) (2025-04-11)
*   Implemented Gradient Background Theme (2025-04-11)
*   Implemented Modal Match Details w/ Blur (2025-04-11)
*   Implemented Drag-and-Drop Favoriting (Basic) (2025-04-11)
*   Implemented Skeleton Loading (`skeletonizer`) (2025-04-11)
*   Fixed `vercel dev` Build Script (2025-04-11)
*   Pushed Gradient/Modal/Skeleton Changes to GitHub (2025-04-11)
*   Improved Web Load Perception (Dark Splash) (2025-04-12)
*   Implemented Deferred Loading (Modal/Selection) (2025-04-12)
*   Cleaned Dependencies (Removed shared_preferences) (2025-04-12)
*   Fixed Local Dev API Auth (Added .env requirement) (2025-04-12)
*   Investigated Web Renderers (HTML vs Wasm size, build flags) (2025-04-12)
*   Pushed Optimization Changes to GitHub (2025-04-12)

## 6. Performance Notes (Initial - Post Lighthouse)
*   Release builds completed successfully for all platforms.
*   Initial Lighthouse (CanvasKit renderer) showed poor performance (Score ~86, ~59MB payload).
*   Switched web renderer to **HTML** in `web/index.html`.
*   Re-run Lighthouse (HTML renderer) showed **significant improvement**:
    *   Payload reduced to ~2.2MB.
    *   Speed Index improved from ~126s to ~1.5s.
    *   JS Execution Time reduced from ~5.1s to ~1.7s.
    *   Accessibility score improved to 92.
    *   SEO score improved to 100.
    *   LCP/TBT errors persist, likely due to HTML renderer measurement difficulties - monitor as app complexity increases.
*   No major performance issues noted during basic functional testing on native platforms.
*   Detailed profiling (DevTools, Lighthouse) still required as per Step 12 / Post Phase 1.

## 7. Performance Notes (Web Optimization - 2025-04-12)
*   **HTML Renderer Build:** `main.dart.js` size is ~2.4MB after recent changes.
*   **Wasm Renderer Build:** Core artifacts (`.wasm` + `.mjs`) total ~2.03MB (~15% smaller than HTML JS). Trade-off is potentially slower Wasm parsing vs faster runtime.
*   **Deferred Loading:** Applying to `MatchDetailModal` and `SelectionScreen` had negligible impact on the 2.4MB bundle size.
*   **Renderer Selection:** Cannot explicitly force HTML/CanvasKit via `flutter build web` flags in Flutter 3.29.2. Build uses default logic. Release build likely uses HTML renderer based on previous findings.
*   **Initial Load Perception:** Adding dark background to `index.html` successfully mitigates the blank white screen flash.

*(This file provides a high-level overview of the project's progress...)*