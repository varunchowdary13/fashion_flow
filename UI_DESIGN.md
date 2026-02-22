# UI Design Guidelines for **fashion_flow**

## Visual Language
- **Color palette**: Soft pastel primary colors (e.g., #FF6F61, #4A90E2) with neutral backgrounds (#F5F5F5). Dark mode swaps to dark greys.
- **Typography**: Use `GoogleFonts.roboto` – clear, modern, good readability.
- **Shadows & Elevation**: Subtle elevation on cards (elevation 2) and hover lift on web (elevation 4).
- **Rounded corners**: 8‑12dp radius for cards, buttons, dialogs.

## Core Components
| Component | Description | Example |
|-----------|-------------|---------|
| **AppBar** | Centered title, optional back button, theme toggle icon on the right. | `AppBar(title: Text('Fashion Flow'), actions: [IconButton(icon: Icon(Icons.brightness_6), onPressed: toggleTheme)])` |
| **ProductCard** | Image on top, name & price below, tap → hero animation to detail. Uses `flutter_animate` for fade‑in. | See `lib/features/products/presentation/product_card.dart` (to be created). |
| **SearchBar** | TextField with clear button, debounced search (300 ms). | Placed at top of `HomeScreen`. |
| **CartDrawer** | Slide‑in from right, shows list of `CartItemTile`s, total at bottom, checkout button. | Triggered by cart icon in AppBar. |
| **LoadingSkeleton** | Grey boxes while data loads, using `shimmer` effect. | Used in product list and detail pages. |
| **Dialog** | Success dialog after mock checkout – centered, rounded, with confetti animation (`flutter_animate`). |

## Animations (via `flutter_animate`)
- **Page transitions**: Fade‑in for screens, slide‑up for drawer.
- **Hero**: Product image hero from list → detail.
- **Button feedback**: Scale‑down on press, scale‑up on release.
- **List item entry**: Staggered fade‑in when scrolling.

## Responsiveness
- **Web**: Grid with 2‑4 columns depending on width (`LayoutBuilder`).
- **Mobile**: Single column list.
- **Desktop**: Wider cards, hover effects.

## Accessibility
- Provide semantic labels for images (`Semantics` widget).
- Ensure contrast ratio > 4.5:1.
- Support larger font sizes via `MediaQuery.textScaleFactor`.

---

**Next steps**: UI‑Builder agent will create the component files based on these specs.
