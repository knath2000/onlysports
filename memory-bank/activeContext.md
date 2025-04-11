# Active Context: Dynamic Sports Match Tracker

**Version:** 1.0 (Initial)
**Date:** 2025-04-11 (Updated after UI Alignment)

## 1. Current Focus
*   Completed UI alignment refactoring (centered AppBar title and list item text).
*   Pushed latest changes to GitHub.
*   Reviewing next steps post-Phase 1.

## 2. Recent Changes (End of Phase 1)
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

## 3. Next Steps (Post Phase 1)
*   Refine UI/UX according to design principles (Step 5 details).
*   Implement complex animations using Rive (Step 3 research).
*   Implement robust filtering for match lists.
*   ~~Create `memory-bank/progress.md`.~~ (Done)
*   Improve error handling and loading states.
*   Conduct performance profiling and optimization (Step 12 details).
*   Address TODOs in the code (API key security, layout refinement, etc.).
*   Consider features from "Future Considerations" in `projectbrief.md`.

## 4. Open Questions / Decisions (Post Phase 1)
*   Finalize specific color palettes and typography.
*   Design specific custom UI components and animations.
*   ~~Which Architectural Pattern will be adopted?~~ (Decided: Clean Architecture inspired)
*   ~~Which specific Animation Libraries (Rive/Lottie) are best suited?~~ (Decided: Rive)
*   How to handle potential data migration if Hive schema changes?
*   Strategy for more robust match list caching (currently only detail caching reads from Hive first).

*(This file will be updated frequently to reflect the current state of development, decisions made, and immediate next actions.)*