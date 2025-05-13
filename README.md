# 🌐 Halo Browser

**Halo** is a lightning-fast, privacy-focused, and cross-platform web browser designed for modern devices. Built with performance in mind, Halo runs natively on **desktop**, **mobile**, and even **embedded systems** using a unified codebase.

## 🚀 Features

- 🧊 **Minimal UI**, zero bloat
- 🔒 **Privacy-first**: no tracking, no telemetry
- ⚡️ **Blazing fast** rendering with WebView / WebKit / Blink support
- 📱 **Cross-platform**: Linux, Windows, macOS, Android, iOS
- 🧩 Modular extension support (planned)
- 🌙 Dark mode by default

## 🛠️ Tech Stack

| Layer             | Technology                                      |
|------------------|-------------------------------------------------|
| Core Engine       | [Chromium Embedded Framework (CEF)] / [WebKit2] |
| GUI Framework     | [Flutter] (mobile + desktop)                    |
| Native Bridge     | Rust (via `tauri` or `flutter_rust_bridge`)     |
| Packaging Tool    | [Tauri] (for Desktop), [Flutter] (for Mobile)   |
| Build System      | Cargo (Rust) + Flutter                         |
| Storage           | SQLite (for bookmarks/history)                  |

> ⚙️ **Rust + Flutter + Tauri** = Ultra-light, secure, and fast

## 🧪 Installation (Developer)

### Prerequisites

- [Flutter](https://flutter.dev/docs/get-started/install)
- [Rust](https://www.rust-lang.org/tools/install)
- [Tauri CLI](https://tauri.app/v1/guides/getting-started/prerequisites)

### Clone and Run

```bash
git clone https://github.com/yourusername/halo-browser.git
cd halo-browser
flutter pub get
cargo tauri dev
````

## 📦 Platforms

* ✅ Windows (x86\_64, ARM64)
* ✅ macOS (Intel, M1/M2)
* ✅ Linux (All major distros)
* ✅ Android (min SDK 21)
* ✅ iOS (iOS 13+)

## 📁 Project Structure

```
halo-browser/
├── src/              # Rust core modules
├── lib/              # Flutter UI code
├── tauri.conf.json   # Tauri settings
├── assets/           # Icons, splash screens
└── README.md
```

## 🧠 Roadmap

* [x] MVP: WebView + Address bar + Tabs
* [ ] Ad-blocking engine (Rust)
* [ ] Extension sandbox (WASM)
* [ ] Bookmark & history sync
* [ ] Offline mode (caching)
* [ ] PWA support

## 🤝 Contributing

Contributions welcome! Please open an issue or fork and submit a PR.

## 📄 License

MIT License

---

> **Halo** – The browser that stays out of your way, so you can blaze your own path.
