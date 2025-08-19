# Halo Browser

![Halo Browser Logo](assets/images/logo.png)

**Lightning-fast, privacy-focused, and cross-platform web browser with advanced developer tools and AI integration**

## 🚀 Features

### Core Browser Features
- **Advanced Tab Management**: Multiple tabs with drag & drop, duplication, and smart organization
- **Smart Navigation**: Back/Forward navigation with history tracking
- **Address Bar**: Intelligent URL input with search suggestions from bookmarks and history
- **Bookmark Management**: One-click bookmark toggle with favicon support
- **Browsing History**: Comprehensive history tracking with search and filtering
- **Download Manager**: Organized download tracking and management
- **Theme Support**: Light, dark, and system theme modes with Material Design 3

### 🧠 AI-Powered Features
- **Multi-AI Integration**: Support for ChatGPT, Grok, Claude, and Ollama
- **Intelligent Page Analysis**: AI-powered content analysis and insights
- **Smart Suggestions**: Context-aware AI assistance for browsing issues
- **Automated Content Processing**: AI-driven content extraction and summarization
- **Custom AI Workflows**: Create and save AI-powered automation scripts

### 🛠️ Developer Tools & Automation
- **Script Engine**: Execute JavaScript, Python, and regex scripts on web pages
- **Content Extraction**: CSS selector-based content extraction with multiple output formats
- **Automation Scripts**: Save, load, and manage custom automation scripts
- **Real-time Debugging**: Console logging, error detection, and page issue monitoring
- **Script Library**: Import/export scripts and share with the community
- **Extraction Rules**: Define and save content extraction patterns for repeated use

### 🔍 Advanced Content Management
- **Real-time Language Parsing**: Extract text, images, and links from any webpage
- **Automated Data Collection**: Set up rules to automatically extract specific content
- **Content Export**: Save extracted content to local folders in various formats
- **Batch Processing**: Apply extraction rules across multiple pages
- **Custom Output Formats**: JSON, CSV, plain text, and structured data export

### 🎨 Customization & UX
- **Minimizable Interface**: Collapsible bottom navigation and side panels
- **Window Memory**: Remembers window size, position, and state across sessions
- **Responsive Design**: Adapts to different screen sizes and orientations
- **Keyboard Shortcuts**: Power user shortcuts for common actions
- **Custom Themes**: Create and share custom color schemes

### 🔒 Privacy & Security
- **Privacy-First Design**: No tracking, no telemetry, no data collection
- **Secure Browsing**: Enhanced security features and warnings
- **Content Filtering**: Block unwanted content and scripts
- **Local Processing**: AI and automation run locally when possible

## 🏗️ Tech Stack

- **Frontend**: Flutter with Material Design 3
- **State Management**: Provider pattern with ChangeNotifier
- **Storage**: SQLite for history, SharedPreferences for settings
- **AI Integration**: RESTful API integration with multiple AI services
- **Script Execution**: JavaScript engine and Python interpreter support
- **Content Processing**: HTML parsing and CSS selector engine
- **Cross-Platform**: Web, macOS, Windows, and Linux support

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (3.16.0 or higher)
- Dart SDK (3.2.0 or higher)
- For macOS: Xcode 14.0+ and CocoaPods
- For AI features: API keys for desired services

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/yourusername/halo-browser.git
   cd halo-browser
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Configure AI services** (optional)
   - Add API keys in the AI settings
   - Enable desired AI services
   - Configure local Ollama instance if using

4. **Run the application**
   ```bash
   # For web
   flutter run -d chrome
   
   # For macOS
   flutter run -d macos
   
   # For other platforms
   flutter run
   ```

### Building for Production

```bash
# Web build
flutter build web --release

# macOS build
flutter build macos --release

# Windows build
flutter build windows --release

# Linux build
flutter build linux --release
```

## 🎯 Use Cases

