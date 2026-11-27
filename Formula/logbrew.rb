class Logbrew < Formula
  desc "Developer-first observability command-line interface"
  homepage "https://logbrew.co"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/LogBrewCo/cli/releases/download/v0.1.97/logbrew-cli-aarch64-apple-darwin.tar.xz"
      sha256 "530c512a9776648d97e3721df241ce684d17ae935b4dfacc8d24a8118bdd1ee3"
    end
    if Hardware::CPU.intel?
      url "https://github.com/LogBrewCo/cli/releases/download/v0.1.97/logbrew-cli-x86_64-apple-darwin.tar.xz"
      sha256 "d69a9e16ffc6758728019ef7bd0d36b633e4a775e0567db3954d3e67ac47e794"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/LogBrewCo/cli/releases/download/v0.1.97/logbrew-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "7e7b1a48b77483442d90af7ac76a0299222d4e59614f38bd7ba12740091e439f"
    end
    if Hardware::CPU.intel?
      url "https://github.com/LogBrewCo/cli/releases/download/v0.1.97/logbrew-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "3dd985b529a043a388e482119fb9652ac518bde1096e72460cc768a4004e5e0a"
    end
  end
  license "MIT"

  def install
    if OS.mac? && Hardware::CPU.arm?
      bin.install "logbrew"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "logbrew"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "logbrew"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "logbrew"
    end

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/logbrew version")
  end
end
