class Logbrew < Formula
  desc "Public command-line interface for LogBrew."
  homepage "https://logbrew.co"
  version "0.1.13"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/LogBrewCo/cli/releases/download/v0.1.13/logbrew-cli-aarch64-apple-darwin.tar.xz"
      sha256 "1fb841c73c511fb3b9f9e65c2164f78db766b909fc8a327baeacc87e35d84eba"
    end
    if Hardware::CPU.intel?
      url "https://github.com/LogBrewCo/cli/releases/download/v0.1.13/logbrew-cli-x86_64-apple-darwin.tar.xz"
      sha256 "9c1a63405d81846b2792b8ba5e3a25f8329e4f17706df79c857c30265eae6477"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/LogBrewCo/cli/releases/download/v0.1.13/logbrew-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "a66feb068052b89a57f5d3d1166677f585b5d63713763db671931e80cd2cac17"
    end
    if Hardware::CPU.intel?
      url "https://github.com/LogBrewCo/cli/releases/download/v0.1.13/logbrew-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "63d96384be59a1569916b5d0870609ad6d3d00aa2cf840ddc5b203a68d17eff2"
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
