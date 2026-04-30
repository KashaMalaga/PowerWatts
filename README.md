# PowerWatts

PowerWatts is a small macOS menu bar app that shows the current charging wattage when an external power adapter is connected.

## Build a Release Zip

You do not need a paid Apple Developer account to build a zip for GitHub Releases. The release script builds the app with ad-hoc signing and writes the distributable zip to `dist/`.

```sh
./scripts/package_release.sh
```

The script prints:

- the generated zip path, for example `dist/PowerWatts-1.0.zip`
- the SHA-256 checksum, useful for a Homebrew cask

You can override the version used in the file name:

```sh
VERSION=1.0.1 ./scripts/package_release.sh
```

## Publish on GitHub

1. Push this repository to GitHub.
2. Run `./scripts/package_release.sh`.
3. Create a GitHub Release tag such as `v1.0`.
4. Upload the generated `dist/PowerWatts-1.0.zip` file as a release asset.

Because this app is not signed with an Apple Developer ID and is not notarized, macOS may block it the first time it is opened. Users can still run it by allowing the app in System Settings > Privacy & Security, or by using Finder's Open context menu.

## Optional Homebrew Tap

Official Homebrew Cask usually expects apps to pass Gatekeeper. Without Developer ID signing and notarization, use your own tap:

```sh
brew tap KashaMalaga/powerwatts
brew install --cask powerwatts
```

Create a separate GitHub repository named `homebrew-powerwatts`, then add this file at `Casks/powerwatts.rb`:

```ruby
cask "powerwatts" do
  version "1.0"
  sha256 "PASTE_SHA256_FROM_PACKAGE_SCRIPT"

  url "https://github.com/KashaMalaga/PowerWatts/releases/download/v#{version}/PowerWatts-#{version}.zip"
  name "PowerWatts"
  desc "Menu bar charging wattage monitor"
  homepage "https://github.com/KashaMalaga/PowerWatts"

  app "PowerWatts.app"
end
```

After each release, update `version` and `sha256` in the tap.
