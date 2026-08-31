<p align="center">
  <img src="assets/icon/icon.png" width="112" alt="EasyReader icon">
</p>

<h1 align="center">EasyReader</h1>

<p align="center">
  An ebook reader built around a single idea: <strong>reading comfort</strong>.<br>
  Customizable visual comfort filters, organized libraries, reading statistics.
</p>

<p align="center">
  <img alt="Flutter" src="https://img.shields.io/badge/Flutter-3.44-02569B?logo=flutter&logoColor=white">
  <img alt="Platforms" src="https://img.shields.io/badge/platforms-Android%20%7C%20macOS-informational">
  <img alt="Status" src="https://img.shields.io/badge/status-in%20development-yellow">
</p>

---

## What it is

EasyReader is an EPUB/PDF reader with a precise focus: making reading easier
on the eyes through page filters adjustable in real time, instead of just
the usual light/dark mode. It's a personal project, built in Flutter to
stay cross-platform from the ground up.

## Features

**Reading**
- Supported formats: **EPUB** and **PDF**
- Real-time page filters: background color, color overlay
  (also useful for visual comfort needs such as dyslexia), brightness,
  paper filter with texture, text size
- Persistent progress bar with percentage read and, for PDFs,
  current page out of total
- Automatic resume from the exact point where reading was interrupted

**Library**
- Adaptive-column grid based on available space (2 on
  smartphone, more on a wider desktop window)
- Automatic covers: extracted from the manifest for EPUBs, rendered
  from the first page for PDFs
- Custom shelves to organize books, each with a chosen name,
  color and icon
- Rename, move to shelf, delete — all from a long press
- Import directly from a file, or by **sharing** an EPUB/PDF from another
  app or opening it directly with EasyReader

**Statistics**
- Per book: reading time, number of sessions, percentage,
  date added and last read
- Overview: books in library, completed, in progress, total reading
  time, most-read books

## Tech stack

| Layer | Choice |
|---|---|
| UI | Flutter, [Riverpod](https://riverpod.dev) |
| Persistence | [drift](https://drift.simonbinder.eu) (SQLite) |
| EPUB engine | [flutter_epub_viewer](https://pub.dev/packages/flutter_epub_viewer) |
| PDF engine | [syncfusion_flutter_pdfviewer](https://pub.dev/packages/syncfusion_flutter_pdfviewer) + [pdfx](https://pub.dev/packages/pdfx) (covers) |
| EPUB covers | [archive](https://pub.dev/packages/archive) + [xml](https://pub.dev/packages/xml) (manifest parsing) |
| Sharing | [receive_sharing_intent](https://pub.dev/packages/receive_sharing_intent) |

Three-layer architecture (`domain` → `data` → `presentation`), with
repositories behind interfaces to keep application logic independent
from the rendering engine or the database.

```
lib/
├── domain/            # entities, repository interfaces, use cases
├── data/              # drift implementations, cover extraction, filters
└── presentation/       # screens and widgets, organized by feature
```

## Platforms

Developed Android-first, with macOS as a second platform already
working thanks to Flutter's cross-platform nature — the only part
that requires native adaptation is the conversion of future formats like
MOBI/AZW3.

## Development

```bash
flutter pub get
dart run build_runner build   # generates the drift code
```

Build:

```bash
flutter build apk --debug     # Android
flutter build macos --debug   # macOS (requires Xcode and CocoaPods)
```

Checks:

```bash
flutter analyze
flutter test
```

## Roadmap

- [x] MOBI, AZW3 support (via conversion)
- [ ] FB2 support
- [x] Color temperature and contrast among the filters
- [x] Fonts dedicated to readability (e.g. dyslexia)
- [ ] Reading break reminder
- [ ] Windows and Linux (code ready for Windows, not yet verifiable on a real Windows host; Linux not started yet)

## License

Personal project, not yet distributed. No public license at
this time.
