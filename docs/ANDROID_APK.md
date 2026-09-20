# v1 Android APK (sideload)

Package: `tz.kkkt.dkmzv.dkmzv_app`  
Version: `1.0.0+1`  
Signing: **debug keystore** (so `flutter run --release` and this APK work without a Play upload key). Replace before Play.

## Build on a machine with the Android SDK

```bash
export JAVA_HOME="${JAVA_HOME:-/usr/lib/jvm/java-21-openjdk-amd64}"
export ANDROID_HOME="${ANDROID_HOME:-$HOME/android-sdk}"
export ANDROID_SDK_ROOT="$ANDROID_HOME"
flutter config --android-sdk "$ANDROID_HOME"
flutter pub get
flutter build apk --release
```

Output: `build/app/outputs/flutter-apk/app-release.apk`

Or: `./scripts/build_android_apk.sh`

The APK is **not** committed. Cloud builds copy it to the run artifacts folder as `dkmzv-app-v1-release.apk`.

## Install on a phone (sideload)

1. Copy `app-release.apk` / `dkmzv-app-v1-release.apk` to the phone (Drive, USB, WhatsApp to yourself).
2. Android: **Settings → Security → Install unknown apps** for the app you used to open the file.
3. Open the APK → **Install**.
4. First launch: Kiswahili home, Canvy purple launcher (`#2E0854`), seed bulletin for Usharika wa Angaza.

Demo admin PIN: `dkmzv`. Seed paybill `400200` and role phones `+255 700 000 00x` are **placeholders** — do not collect real money or call those numbers.

## Play / production later

1. Create an upload keystore (keep it off git).
2. Point `android/app/build.gradle.kts` `release` at that store (today it uses `signingConfigs.debug`).
3. Bump `version:` in `pubspec.yaml`.
4. Prefer an **app bundle** (`flutter build appbundle`) for Play; keep a universal APK for parish sideload.
