#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
PROJECT="$ROOT_DIR/PowerWatts.xcodeproj"
PROJECT_FILE="$PROJECT/project.pbxproj"
SCHEME="PowerWatts"
CONFIGURATION="Release"
APP_NAME="PowerWatts"
BUILD_ROOT="$ROOT_DIR/build/release"
DERIVED_DATA="$BUILD_ROOT/DerivedData"
STAGING_DIR="$BUILD_ROOT/staging"
DIST_DIR="$ROOT_DIR/dist"

VERSION="${VERSION:-$(/usr/bin/awk -F ' = ' '/MARKETING_VERSION/ { gsub(/;$/, "", $2); print $2; exit }' "$PROJECT_FILE")}"
if [[ -z "$VERSION" ]]; then
  echo "Could not determine MARKETING_VERSION. Set VERSION=1.0.0 and rerun." >&2
  exit 1
fi

APP_PATH="$DERIVED_DATA/Build/Products/$CONFIGURATION/$APP_NAME.app"
ZIP_PATH="$DIST_DIR/$APP_NAME-$VERSION.zip"

echo "Building $APP_NAME $VERSION..."
/usr/bin/xcodebuild \
  -project "$PROJECT" \
  -scheme "$SCHEME" \
  -configuration "$CONFIGURATION" \
  -derivedDataPath "$DERIVED_DATA" \
  CODE_SIGN_STYLE=Manual \
  CODE_SIGN_IDENTITY=- \
  CODE_SIGN_INJECT_BASE_ENTITLEMENTS=NO \
  DEVELOPMENT_TEAM= \
  build

if [[ ! -d "$APP_PATH" ]]; then
  echo "Build succeeded, but $APP_PATH was not found." >&2
  exit 1
fi

echo "Creating release zip..."
/bin/rm -rf "$STAGING_DIR"
/bin/mkdir -p "$STAGING_DIR" "$DIST_DIR"
/bin/cp -R "$APP_PATH" "$STAGING_DIR/"
/bin/rm -f "$ZIP_PATH"

(
  cd "$STAGING_DIR"
  /usr/bin/zip --symlinks -r -X -q "$ZIP_PATH" "$APP_NAME.app"
)

SHA256="$(/usr/bin/shasum -a 256 "$ZIP_PATH" | /usr/bin/awk '{ print $1 }')"

echo
echo "Release artifact:"
echo "  $ZIP_PATH"
echo
echo "SHA-256:"
echo "  $SHA256"
echo
echo "Signing note:"
echo "  This build is ad-hoc signed. Users may need to allow it manually in macOS Gatekeeper."
