# UI/UX Redesign Plan: Child-Focused Game-Like Interface

**Date:** 2025-04-11

## 1. Goal & Scope

*   **Goal:** Complete UI/UX overhaul for a child-focused (4-8 years), game-like experience.
*   **Scope:** Replace the previous sophisticated dark theme across the entire application (theme, interactions, animations, typography, etc.).

## 2. Core Design Principles

1.  **Simplicity First:** Clear layouts, minimal clutter.
2.  **Big & Tappable:** Large buttons, icons, list items; generous spacing.
3.  **Bright & Cheerful:** Vibrant, high-contrast color palette.
4.  **Playful Feedback:** Obvious, fun visual/audio feedback for interactions (bouncy, particles).
5.  **Visual Communication:** Rely on icons, illustrations, simple animations over text. Large, clear, simple fonts.
6.  **Intuitive Navigation:** Obvious visual cues, simple patterns (tap, swipe).
7.  **Engaging & Rewarding:** Make interactions fun; consider small visual rewards.
8.  **Safety & No Frustration:** Clear states, avoid dead ends.

## 3. Visual Style Concept

*   **Style:** Soft 3D-like aesthetic.
*   **Colors:** Bright, gradient-heavy palette.
*   **Typography:** Large, simple, rounded sans-serif font.
*   **Iconography:** Glossy, rounded icons.

## 4. Animation Strategy

*   **Interaction Feedback:** Bouncy, elastic scaling effects (buttons, selections).
*   **Transitions:** Dynamic physics-based or playful wipes/reveals. List items animate in.
*   **Visual Flair:** Particle effects for successful actions (save, favorite).
*   **Loading:** Custom Rive animation (e.g., bouncing ball).
*   **Ambient:** Subtle idle animations (e.g., pulsing gradients).
*   **Technology:** Rive and Flutter's built-in animations.

## 5. Interaction Model

*   **Primary:** Tap (navigation, selection, buttons).
*   **Secondary:** Simple Swipe (vertical list scrolling).
*   **Favoriting:** Drag-and-Drop (drag item to target area).
*   **Avoid:** Complex gestures (long-press, double-tap, pinch, multi-finger).

## 6. Screen Redesign Plans

*   **`SelectionScreen`:** Custom header, visual league selector (e.g., scrolling icons), large glossy save button, apply theme/animations.
*   **`MatchListScreen`:** Custom AppBar/TabBar (glossy buttons?), custom filter toggle, custom edit button, apply theme/animations, implement drop target for favorites.
*   **`MatchDetailScreen`:** Custom header (large back button), visually engaging widgets for details (score cards, logos), apply theme/animations.
*   **`MatchListItem`:** Replace `ListTile` with custom card-like widget, incorporate logos, implement draggable logic, apply theme/animations.

## 7. New Assets Required

*   **Font:** Specific large, simple, rounded sans-serif font file (licensed).
*   **Icons:** Glossy, rounded icons (Back, Edit, Star, Filter, Statuses?).
*   **Images/Illustrations:** Formatted League/Team Logos, Background gradients/textures.
*   **Rive Files:** Loading animation, particle effects, button states.

## 8. Technology Check

*   Current stack (Flutter, Riverpod, Hive, Rive) is suitable.

## 9. Documentation Strategy

*   Update Memory Bank files (`projectbrief.md`, `productContext.md`, `activeContext.md`, `progress.md`, etc.) incrementally during implementation.

## 10. Implementation Phasing

1.  **Phase 1:** Foundational Style (Theme, Font, Colors) & Core Screens Redesign (Selection, List Item, List Screen basics).
2.  **Phase 2:** Detail Screen Redesign & Advanced Interactions (Drag-Drop, Advanced Animations).
3.  **Phase 3:** Asset Integration (Logos, Icons, Rive Loader) & Polish.