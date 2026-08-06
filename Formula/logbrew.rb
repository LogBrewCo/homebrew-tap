class Logbrew < Formula
  desc "Developer-first observability command-line interface"
  homepage "https://logbrew.co"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/LogBrewCo/cli/releases/download/v0.1.33/logbrew-cli-aarch64-apple-darwin.tar.xz"
      sha256 "2df96ace63a08418e28a9bb166f9272928e0bb255afa58a403e1a0c14e136186"
    end
    if Hardware::CPU.intel?
      url "https://github.com/LogBrewCo/cli/releases/download/v0.1.33/logbrew-cli-x86_64-apple-darwin.tar.xz"
      sha256 "766c97510b53fc7f631bd17a9eb7509bc9285f6a96952233ca62f467776d13ee"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/LogBrewCo/cli/releases/download/v0.1.33/logbrew-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "e3b27f49ff87b29cdddb3fbe912d91f43afd69f5bd58f786f217334aad76adfa"
    end
    if Hardware::CPU.intel?
      url "https://github.com/LogBrewCo/cli/releases/download/v0.1.33/logbrew-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "5e3b4f25123d4d024baed4630547454689448f5a01c519e1693f14efdb9e60fe"
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
    bin.install "logbrew" if OS.mac? && Hardware::CPU.arm?
    bin.install "logbrew" if OS.mac? && Hardware::CPU.intel?
    bin.install "logbrew" if OS.linux? && Hardware::CPU.arm?
    bin.install "logbrew" if OS.linux? && Hardware::CPU.intel?

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
