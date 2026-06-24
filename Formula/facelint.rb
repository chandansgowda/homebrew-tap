class Facelint < Formula
  desc "Menu-bar app that nudges you when you touch your face, for better skin"
  homepage "https://github.com/chandansgowda/facelint"
  url "https://github.com/chandansgowda/facelint/releases/download/v0.3.0/facelint-0.3.0.tar.gz"
  sha256 "64cae65dc0f00c8694ab24967f33c25be021647a15a6b8c4c927f775841ef760"
  license "MIT"

  # MediaPipe currently publishes wheels for Python 3.9-3.12, so pin 3.12.
  depends_on "python@3.12"

  def install
    # MediaPipe + OpenCV pull a large transitive dependency tree that is only
    # distributed as wheels, so we build an isolated virtualenv and let pip
    # resolve everything from PyPI rather than vendoring dozens of resources.
    venv = libexec
    system Formula["python@3.12"].opt_bin/"python3.12", "-m", "venv", venv
    system venv/"bin/pip", "install", "--upgrade", "pip", "wheel"
    system venv/"bin/pip", "install", buildpath
    bin.install_symlink venv/"bin/facelint"
  end

  def caveats
    <<~EOS
      facelint runs from your menu bar. Start it with:
        facelint

      On first launch macOS will ask for Camera permission. Approve it under
      System Settings -> Privacy & Security -> Camera, then relaunch.

      Everything runs locally; no video ever leaves your Mac. It also downloads
      two small MediaPipe model files (~8 MB) into
        ~/Library/Application Support/facelint/models
      the first time it runs.
    EOS
  end

  test do
    system libexec/"bin/python", "-c", "import facelint; assert facelint.__version__"
  end
end
