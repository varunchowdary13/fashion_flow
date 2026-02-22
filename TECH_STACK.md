# Tech Stack for **fashion_flow**

| Component | Choice | Reason |
|-----------|--------|--------|
| **Framework** | **Flutter** (Dart) | Cross‑platform (mobile, web, desktop) with a single codebase. Free SDK.
| **Backend** | **Supabase** | Open‑source Firebase alternative, generous free tier, PostgreSQL DB, Auth, Realtime.
| **State Management** | **Riverpod** | Modern, testable, works well with clean‑architecture.
| **Architecture** | **Clean Architecture** | Separation of concerns (Presentation → Domain → Data) makes the app maintainable.
| **UI/Animations** | `flutter_animate`, custom shadcn‑style widgets | Gives a premium feel without extra cost.
| **CI/CD** | **GitHub Actions** | Free for public repos, can run tests and build web artefacts.
| **Testing** | `flutter_test`, `mocktail` | Unit & widget testing for reliability.
| **Deployment** | **GitHub Pages** (via `gh-pages` branch) | Free static hosting for the web build.

All chosen tools are free or have a free tier, aligning with the “cheapest possible” requirement.
