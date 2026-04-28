# Flutter App Testing

## Environment Setup

1. Flutter SDK is at `/home/ubuntu/flutter/bin/flutter` — add to PATH or use full path
2. Run `flutter pub get` in the project directory before anything else
3. Enable web platform: `flutter create . --platforms web` (generates `web/` directory)

## Running on Web

```bash
flutter run -d web-server --web-port=9090
```

- Use `web-server` device (not `chrome`) to avoid conflicts with existing Chrome instances
- Open `http://localhost:9090` in the existing browser
- Hot restart: press `R` in the Flutter shell session

## Known Web Limitations

- **sqflite**: Does not support web platform. Medication lists, detail pages, and any SQLite-dependent features won't load. UI structure (AppBar, theme, navigation) is still testable.
- **Splash screens with timers**: A `Future.delayed` splash (e.g. 3 seconds) may expire before the Flutter web engine finishes initializing. The first painted frame will be the home screen, not the splash. Splash testing requires an Android device/emulator.
- **Port conflicts**: Default port 8080 may be in use. Specify `--web-port=9090` or another free port.

## Static Analysis

```bash
flutter analyze
```

Expect "No issues found!" with exit code 0.

## What Can Be Tested on Web

- AppBar rendering (title, icons, colors)
- Language toggle (Arabic ↔ French)
- Theme/color palette verification
- Navigation structure
- Loading states (spinners)

## What Requires Android Device/Emulator

- SQLite database operations (medication list, search, categories)
- Detail page content
- Splash screen animations
- Full end-to-end user flow

## Devin Secrets Needed

No secrets required for local Flutter development and testing.
