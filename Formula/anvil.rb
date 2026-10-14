# Vitkilabs Anvil command line and daemon (Apple silicon), pre-built.
#   brew install vitkilabs/anvil/anvil
# Installs the complete, stripped binaries from the release tarball; nothing is
# built on your machine.
class Anvil < Formula
  desc "Private, local, encrypted AI memory tool for your coding assistant (CLI)"
  homepage "https://vitkilabs.com/anvil"
  url "https://github.com/Vitkilabs/anvil-releases/releases/download/v0.0.4/anvil-0.0.4-aarch64-apple-darwin.tar.gz"
  version "0.0.4"
  sha256 "cc621c4d2318522c0164d6ce958414d0ab5b6d646f8388cfe74e6b41add73f1f"
  license :cannot_represent # proprietary; use is governed by the in-app EULA

  # Apple silicon only: Intel Macs are not supported.
  depends_on arch: :arm64
  depends_on :macos

  def install
    bin.install "anvil"
    bin.install "anvild"
    bin.install "anvil-mcp"
    # The embedding model, so the first start needs no internet (0.0.2).
    (share/"anvil").install "models"
  end

  test do
    assert_match "anvil", shell_output("#{bin}/anvil --version")
  end
end
