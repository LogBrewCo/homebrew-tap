class Logbrew < Formula
  desc "Developer-first observability command-line interface"
  homepage "https://logbrew.co"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/LogBrewCo/cli/releases/download/v0.1.62/logbrew-cli-aarch64-apple-darwin.tar.xz"
      sha256 "3a24f55bcd063aa584c24b813b34526888f65bc5ca09be82f0acc65c3c7ec7d9"
    end
    if Hardware::CPU.intel?
      url "https://github.com/LogBrewCo/cli/releases/download/v0.1.62/logbrew-cli-x86_64-apple-darwin.tar.xz"
      sha256 "639ba22c90db7e8964db10d00e6faabf6a7ea89fcc258f9de026d8137eb23237"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/LogBrewCo/cli/releases/download/v0.1.62/logbrew-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "b8f03ccea3ec2fc077c53fd0d41974f6e47b428cfd986624e4628b015c21d1dd"
    end
    if Hardware::CPU.intel?
      url "https://github.com/LogBrewCo/cli/releases/download/v0.1.62/logbrew-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "21d45659860cd12f2dd5b80a2e1df35410b7f5cfaaf55a968fc3f4da41b32d9b"
    end
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-apple-darwin":       {},
    "x86_64-pc-windows-gnu":     {},
    "x86_64-unknown-linux-gnu":  {},
  }.freeze

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

  test do
    assert_match version.to_s, shell_output("#{bin}/logbrew version")
  end
end
