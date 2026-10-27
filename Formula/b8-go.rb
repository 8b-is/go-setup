class B8Go < Formula
  desc "8b-is Go toolchain + tooling (one-shot e2e setup)"
  homepage "https://github.com/8b-is/go-setup"
  license "MIT"
  head "https://github.com/8b-is/go-setup.git", branch: "main"

  depends_on "go"

  def install
    bin.install "setup-go.sh" => "b8-go"
  end

  test do
    assert_match "8b-is Go toolchain", shell_output("#{bin}/b8-go --check")
  end
end
