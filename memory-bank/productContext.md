# Product Context: Dynamic Sports Match Tracker

**Version:** 1.0 (Initial)
**Date:** 2025-04-11

## 1. Problem Space
*   Existing sports tracking apps often lack visual polish, feel utilitarian, or suffer from performance issues.
*   There's an opportunity for an app that combines rich data presentation with a highly engaging, game-inspired, and performant user experience.

## 2. Target Audience
*   Soccer fans who appreciate modern design and fluid interfaces.
*   Users across Web, macOS, and iOS platforms.
*   Individuals looking for a quick way to track upcoming/previous matches and potentially live scores.

## 3. Core User Journeys (Phase 1)
*   **Viewing Upcoming Matches:** User opens app -> Navigates to 'Upcoming' list -> Scrolls/Filters by date/league/team -> Sees relevant matches.
*   **Viewing Previous Results:** User opens app -> Navigates to 'Previous' list -> Scrolls/Filters -> Sees match results.
*   **Viewing Match Details:** User taps on a match in a list -> Navigates to detail screen -> Sees date, time, teams, league, venue, score, key events.
*   **Managing Favorites:** User finds a team/league -> Taps 'favorite' icon -> Icon state changes -> User navigates to filter -> Selects 'Favorites' -> Sees matches relevant to favorites.

## 4. Design Principles & Feel
*   **Aesthetic:** Apple.com-inspired dark theme (sophisticated, clean, high contrast) dramatically contrasted by vibrant, energetic animations.
*   **Interaction:** Fluid, game-like, responsive, delightful micro-interactions. Avoid standard/boring transitions and feedback.
*   **Performance:** Must feel exceptionally fast and smooth on all platforms. Performance is a core feature.
*   **Clarity:** Despite complex animations, information must remain clear and easy to parse.

### 4.1 Design Inspiration Resources (Dark Theme)
*   **Apple Guidelines:**
    *   [HIG - Dark Mode](https://developer.apple.com/design/human-interface-guidelines/dark-mode)
    *   [Supporting Dark Mode](https://developer.apple.com/documentation/uikit/supporting-dark-mode-in-your-interface)
*   **Examples & Collections:**
    *   [Muzli](https://muz.li/inspiration/dark-mode/)
    *   [Dribbble](https://dribbble.com/tags/dark-theme-ui)
    *   [Super Dev Resources](https://superdevresources.com/dark-ui-inspiration/)
    *   [Mockplus](https://www.mockplus.com/blog/post/dark-mode-ui-design)
    *   [Easeout](https://www.easeout.co/blog/2020-05-13-25-dark-mode-ui-design-examples/)
*   **Guides/Articles:**
    *   [AppInventiv](https://appinventiv.com/blog/guide-on-designing-dark-mode-for-mobile-app/)
    *   [Prototypr](https://blog.prototypr.io/designing-a-dark-mode-for-your-ios-app-the-ultimate-guide-6b043303b941)
    *   [AgenteStudio](https://agentestudio.com/blog/how-to-design-dark-themes-for-ios-apps)


### 4.2 Animation Library Research (Rive vs. Lottie)
*   **Goal:** Achieve complex, performant, interactive, game-like animations.
*   **Findings:**
    *   **Rive:** Stronger for interactive animations, complex state logic, potentially better performance with multiple simultaneous animations, smaller file sizes, runtime control.
    *   **Lottie:** Excels at playing back pre-rendered complex vector animations (e.g., from After Effects).
*   **Recommendation (Preliminary):** Rive appears more suitable due to the emphasis on interactivity, performance, and runtime control aligning with the project's vision.
*   **Resources:**
    *   [Rive vs Lottie Blog](https://rive.app/blog/rive-as-a-lottie-alternative)
    *   [IMAGA Medium Article](https://medium.com/@imaga/rive-animation-for-flutter-apps-why-we-prefer-it-over-lottie-when-to-use-it-and-key-features-to-c412154449bc)
    *   [Tillitsdone Blog](https://tillitsdone.com/blogs/rive-vs-lottie--flutter-animations/)
    *   [Reddit Discussion (File Size)](https://www.reddit.com/r/FlutterDev/comments/10tlqmt/impact_of_lottie_on_the_app/)


### 4.3 Color Palette (Initial)
*   **Base Theme (Dark - Apple Inspired):**
    *   Backgrounds: Very dark greys (e.g., near `#1C1C1E`, `#000000`) or deep blues.
    *   Primary Content: Off-white or light grey (high contrast).
    *   Secondary Content: Medium greys.
    *   Static Accents: Minimal, potentially one subtle brand color (TBD) or shades of grey.
*   **Animation/Interaction Accents:**
    *   Vibrant, potentially neon colors (e.g., bright blues, greens, pinks, oranges - specific palette TBD).
    *   Used exclusively for dynamic elements, highlights, feedback, and visual flair against the dark base.

### 4.4 Typography (Initial)
*   **Primary Font Family:** SF Pro (Apple's standard) is the initial suggestion for strong platform alignment, especially on iOS/macOS. Alternatives to be considered if needed for licensing or cross-platform consistency.
*   **Hierarchy:** Clear hierarchy using font weight, size, and color variations (e.g., Title, Subtitle, Body, Caption).
*   **Legibility:** High contrast and appropriate sizing are crucial on the dark background.

### 4.5 Spacing & Layout (Initial)
*   **Principle:** Generous spacing, clean lines, adhering to a consistent grid system (e.g., 8px grid).
*   **Specific Values:** (To be defined - e.g., standard padding, margins between elements).

### 4.6 Custom UI Component Concepts (Initial Ideas)
*   **Buttons:** Custom shapes/animations on interaction (e.g., pulsating background, particle effects on tap).
*   **List Items:** Unique layout, potentially incorporating subtle background textures or animated dividers.
*   **Loading Indicators:** Custom, engaging animations instead of standard spinners (e.g., animating logo, stylized sports equipment).
*   **Iconography:** Custom icon set to match the sleek, modern aesthetic.

## 5. Key Features (Why use this app?)
*   Unique visual presentation blending dark sophistication with vibrant animation.
*   Focus on exceptional performance.
*   Simple, focused feature set for Phase 1 (soccer tracking).
*   Cross-platform availability (Web, macOS, iOS).

*(This file will be updated with refined UI/UX guidelines, color palettes, typography choices, and component designs as decisions are made in Steps 3 & 5).*