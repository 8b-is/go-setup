class B8Go < Formula
  desc "8b-is Go toolchain + tooling (one-shot e2e setup)"
  homepage "https://github.com/8b-is/go-setup"
  license "MIT"
  head "https://github.com/8b-is/go-setup.git", branch: "main"

  depends_on "go"

  def install
    bin.install "setup-go.sh" => "b8-go"
    # 1b-go: the 1-bit / balanced ternary (BitNet b1.58) alias of b8-go.
    bin.install_symlink "b8-go" => "1b-go"
  end

  test do
    assert_match "8b-is Go toolchain", shell_output("#{bin}/b8-go --check")
    assert_predicate bin/"1b-go", :exist?
  end
end
