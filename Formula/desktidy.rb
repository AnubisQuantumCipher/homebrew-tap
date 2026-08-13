class Desktidy < Formula
  desc "Your macOS Desktop, organized automatically, with a notification per move"
  homepage "https://github.com/AnubisQuantumCipher/desktidy"
  url "https://github.com/AnubisQuantumCipher/desktidy/archive/refs/tags/v1.1.0.tar.gz"
  sha256 "b1fe4574c971b7c02fb23910ad639ef2dc334d2e4d1695834141469776783d77"
  license "MIT"

  depends_on :macos

  def install
    system "swiftc", "-O", "-parse-as-library", *Dir["src/*.swift"], "-o", "desktidy-sort"
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
