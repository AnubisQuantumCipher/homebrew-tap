class Desktidy < Formula
  desc "Your macOS Desktop, organized automatically, with a notification per move"
  homepage "https://github.com/AnubisQuantumCipher/desktidy"
  url "https://github.com/AnubisQuantumCipher/desktidy/archive/refs/tags/v1.1.2.tar.gz"
  sha256 "cbf8ea6020f117bd0f6971555aae04a955cda90c8bd93c38e40f80308b15792e"
  license "MIT"

  disable! date: "2026-08-15", because: "the formula installs the retired legacy Desktop authority"

  depends_on :macos

  def install
    system "xcrun", "swiftc", "-O", "-parse-as-library", *Dir["src/*.swift"], "-o", "desktidy-sort"
    system "codesign", "-s", "-", "-i", "com.desktidy.sort", "desktidy-sort"
    bin.install "desktidy-sort"
    bin.install "src/desktidy-cli.sh" => "desktidy"
    libexec.install "src/desktidy-notify.sh"
    (share/"desktidy").install Dir["launchagents/*.template"]
  end

  def caveats
    <<~EOS
      This formula is the retired legacy CLI. Do not install or run its setup
      command alongside the native DeskTidy authority.

      Start the background service with:
        desktidy setup

      It will walk you through the one-time Full Disk Access grant
      (macOS requires it before a background helper may touch your Desktop).

      For clickable notifications:  brew install terminal-notifier

      Note: after a `brew upgrade desktidy`, run `desktidy status` — if macOS
      dropped the Full Disk Access grant for the new binary, re-add it.
    EOS
  end

  test do
    system bin/"desktidy-sort", "--self-test"
  end
end
