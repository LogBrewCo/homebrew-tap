class Logbrew < Formula
  desc "Developer-first observability command-line interface"
  homepage "https://logbrew.co"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/LogBrewCo/cli/releases/download/v0.1.84/logbrew-cli-aarch64-apple-darwin.tar.xz"
      sha256 "1b7d1bb1eac85046001c03e3d86783c755603827b8a57d9471d5d9ae33eb94e0"
    end
    if Hardware::CPU.intel?
      url "https://github.com/LogBrewCo/cli/releases/download/v0.1.84/logbrew-cli-x86_64-apple-darwin.tar.xz"
      sha256 "0e4d59f277951fb0fdf2fa67985697ed619df9ccff83ac409ff7e6b5ad436209"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/LogBrewCo/cli/releases/download/v0.1.84/logbrew-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "e5fe75c3e47164fd5ab68eef1c7bccf8f9574946c2a66ff3710d901a4ed66b92"
    end
    if Hardware::CPU.intel?
      url "https://github.com/LogBrewCo/cli/releases/download/v0.1.84/logbrew-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "f4924872d66be54feb976df3cdd9eb4b3b670d0298c9a6238573ac64a2d997eb"
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
