cask "powerwatts" do
  version "1.0"
  sha256 "PASTE_SHA256_FROM_PACKAGE_SCRIPT"

  url "https://github.com/KashaMalaga/PowerWatts/releases/download/v#{version}/PowerWatts-#{version}.zip"
  name "PowerWatts"
  desc "Menu bar charging wattage monitor"
  homepage "https://github.com/KashaMalaga/PowerWatts"

  app "PowerWatts.app"
end
