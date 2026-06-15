class Logbrew < Formula
  desc "Public command-line interface for LogBrew."
  homepage "https://logbrew.co"
  version "0.1.15"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/LogBrewCo/cli/releases/download/v0.1.15/logbrew-cli-aarch64-apple-darwin.tar.xz"
      sha256 "fc88a3e755a811c5de8ff42d3972f4e4db8b8289b24d890b10d91ba7d49a5c4b"
    end
    if Hardware::CPU.intel?
      url "https://github.com/LogBrewCo/cli/releases/download/v0.1.15/logbrew-cli-x86_64-apple-darwin.tar.xz"
      sha256 "793775a70e58f1d26239e9606fedbef4784d817d830307656c549e35f1f63105"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/LogBrewCo/cli/releases/download/v0.1.15/logbrew-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "6079cd929c2ce00a28f7d82d9fcfe628bb7411d3c9ada70ea1a438ff83bec01a"
    end
    if Hardware::CPU.intel?
      url "https://github.com/LogBrewCo/cli/releases/download/v0.1.15/logbrew-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "6c87d7ad807afdbabaa44d1fdf6393ac7dbcac6ea5275cbbdbd4b2cfb3a43b61"
    end
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin": {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-apple-darwin": {},
    "x86_64-pc-windows-gnu": {},
    "x86_64-unknown-linux-gnu": {}
  }

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

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

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
