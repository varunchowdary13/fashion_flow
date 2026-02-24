# Fashion Flow 🛍️

A modern, cross-platform fashion e-commerce app built with Flutter, featuring clean architecture, dark mode support, and seamless Supabase integration.

## ✨ Features

- **Cross-platform**: Web, iOS, Android, Windows, macOS, Linux
- **Light/Dark Theme**: Automatic system detection + manual toggle
- **Clean Architecture**: Separation of Presentation, Domain, and Data layers
- **Secure Authentication**: Supabase Auth with session persistence
- **Product Catalog**: Browse fashion items with animated UI
- **Shopping Cart**: Add, remove, and checkout items
- **Type-safe Navigation**: go_router with route guards

## 🛠️ Tech Stack

| Category         | Technology                  |
| ---------------- | --------------------------- |
| Framework        | Flutter 3.9+                |
| State Management | Riverpod 3.x                |
| Backend          | Supabase (Auth, PostgreSQL) |
| Routing          | go_router                   |
| Error Handling   | fpdart (Either type)        |
| Fonts            | Google Fonts (Lato)         |

## 📁 Project Structure

```
lib/
├── main.dart                 # App entry point
├── core/
│   ├── providers.dart        # Core Riverpod providers
│   ├── router.dart           # go_router configuration
│   ├── error/                # Failures & Exceptions
│   ├── theme/                # AppTheme, ThemeModeNotifier
│   ├── utils/                # Validators
│   └── widgets/              # Shared widgets (Loading, Error)
└── features/
    ├── auth/                 # Login, Signup, AuthRepository
    ├── cart/                 # Cart screen & controller
    └── products/             # Home, ProductCard, Repository
```

## 🚀 Getting Started

### Prerequisites

- Flutter SDK ^3.9.2
- Dart SDK ^3.9.2
- A Supabase project (for backend)

### Installation

1. Clone the repository:

   ```bash
   git clone https://github.com/your-username/fashion_flow.git
   cd fashion_flow
   ```

2. Install dependencies:

   ```bash
   flutter pub get
   ```

3. Configure Supabase credentials:
   - Update `lib/main.dart` with your Supabase URL and anon key
   - Or set environment variables (recommended for production)

4. Run the app:
   ```bash
   flutter run -d chrome    # Web
   flutter run              # Default device
   ```

## 🧪 Running Tests

```bash
flutter test
```

## 📱 Screenshots

_Coming soon_

## 🎨 Color Palette

| Color       | Hex       | Usage              |
| ----------- | --------- | ------------------ |
| Deep Teal   | `#006D77` | Primary            |
| Soft Peach  | `#FFDDD2` | Secondary/Tertiary |
| Burnt Coral | `#E29578` | Accent             |
| Ice Blue    | `#EDF6F9` | Light background   |

## 🗺️ Roadmap

- [x] Setup & Theming (Stage 1)
- [ ] Authentication (Stage 2)
- [ ] Products Catalog (Stage 3)
- [ ] Cart & Checkout (Stage 4)
- [ ] Profile & Orders (Stage 5)
- [ ] Polish & Deploy (Stage 6)

## 📄 License

This project is licensed under the MIT License.

## 🤝 Contributing

Contributions are welcome! Please read the contributing guidelines first.
