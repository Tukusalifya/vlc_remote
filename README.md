# VLCRemote

VLCRemote is a Flutter mobile app that remotely controls VLC Media Player through VLC's HTTP Web Interface.

It currently supports:

- Playback controls: play or pause, next, previous, stop, seek, fast-forward, rewind, fullscreen, and chapter navigation
- Volume adjustment
- Playback progress tracking
- Playlist viewing and media selection
- Real-time status sync through repeated polling of VLC's HTTP API

The app is built around quick remote access, responsive controls, and saved connection profiles for reliable device-to-device connectivity.

## Screenshots

| | | |
|---|---|---|
| ![Settings screen](assets/Screenshots/settings%20screen.jpg) | ![Remote screen](assets/Screenshots/remote%20screen.jpg) | ![Playlist screen](assets/Screenshots/playlist%20screen.jpg) |
| ![Playlist media options](assets/Screenshots/media%20options%20dialogue%20(playlist).jpg) | ![Add favourite](assets/Screenshots/add%20favourite.jpg) | ![Edit favourite](assets/Screenshots/edit%20favourite.jpg) |

## Packages Used

### Dependencies

- [cupertino_icons](https://pub.dev/packages/cupertino_icons) - iOS-style icons for Flutter's icon set.
- [iconly](https://pub.dev/packages/iconly) - Alternative icon pack used by some UI elements.
- [http](https://pub.dev/packages/http) - Sends HTTP requests to VLC's web interface endpoints.
- [provider](https://pub.dev/packages/provider) - State management for the active VLC connection details.
- [hive](https://pub.dev/packages/hive) - Local key-value storage for saved connection profiles.
- [hive_flutter](https://pub.dev/packages/hive_flutter) - Flutter bindings for Hive initialization and box access.
- [delightful_toast](https://pub.dev/packages/delightful_toast) - In-app toast notifications for success and error messages.

### Dev dependencies

- [flutter_test](https://pub.dev/packages/flutter_test) - Flutter testing framework.
- [hive_generator](https://pub.dev/packages/hive_generator) - Generates Hive type adapters for stored models.
- [build_runner](https://pub.dev/packages/build_runner) - Runs code generation tasks such as Hive adapter generation.
- [flutter_lints](https://pub.dev/packages/flutter_lints) - Recommended lint rules for Flutter projects.

## Installation

1. Download the provided APK file from the release location where it is hosted, such as GitHub Releases.
2. On the Android device, enable installing apps from unknown sources for the browser or file manager you use to open the APK. The exact setting name and location vary by Android version and manufacturer.
3. Open the APK file and follow the on-screen installation prompts.

## Usage

VLCRemote talks to VLC over HTTP with Basic authentication using the configured password. The app calls `/requests/status.xml` for commands, `/requests/playlist.json` for the current playlist, and `/requests/status.json` for playback state, time, volume, metadata, and chapters.

Project folders are present for Android, iOS, Linux, macOS, Web, and Windows. The app is clearly usable as an Android mobile app, and the repository also includes iOS and desktop/web platform folders. No platform-specific limitations are called out in the Dart code.

### 5.1 Enable the VLC Web Interface

On the VLC host device, enable VLC's Web Interface in VLC's preferences before connecting from the app. General guidance is:

1. Open VLC.
2. Go to `Tools` -> `Preferences`.
3. Switch to `Show settings: All`.
4. Open `Interface` -> `Main interfaces`.
5. Check `Web`.
6. Set a web interface password.

[NOTE: this is general VLC setup guidance; the app only consumes the HTTP interface and does not configure VLC itself.]

### 5.2 Direct Connection (one-off)

1. Open the `Settings` screen from the bottom navigation bar.
2. Fill in the connection form fields:
   - `Server IP Address`
   - `Port`
   - `Password`
3. Tap `Connect`.
4. Return to the `Remote` screen to control playback.

The settings form validates that each field is filled in before attempting to connect. If the VLC endpoint responds successfully, the app updates the active connection in memory and shows a success toast. If the request fails, it shows `Configuration change failed`.

The same screen also includes `Test Connection`, which checks the entered details and shows either `Success` or `Failed`.

### 5.3 Adding a Default Configuration

1. Open the `Settings` screen.
2. Tap the `+` floating action button to open `Add to Favourites`.
3. Fill in the fields:
   - `Configuration Name`
   - `Host / IP Address`
   - `Port`
   - `Password`
4. Optionally enable `Set as Default Configuration`.
5. Tap `Save Favourite`.

Saved favourites are stored locally in Hive. When a favourite is marked as default, the app clears any previously default favourite before saving the new one. On startup, the app looks for the first saved configuration marked `isDefault` and uses it for the active connection. If no default is saved, it falls back to hardcoded connection values in `main.dart`.

### 5.4 Using the Remote Screen

The `Remote` screen shows the current VLC connection state and playback controls.

Available controls confirmed in the code:

- `Play` / `Pause`
- `Previous`
- `Next`
- `Rewind 10s`
- `Forward 10s`
- `Chapter` previous / next
- Volume slider
- Seek bar for playback progress
- `Stop Playback`
- `Fullscreen` toggle from the top bar

The screen polls VLC every second through `status.json` to keep playback state, current media title, duration, position, and volume in sync.

### 5.5 Using the Playlist Screen

The `Playlist` screen displays the current VLC playlist from VLC's HTTP interface.

What you can do:

- Scroll the list of media items
- Tap an item to start playing it
- Open the `Media Options` dialog from the item menu and choose `Play`
- Search the loaded playlist by filename
- Refresh the list with the floating action button

The playlist screen loads items from VLC on startup and also reloads when the active connection changes.
