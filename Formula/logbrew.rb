class Logbrew < Formula
  desc "Developer-first observability command-line interface"
  homepage "https://logbrew.co"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/LogBrewCo/cli/releases/download/v0.1.30/logbrew-cli-aarch64-apple-darwin.tar.xz"
      sha256 "332073bc646cc10a3dee4347ccd9f44e3eb81d8e14596f9970e622e97e89941c"
    end
    if Hardware::CPU.intel?
      url "https://github.com/LogBrewCo/cli/releases/download/v0.1.30/logbrew-cli-x86_64-apple-darwin.tar.xz"
      sha256 "84c65282dd67f6d695c766b767c9f9dbbb095f22289070a62b2d4bf028b8fd4d"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/LogBrewCo/cli/releases/download/v0.1.30/logbrew-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "927445aed393391479208151c11ba401cde37048748670fc0f277a4ae3533ca3"
    end
    if Hardware::CPU.intel?
      url "https://github.com/LogBrewCo/cli/releases/download/v0.1.30/logbrew-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "6cb97b16333ac73eb4c665b397ce2fd60f1003e88b3b8b4357b1ef242bf4bd22"
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
