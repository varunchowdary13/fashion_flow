# Roadmap for **fashion_flow**

The development is divided into six incremental stages. After each stage you will run the web UI, verify the feature, and give approval before proceeding.

## Stage 1 – The Keel (Setup)
- Re‑organise folder structure to follow Clean Architecture.
- Add `AppTheme` with light/dark mode.
- Create GitHub Actions workflow (`flutter test` + `flutter build web`).
- Verify by running `flutter run -d chrome` – you should see the splash screen with the new theme.

## Stage 2 – The Crew (Auth)
- Implement `AuthRepository` using Supabase email/password.
- Build `LoginScreen` and `SignupScreen` with validation, loading spinners, and error handling.
- Persist session (auto‑login on app start).
- Verify by signing up a new user and logging in.

## Stage 3 – The Cargo (Products)
- Create Supabase tables: `products` (id, name, price, image_url, description).
- Seed a few sample fashion items.
- Implement `ProductRepository` (fetch list, fetch single).
- Build `HomeScreen` with an animated grid of `ProductCard`s.
- Add a search bar and filter chips.
- Add a `ProductDetailScreen` with hero animation.
- Verify by searching and opening a product.

## Stage 4 – The Treasure Chest (Cart / Checkout)
- Add `cart_items` table (or keep locally for now).
- Implement `CartController` (StateNotifier) for add/remove, quantity, total.
- Build `CartScreen` as a slide‑in drawer with stepper controls.
- Mock checkout flow – show a success dialog.
- Verify by adding items, adjusting quantities, and checking out.

## Stage 5 – The Wheel (Profile / Orders)
- `ProfileScreen` – display email, logout button.
- Supabase `orders` table; `OrderRepository` to fetch order history.
- `OrdersScreen` – list past orders with status chips.
- Verify by viewing profile and order list.

## Stage 6 – Polish & Deploy
- Deploy the web build to GitHub Pages (auto‑push to `gh-pages` branch via CI).
- Add README badge linking to the live demo.
- Final round of testing on all platforms.

---

**Approval Process**
After each stage you will run the app in a browser, confirm the behaviour, and reply with ✅ to continue.
