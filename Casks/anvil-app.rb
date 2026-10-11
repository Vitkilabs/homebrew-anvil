# Vitkilabs Anvil desktop app (Apple silicon).
#   brew install --cask vitkilabs/anvil/anvil-app
#
# Without an Apple Developer ID (checked 2026-09-25): our own tap may carry an
# app that is signed but not notarized (the official homebrew/cask repo may
# not). Apple silicon runs only signed code; the bundle's signature verifies, so
# the only obstacle is Gatekeeper refusing the first launch of a QUARANTINED
# copy. Homebrew no longer has --no-quarantine, so the postflight step below
# clears the quarantine flag on the app Homebrew just installed, and only that
# app, at install and upgrade. When Developer ID + notarization land, delete the
# postflight_steps block and nothing else changes for users.
#
# The CLI formula (Formula/anvil.rb) is separate and needs none of this:
# formula downloads are never quarantined.
cask "anvil-app" do
  # Apple silicon only: Intel Macs are not supported (2026-10-09).
  version "0.0.1"
  sha256 "742f53bc4e848bcc9a43607c478b1998f2d40cf692161acdac860eb55ec5b6f1"

  url "https://github.com/Vitkilabs/anvil-releases/releases/download/v#{version}/Anvil_#{version}_aarch64.dmg",
      verified: "github.com/Vitkilabs/anvil-releases/"
  name "Vitkilabs Anvil"
  desc "Private, local, encrypted AI memory tool for your coding assistant"
  homepage "https://vitkilabs.com/anvil"

  livecheck do
    url :url
    strategy :github_latest
  end

  # The app updates itself through its signed updater feed; Homebrew should
  # not also try to, or the two fight over the same bundle.
  auto_updates true
  depends_on arch: :arm64
  depends_on macos: :monterey

  app "Anvil.app"
  # The command line ships inside the app; put it on PATH so `anvil status`,
  # `anvil connect` and `anvil doctor` work in a terminal (the install guide
  # relies on them). The CLI-only formula installs the same commands.
  binary "#{appdir}/Anvil.app/Contents/MacOS/anvil"
  binary "#{appdir}/Anvil.app/Contents/MacOS/anvil-mcp"

  postflight_steps do
    run "/usr/bin/xattr",
        args:           ["-dr", "com.apple.quarantine", "{{appdir}}/Anvil.app"],
        writable_paths: ["Anvil.app"],
        writable_base:  :appdir
  end

  # Uninstall, even --zap, removes the program and its caches only. The vault
  # and memory in ~/.anvil are the user's data: only `anvil uninstall` removes
  # them, after offering a readable backup.
  # From 0.0.2 the app installs a login LaunchAgent for its daemon; uninstalling
  # stops it and removes the agent (the data in ~/.anvil stays).
  uninstall quit:      "com.vitkilabs.anvil",
            launchctl: "com.vitkilabs.anvil.daemon"

  zap trash: [
    "~/Library/Application Support/com.vitkilabs.anvil",
    "~/Library/Caches/com.vitkilabs.anvil",
    "~/Library/Preferences/com.vitkilabs.anvil.plist",
    "~/Library/Saved Application State/com.vitkilabs.anvil.savedState",
    "~/Library/WebKit/com.vitkilabs.anvil",
  ]

  caveats <<~EOS
    Vitkilabs Anvil keeps your memory in ~/.anvil, encrypted. Uninstalling the
    app leaves it in place; to remove it too, run `anvil uninstall` first. It
    offers a readable backup before deleting anything.

    Anvil is alpha and not yet notarized. If macOS still blocks the first
    launch: System Settings → Privacy & Security → Open Anyway.
  EOS
end
