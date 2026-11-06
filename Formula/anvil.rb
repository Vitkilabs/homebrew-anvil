# Vitkilabs Anvil command line and daemon (Apple silicon), pre-built.
#   brew install vitkilabs/anvil/anvil
# Installs the complete, stripped binaries from the release tarball; nothing is
# built on your machine.
class Anvil < Formula
  desc "Private, local, encrypted AI memory tool for your coding assistant (CLI)"
  homepage "https://vitkilabs.com/anvil"
  url "https://github.com/Vitkilabs/vitkilabs-anvil/releases/download/v1.0.2-beta/vitkilabs-anvil-1.0.2-beta-aarch64-apple-darwin.tar.gz"
  version "1.0.2-beta"
  sha256 "260a1640deafaadb5426398376283befb0cf765c4f99477582ab76454959a3e8"
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
