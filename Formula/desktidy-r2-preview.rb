# typed: strict
# frozen_string_literal: true

# Source-built native preview that deliberately performs no service mutation.
class DesktidyR2Preview < Formula
  desc "Native DeskTidy developer preview built locally from source"
  homepage "https://github.com/AnubisQuantumCipher/desktidy"
  url "https://github.com/AnubisQuantumCipher/desktidy/archive/refs/tags/v1.2.0-preview.2.tar.gz"
  version "1.2.0-preview.2"
  sha256 "15d46b3c829a1af2e212b52f00888198ab51ef0d24838d71edca73918df076a8"
  license "MIT"

  depends_on arch: :arm64
  depends_on macos: :sonoma

  def install
    ENV["DESKTIDY_SOURCE_COMMIT"] = "8b6c09a9b85b5ef382bb76d0e0df7e3c1f7f2a24"
    system "scripts/build-app.sh", buildpath/"build"
    libexec.install "build/DeskTidy.app"
    (bin/"desktidy-r2-preview").write <<~SH
      #!/bin/bash
      exec /usr/bin/open "#{libexec}/DeskTidy.app"
    SH
  end

  def caveats
    <<~EOS
      This is a source-built, ad-hoc-signed developer preview. It is not
      Developer ID signed, notarized, or the supported public native release.

      Homebrew installation does not register, bootstrap, replace, or unload
      any Desktop service. Do not bypass Gatekeeper or use --no-quarantine for
      a downloaded prebuilt app.

      Launch the preview with:
        desktidy-r2-preview
    EOS
  end

  test do
    build = JSON.parse((libexec/"DeskTidy.app/Contents/Resources/DeskTidyBuild.json").read)
    assert_equal "8b6c09a9b85b5ef382bb76d0e0df7e3c1f7f2a24", build.fetch("sourceCommit")
    system "/usr/bin/codesign", "--verify", "--deep", "--strict", libexec/"DeskTidy.app"
  end
end
