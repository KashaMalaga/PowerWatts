cask "powerwatts" do
  version "1.0"
  sha256 "PASTE_SHA256_FROM_PACKAGE_SCRIPT"

  url "https://github.com/KashaMalaga/PowerWatts/releases/download/v#{version}/PowerWatts-#{version}.zip"
  name "PowerWatts"
  desc "Menu bar charging wattage monitor"
  homepage "https://github.com/KashaMalaga/PowerWatts"

  app "PowerWatts.app"

  caveats <<~EOS
    PowerWatts is ad-hoc signed and not notarized. If macOS blocks the first launch, run:
      xattr -d com.apple.quarantine /Applications/PowerWatts.app
  EOS
end
