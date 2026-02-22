# Design & Implementation Plan for **fashion_flow**

## Overview
The goal is to revive the **fashion_flow** Flutter project, turning it into a functional, cross‑platform fashion e‑commerce app while keeping costs at zero (free tiers only). The plan follows a clean‑architecture approach, uses **Supabase** for backend services, **Riverpod** for state management, and adds modern UI/UX touches.

---

## Tech Stack (see `TECH_STACK.md`)
- **Framework:** Flutter (Dart) – supports Android, iOS, Web, macOS, Windows, Linux.
- **Backend:** Supabase (Auth, PostgreSQL DB, Realtime).
- **State Management:** Riverpod.
- **Architecture:** Clean Architecture (Presentation → Domain → Data).
- **UI Libraries:** Material + `flutter_animate` for animations; custom components inspired by shadcn‑ui style.
- **CI/CD:** GitHub Actions (free) – run tests and build a web artefact deployed to GitHub Pages.

---

## Roadmap (see `ROADMAP.md`)
The work is split into six stages. After each stage you will run the web UI, confirm the feature works, and give approval before moving on.
1. **Stage 1 – The Keel (Setup)** – project scaffold, theming, CI workflow.
2. **Stage 2 – The Crew (Auth)** – full login/signup with Supabase, session persistence.
3. **Stage 3 – The Cargo (Products)** – product list, search, detail page, animations.
4. **Stage 4 – The Treasure Chest (Cart/Checkout)** – cart state, mock checkout flow.
5. **Stage 5 – The Wheel (Profile/Orders)** – profile screen, order history.
6. **Stage 6 – Polish & Deploy** – GitHub Pages deployment, final testing.

---

## UI / Design Ideas (see `UI_DESIGN.md`)
- Shadcn‑style cards with subtle shadows and hover elevation (web).
- Hero animations between product grid and detail view.
- `flutter_animate` for fade‑in grid, slide‑up cart drawer.
- Light/Dark theme toggle stored per user.
- Responsive layout: 2‑column grid on desktop, single column on mobile.
- Micro‑interactions: button ripple, loading skeletons.

---

## Parallel Worker Agents (see `AGENTS.md`)
To speed development we will spawn sub‑agents that work independently:
- **UI‑Builder** – writes/updates Flutter widgets, runs `flutter format`.
- **Backend‑Seeder** – creates Supabase tables (`products`, `cart_items`, `orders`) and seed data.
- **CI‑Wizard** – crafts the GitHub Actions workflow.
- **Tester** – writes unit and widget tests, runs `flutter test`.
Each agent will report back when its piece is ready, and you will approve the feature before it is merged.

---

## How to Review
All documentation lives in the repository under the root of `fashion_flow`. Open any `.md` file in the web UI or your IDE. If a file becomes large, I will split it further and let you know where to look.

---

*Ready to commit these files and push to GitHub.*
