# Technical Context: Dynamic Sports Match Tracker

**Version:** 1.0 (Initial)
**Date:** 2025-04-11

## 1. Core Technology
*   **Framework:** Flutter
*   **Language:** Dart

## 2. Target Platforms & Build Environments
*   **Web:** Flutter Web (Targeting modern browsers, using **HTML renderer** for smaller initial payload size - set in `web/index.html`)
*   **macOS:** Flutter Desktop (Targeting recent macOS versions)
*   **iOS:** Flutter Mobile (Targeting recent iOS versions)
*   **Build Tools:** Flutter SDK, Xcode (for iOS/macOS), Android Studio/SDK (if Android support added later)

## 3. Key Dependencies (Selected)
*   `flutter_sdk`: Core Flutter framework
*   `cupertino_icons`: Default iOS-style icons
*   `flutter_riverpod`: State Management
*   `json_annotation`: JSON helper
*   `dio`: HTTP Client
*   `intl`: Date formatting
*   `hive`: Local Persistence (Key-Value & Object Storage)
*   `hive_flutter`: Flutter helpers for Hive
*   `path_provider`: Finding file system paths for Hive

## 4. Dependencies to be Determined/Researched
*   **State Management:** (See `systemPatterns.md` - Step 4)
*   **HTTP Client:** (e.g., `http`, `dio` - for API communication - Step 2/6)
*   **Animation Library:** (e.g., `rive`, `lottie` - Step 3/6)
*   **Data Persistence:** Hive (Selected for favorites & match caching)
*   **Real-time Communication:** football-data.org (free tier) likely does NOT support WebSockets/SSE. Real-time updates would require frequent polling of REST endpoints (respecting rate limits: 10/min). (Step 11)
*   **JSON Serialization:** (e.g., `json_serializable` - Step 7)

## 5. Data Source
*   **Type:** External Sports API (Soccer focus for Phase 1)
*   **API Candidates (from initial research):**
    *   football-data.org (Free tier for top competitions)
    *   API-Football (api-football.com) (Comprehensive, 1100+ competitions)
    *   Sportmonks (sportmonks.com) (Comprehensive, 2500+ leagues, reliable)
    *   SoccersAPI (soccersapi.com) (JSON API + Widgets)
    *   Soccerdata API (soccerdataapi.com) (Live scores, stats, AI previews)
    *   All Sports API (allsportsapi.com) (JSON API, claims speed)
*   **Selected API:** football-data.org (Using free tier for Phase 1)
*   **API Key Management:** (To be determined - likely via environment variables or secure configuration)

## 6. Performance Considerations
*   See `projectbrief.md` for specific goals (Lighthouse, FPS).
*   Emphasis on minimizing widget rebuilds, efficient data handling, platform optimization.

## 7. Development Setup Notes
*   (Add any specific setup instructions, environment variables, or tooling notes here as they arise)


## 8. Deployment (Vercel - Web)
*   **Framework Preset:** Other (Set in Vercel UI)
*   **Build Command:** `sh build.sh` (Set in Vercel UI)
*   **Output Directory:** `public` (Set in Vercel UI - Note: `build.sh` copies `build/web` contents to `public`)
*   **Install Command:** Default/Empty
*   **`build.sh`:** Clones Flutter SDK (stable), adds to PATH, runs `flutter build web --release`, copies `build/web` contents to `public/`.
*   **`vercel.json`:** Contains rewrite rule `{"source": "/(.*)", "destination": "/index.html"}` for Flutter routing.
*   **Vercel Serverless Function:** Used as proxy (`api/footballDataProxy.ts`) to handle API calls and CORS for the web build. API Key (`FOOTBALL_DATA_TOKEN`) is loaded via Vercel Environment Variables (`process.env.FOOTBALL_DATA_TOKEN`).

*(This file tracks the specific technologies, libraries, APIs, and technical constraints of the project. It will be updated as dependencies are added and technical decisions are made, particularly in Steps 2, 3, 4, 6, 10, 11).*