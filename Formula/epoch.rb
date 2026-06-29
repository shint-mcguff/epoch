class Epoch < Formula
  desc "Convert between Unix timestamps and human-readable dates"
  homepage "https://github.com/shint-mcguff/epoch"
  url "https://github.com/shint-mcguff/epoch/releases/download/v0.1.0/epoch-v0.1.0-universal-macos.tar.gz"
  # Filled in after the v0.1.0 release asset is built by CI.
  sha256 "0000000000000000000000000000000000000000000000000000000000000000"
  license "MIT"
  version "0.1.0"

  depends_on :macos

  def install
    bin.install "epoch"
  end

  test do
    assert_equal "0.1.0", shell_output("#{bin}/epoch --version").strip
    assert_equal "2024-06-29T03:00:00Z", shell_output("#{bin}/epoch -r 1719630000").strip
    assert_equal "1719630000", shell_output("#{bin}/epoch -r 2024-06-29T03:00:00Z").strip
  end
end
