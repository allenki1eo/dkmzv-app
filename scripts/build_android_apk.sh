#!/usr/bin/env bash
# Build the v1 release APK. Requires Android SDK + JDK 17+.
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"

export JAVA_HOME="${JAVA_HOME:-/usr/lib/jvm/java-21-openjdk-amd64}"
export ANDROID_HOME="${ANDROID_HOME:-${ANDROID_SDK_ROOT:-$HOME/android-sdk}}"
export ANDROID_SDK_ROOT="$ANDROID_HOME"
export PATH="$ANDROID_HOME/cmdline-tools/latest/bin:$ANDROID_HOME/platform-tools:$PATH"

if [[ ! -x "$ANDROID_HOME/cmdline-tools/latest/bin/sdkmanager" && ! -x "$ANDROID_HOME/cmdline-tools/latest/bin/android" ]]; then
  echo "Android SDK cmdline-tools not found under $ANDROID_HOME" >&2
  echo "See docs/ANDROID_APK.md" >&2
  exit 1
fi

flutter config --android-sdk "$ANDROID_HOME"
flutter pub get
flutter build apk --release

APK="$ROOT/build/app/outputs/flutter-apk/app-release.apk"
echo "Built $APK"
ls -lh "$APK"
