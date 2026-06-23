class PostureFix < Formula
  desc "Menu-bar app that nudges your posture using AirPods motion sensors"
  homepage "https://github.com/chandansgowda/posture-fix"
  url "https://github.com/chandansgowda/posture-fix/archive/refs/tags/v0.1.2.tar.gz"
  sha256 "b38d67dc5ffb9206f3ec5adeedaaf8198015a6791458022085e17a019b099761"
  license "MIT"
  head "https://github.com/chandansgowda/posture-fix.git", branch: "main"

  depends_on :macos
  depends_on xcode: ["15.0", :build]

  def install
    system "./build.sh", "release"
    prefix.install ".build/release/PostureFix.app"

    # `posture-fix` launches the menu-bar app.
    (bin/"posture-fix").write <<~SH
      #!/bin/bash
      open "#{prefix}/PostureFix.app"
    SH
  end

  def caveats
    <<~EOS
      PostureFix is a menu-bar app. Launch it with:
        posture-fix
      or copy it into /Applications so it shows in Spotlight:
        cp -R #{prefix}/PostureFix.app /Applications/

      On first launch: connect your AirPods, grant Motion + Notification
      permission, click Start, sit upright, then Calibrate.
    EOS
  end

  test do
    assert_predicate prefix/"PostureFix.app", :exist?
  end
end
