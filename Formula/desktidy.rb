class Desktidy < Formula
  desc "Your macOS Desktop, organized automatically, with a notification per move"
  homepage "https://github.com/AnubisQuantumCipher/desktidy"
  url "https://github.com/AnubisQuantumCipher/desktidy/archive/refs/tags/v1.1.1.tar.gz"
  sha256 "4d6c54f67d173518ac7e3f1bd3e1b8a02f38e649419c50f256362be94cd2934c"
  license "MIT"

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
