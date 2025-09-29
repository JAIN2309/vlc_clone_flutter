VividPlay v4 — SAF file picking, playlist reordering, full Android manifest, polished UI

This package is an advanced skeleton intended to be runnable on Android out-of-the-box. It includes:
- SAF-aware file picking using `file_picker` (works on Android and Web).
- Playlist with reorderable UI (ReorderableListView) and "Play All" behavior; playlist persisted with Hive.
- AudioHandler wired to just_audio + audio_service with metadata for notifications.
- An `android/` folder containing essential Android manifest and MainActivity for package `com.vividplay.app`.
- Polished splash screen and improved app icon in `assets/icon.png`.

Notes before running:
1. This repository contains a minimal Android folder. Flutter tooling will typically manage Gradle wrapper and other generated files. If you encounter build errors, run `flutter create .` inside the project folder to generate missing platform files, then re-run `flutter pub get` and `flutter run`.
2. Ensure Android SDK, Flutter SDK and Java are installed. Test on a real device for background audio/notifications and SAF behavior.
3. You may need to set `local.properties` with your `sdk.dir` and `flutter.sdk` if using the provided android folder directly.

Run:
- flutter pub get
- flutter run (on Android device)

If you'd like, I can also:
- Fully generate gradle wrapper files and the complete android build tree (this increases zip size significantly) so no further `flutter create` step is required.
- Replace the package name with one you choose.
