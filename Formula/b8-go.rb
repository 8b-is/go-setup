class B8Go < Formula
  desc "8b-is Go toolchain + Apple Silicon M1 / 8b M1 64GB unified-memory setup (b8-go & 1b-go)"
  homepage "https://github.com/8b-is/go-setup"
  license "MIT"
  head "https://github.com/8b-is/go-setup.git", branch: "main"

  depends_on "go"

  def install
    bin.install "setup-go.sh" => "b8-go"
    # 1b-go: the 1-bit / balanced ternary (BitNet b1.58 {-1, 0, +1}) alias of b8-go.
    bin.install_symlink "b8-go" => "1b-go"
  end

  def caveats
    <<~EOS
      b8-go (and its 1-bit quantum alias 1b-go) configures Apple Silicon
      unified-memory defaults for 16GB/32GB M1 and the 8b M1 64GB node:
        export GOARCH=arm64
        export CGO_ENABLED=1
        export GOGC=100
        export GOMEMLIMIT=53687091200   # 50 GiB on 64GB M1 (20 GiB on 32GB, 10 GiB on 16GB)
    EOS
  end

  test do
    assert_match "8b-is Go toolchain", shell_output("#{bin}/b8-go --check")
    assert_predicate bin/"1b-go", :exist?
  end
end
