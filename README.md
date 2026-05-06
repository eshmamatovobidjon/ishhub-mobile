# IshHub Mobile

Mobile app for IshHub — a local services marketplace connecting clients with workers in Uzbekistan.

**Stack:** Flutter 3.27 · Dart · Google Maps · Firebase Cloud Messaging

---

## Prerequisites

- Flutter SDK 3.27+
- Dart SDK (included with Flutter)
- Android Studio or Xcode (for emulators)
- Google Maps API key

## Local Development Setup

### 1. Clone & enter the repo

```bash
git clone https://github.com/eshmamatovobidjon/ishhub-mobile.git
cd ishhub-mobile
```

### 2. Install dependencies

```bash
flutter pub get
```

### 3. Run the app

```bash
# List available devices
flutter devices

# Run on a specific device
flutter run -d <device_id>

# Run on Chrome (web debug)
flutter run -d chrome
```

### 4. Run tests

```bash
flutter test
```

### 5. Analyze code

```bash
flutter analyze
dart format .
```

## Branch Strategy

- `main` — production-ready code
- `develop` — integration branch
- `feature/*` — feature branches (branch off `develop`)

**Flow:** `feature/*` → `develop` → `main`

---

## Project Structure

```
ishhub-mobile/
├── lib/
│   ├── main.dart
│   ├── app.dart
│   ├── config/           # App config, themes, constants
│   ├── models/           # Data models
│   ├── services/         # API client, auth, location, etc.
│   ├── providers/        # State management
│   ├── screens/          # Screen widgets
│   │   ├── auth/
│   │   ├── home/
│   │   ├── jobs/
│   │   ├── chat/
│   │   ├── profile/
│   │   └── street_mode/
│   ├── widgets/          # Reusable widgets
│   └── utils/            # Helpers, formatters
├── test/                 # Unit & widget tests
├── assets/               # Images, fonts
├── analysis_options.yaml # Lint rules
└── pubspec.yaml          # Dependencies
```
