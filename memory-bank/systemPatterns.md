# System Patterns: Dynamic Sports Match Tracker

**Version:** 1.0 (Initial)
**Date:** 2025-04-11

## 1. Architecture
*   **Chosen Pattern:** Clean Architecture (or a layered variant inspired by it)
*   **Candidates:** Clean Architecture, MVVM, MVC
*   **Rationale for Choice:** Selected for its strong separation of concerns (Presentation, Domain/Application, Data/Infrastructure), which enhances testability, maintainability, and scalability. Aligns well with the project's goals for high quality, performance focus, and future expansion. Provides clear boundaries for development.
*   **Diagrams/Flows:** (To be added as architecture solidifies)

## 2. State Management
*   **Chosen Solution:** Riverpod
*   **Candidates:** Riverpod, Bloc, Provider, GetX
*   **Rationale for Choice:** Chosen for its performance, compile-time safety, flexibility, scalability, and automatic provider disposal. Well-suited for handling asynchronous operations (API calls, real-time data) and managing potentially complex UI state related to animations with relatively less boilerplate compared to Bloc.

## 3. Data Flow
*   **General Flow:** UI -> Riverpod Provider -> Repository (Interface) -> Repository Implementation (Infrastructure) -> Data Source (API/Hive)
*   **Match Data:**
    *   UI watches `matchDetailsProvider` (StreamProvider).
    *   Provider calls `MatchRepository.getMatchDetails()`.
    *   `ApiMatchRepository` implementation:
        *   Emits cached match from Hive `matchesBox` (if available).
        *   Fetches latest match details from API (via proxy).
        *   Saves fetched match to Hive `matchesBox`.
        *   Emits fetched match to the stream.
*   **Favorites Data:**
    *   UI watches `favoritesStreamProvider` for the list and `isFavoriteProvider` for individual status.
    *   UI calls actions on `FavoritesNotifier`.
    *   Notifier calls `FavoritesRepository` methods (`addFavorite`, `removeFavorite`).
    *   `HiveFavoritesRepository` implementation interacts with Hive `favoritesBox`.
    *   `watchFavorites` in repository emits updates from the box, powering `favoritesStreamProvider`.
*   **Initial Routing:**
    *   App starts with `InitialRouteDispatcher`.
    *   Dispatcher watches `userSelectionProvider` (backed by Hive).
    *   If selection exists, navigates to `MatchListScreen`.
    *   If no selection, navigates to `SelectionScreen`.
*   **User Selection Flow:**
    *   `SelectionScreen` fetches leagues via `availableLeaguesProvider`.
    *   User selects league, state managed locally in `SelectionScreen`.
    *   On save, `SelectionRepository.saveSelection()` is called (persists to Hive).
    *   `userSelectionProvider` is invalidated.
    *   Navigate to `MatchListScreen` (replacing `SelectionScreen`).
*   **Changing Selection:**
    *   `MatchListScreen` has an edit button.
    *   Button uses `Navigator.push()` to show `SelectionScreen`.
    *   Saving follows the normal selection flow.
    *   Using the back button from `SelectionScreen` discards changes.

## 4. Key Design Patterns (Anticipated)
*   Repository Pattern (for data abstraction)
*   Dependency Injection (likely provided by state management solution or dedicated package)
*   Observer Pattern (inherent in reactive state management)
*   Builder Pattern (for complex object creation, e.g., theme data)

*(This file will document the high-level architectural decisions, state management approach, and recurring design patterns used throughout the application. It will be populated primarily during Step 4).*