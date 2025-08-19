# 🌐 Halo Browser

![Halo Browser Logo](assets/images/logo.png)

**Halo** is a lightning-fast, privacy-focused, and cross-platform web browser designed for modern devices. Built with performance in mind, Halo runs natively on **desktop**, **mobile**, and even **embedded systems** using a unified codebase.

## 🚀 Features

### Core Features
- 🧊 **Minimal UI**, zero bloat
- 🔒 **Privacy-first**: no tracking, no telemetry
- ⚡️ **Blazing fast** rendering with WebView / WebKit / Blink support
- 📱 **Cross-platform**: Linux, Windows, macOS, Android, iOS
- 🌙 Dark mode by default

### Browser Features
- 🎯 **Smart Address Bar**
  - Search suggestions from bookmarks and history
  - Multiple search engine support
  - URL auto-completion
  - Clear navigation controls
  - Back/Forward navigation buttons
  - Refresh/Stop loading button
  - One-click bookmark toggle

- 📑 **Advanced Tab Management**
  - Multiple tab support with visual indicators
  - Tab previews and context menus
  - Tab persistence and reordering
  - Quick tab switching and duplication
  - Close other tabs functionality
  - Bulk tab operations (close all, close others)

- 🔖 **Bookmarks System**
  - Easy bookmark management
  - Bookmark folders and organization
  - Search functionality
  - Favicon support
  - Quick bookmark toggle from address bar

- 📚 **Browsing History**
  - Comprehensive history tracking
  - Search and filter by date ranges
  - Visit count tracking
  - Bulk history management
  - Clear old history options

- ⬇️ **Downloads Manager**
  - Download speed tracking
  - Progress monitoring
  - Pause/Resume support
  - File type detection
  - Download queue management

- ⚙️ **Settings & Customization**
  - Theme customization (light/dark mode)
  - Search engine preferences
  - Privacy settings
  - Download location configuration
  - Browser behavior options

### Advanced Features
- 🔄 **Navigation History**
  - Back/Forward navigation with visual indicators
  - Session-based navigation tracking
  - Smart URL processing and validation

- 🔍 **Smart Search & Suggestions**
  - Real-time search suggestions
  - History and bookmark integration
  - URL auto-completion
  - Search engine fallbacks

- 🎨 **Modern UI/UX**
  - Material Design 3 components
  - Responsive layout design
  - Smooth animations and transitions
  - Context-aware interface elements

## 🛠️ Tech Stack

| Layer             | Technology                                      |
|------------------|-------------------------------------------------|
| Core Engine       | [Chromium Embedded Framework (CEF)] / [WebKit2] |
| GUI Framework     | [Flutter] (mobile + desktop)                    |
| Native Bridge     | Rust (via `tauri` or `flutter_rust_bridge`)     |
| Packaging Tool    | [Tauri] (for Desktop), [Flutter] (for Mobile)   |
| Build System      | Cargo (Rust) + Flutter                         |
| Storage           | SQLite (for bookmarks/history)                  |
| State Management  | Provider (Flutter)                             |
| WebView           | flutter_inappwebview                           |

> ⚙️ **Rust + Flutter + Tauri** = Ultra-light, secure, and fast

## 🧪 Installation (Developer)

### Prerequisites

- [Flutter](https://flutter.dev/docs/get-started/install) (latest stable)
- [Rust](https://www.rust-lang.org/tools/install) (latest stable)
- [Tauri CLI](https://tauri.app/v1/guides/getting-started/prerequisites)
- Platform-specific build tools:
  - Windows: Visual Studio with C++ build tools
  - macOS: Xcode Command Line Tools
  - Linux: build-essential, libwebkit2gtk-4.0-dev

### Clone and Run

```bash
git clone https://github.com/makalin/halo-browser.git
cd halo-browser
flutter pub get
cargo tauri dev
```

## 📦 Platforms

* ✅ Windows (x86\_64, ARM64)
* ✅ macOS (Intel, M1/M2)
* ✅ Linux (All major distros)
* ✅ Android (min SDK 21)
* ✅ iOS (iOS 13+)

## 📁 Project Structure

```
halo-browser/
├── lib/                    # Flutter UI code
│   ├── models/            # Data models
│   ├── providers/         # State management
│   ├── screens/           # Main screens
│   ├── widgets/           # Reusable widgets
│   └── main.dart          # Entry point
├── src-tauri/             # Rust backend
│   ├── src/              # Rust source code
│   └── Cargo.toml        # Rust dependencies
├── assets/                # Static assets
├── test/                  # Test files
├── pubspec.yaml          # Flutter dependencies
└── README.md
```

## 🧠 Roadmap

### Completed ✅
- [x] MVP: WebView + Address bar + Tabs
- [x] Bookmark management system
- [x] Download manager with progress tracking
- [x] Settings screen with theme support
- [x] Dark mode support
- [x] **Advanced tab management** (duplication, reordering, bulk operations)
- [x] **Enhanced address bar** (navigation controls, smart suggestions)
- [x] **Browsing history system** (tracking, search, filtering)
- [x] **Navigation history** (back/forward with visual indicators)
- [x] **Smart search suggestions** (history + bookmarks integration)
- [x] **Modern UI components** (Material Design 3, responsive layout)

### In Progress 🚧
- [ ] Ad-blocking engine (Rust)
- [ ] Extension sandbox (WASM)
- [ ] Bookmark & history sync
- [ ] Offline mode (caching)
- [ ] PWA support

### Planned 📋
- [ ] Password manager
- [ ] Reading mode
- [ ] Custom themes
- [ ] Gesture controls
- [ ] Voice search
- [ ] **Incognito mode**
- [ ] **Tab groups and organization**
- [ ] **Advanced privacy features**
- [ ] **Performance monitoring**
- [ ] **Keyboard shortcuts**

## 🤝 Contributing

We welcome contributions! Here's how you can help:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

### Development Guidelines

- Follow the Flutter style guide
- Write tests for new features
- Update documentation
- Keep commits atomic and well-described
- Use conventional commits format

## 📄 License

MIT License - see the [LICENSE](LICENSE) file for details

---

> **Halo** – The browser that stays out of your way, so you can blaze your own path.
