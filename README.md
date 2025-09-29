# VividPlay v4

A Flutter-based media player with **background audio, SAF file picking, playlist management, and polished UI**.  

This version is runnable on **Android (v2 embedding)** out-of-the-box and also supports Web for file picking.

## Features

- SAF-aware file picker for local audio/video files
- Reorderable playlist UI with "Play All" functionality
- Background audio playback via **just_audio + audio_service**
- Notification controls with metadata
- Hive persistence for playlist
- Polished splash screen & custom app icon

## Getting Started

### Prerequisites

- Flutter SDK >= 3.13
- Android SDK + Java
- iOS SDK (if running on iOS)

### Installation

```bash
git clone https://github.com/YourUsername/vividplay_v4.git
cd vividplay_v4
flutter pub get
flutter run