### For Developers
- **Web Scraping**: Extract data from websites using CSS selectors
- **Automation**: Create scripts to automate repetitive web tasks
- **Testing**: Use scripts to test web applications
- **Content Analysis**: AI-powered analysis of web content
- **Data Collection**: Automated collection of web data

### For Researchers
- **Data Mining**: Extract structured data from research websites
- **Content Analysis**: AI-powered analysis of academic content
- **Automated Research**: Scripts to gather research data
- **Citation Management**: Extract and organize research citations

### For Content Creators
- **Content Monitoring**: Track changes on competitor websites
- **Image Collection**: Automated image gathering for projects
- **Text Extraction**: Extract text content for analysis
- **Link Management**: Organize and categorize web links

### For Business Users
- **Market Research**: Monitor competitor websites and pricing
- **Lead Generation**: Extract contact information from websites
- **Content Aggregation**: Gather content from multiple sources
- **Automated Reporting**: Generate reports from web data

## 📚 Documentation

### Scripting Guide
- [JavaScript Scripting](docs/scripting/javascript.md)
- [Python Automation](docs/scripting/python.md)
- [Content Extraction](docs/extraction/README.md)
- [AI Integration](docs/ai/README.md)

### API Reference
- [Script Engine API](docs/api/script-engine.md)
- [Content Extraction API](docs/api/extraction.md)
- [AI Provider API](docs/api/ai-provider.md)
- [Browser Provider API](docs/api/browser-provider.md)

### Examples
- [Basic Scripts](examples/scripts/)
- [Extraction Rules](examples/extraction/)
- [AI Workflows](examples/ai/)
- [Automation Scripts](examples/automation/)

## 🤝 Contributing

We welcome contributions! Please see our [Contributing Guide](CONTRIBUTING.md) for details.

### Development Setup
1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests if applicable
5. Submit a pull request

### Areas for Contribution
- **AI Integration**: Add support for new AI services
- **Script Engine**: Enhance script execution capabilities
- **Content Extraction**: Improve extraction algorithms
- **UI/UX**: Enhance the user interface
- **Documentation**: Improve guides and examples
- **Testing**: Add comprehensive test coverage

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- Flutter team for the amazing framework
- Material Design team for the design system
- OpenAI, Anthropic, and xAI for AI service APIs
- Ollama team for local AI models
- The open-source community for inspiration and tools

## 📞 Support

- **Issues**: [GitHub Issues](https://github.com/yourusername/halo-browser/issues)
- **Discussions**: [GitHub Discussions](https://github.com/yourusername/halo-browser/discussions)
- **Documentation**: [Wiki](https://github.com/yourusername/halo-browser/wiki)
- **Email**: support@halobrowser.com

## 🔮 Roadmap

### Completed ✅
- [x] Basic browser functionality with tabs
- [x] Bookmark management system
- [x] Download manager
- [x] History tracking and search
- [x] Theme support (light/dark/system)
- [x] Settings screen with theme support
- [x] Window settings persistence
- [x] Loading progress indicators
- [x] URL-based title updates
- [x] Loading duration tracking
- [x] Top menu bar with window controls
- [x] AI service integration framework
- [x] Advanced logging and error detection
- [x] Script engine for automation
- [x] Content extraction system
- [x] Developer tools interface

### In Progress 🚧
- [ ] Real JavaScript engine integration
- [ ] Python interpreter integration
- [ ] Advanced network monitoring
- [ ] Performance profiling tools
- [ ] Extension system

### Planned 📋
- [ ] Advanced AI workflows
- [ ] Machine learning models for content analysis
- [ ] Collaborative script sharing
- [ ] Cloud sync for scripts and settings
- [ ] Mobile app versions
- [ ] Enterprise features
- [ ] Advanced security features
- [ ] Performance optimization
- [ ] Accessibility improvements
- [ ] Internationalization (i18n)

---

**Halo Browser** - Empowering developers and power users with intelligent web automation and AI-powered browsing.
