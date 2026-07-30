class Logbrew < Formula
  desc "Developer-first observability command-line interface"
  homepage "https://logbrew.co"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/LogBrewCo/cli/releases/download/v0.1.29/logbrew-cli-aarch64-apple-darwin.tar.xz"
      sha256 "0521c9ce801cceb3cb9ebf27cd7c1b4087f49ec951d90d45acba1c33012f2ed8"
    end
    if Hardware::CPU.intel?
      url "https://github.com/LogBrewCo/cli/releases/download/v0.1.29/logbrew-cli-x86_64-apple-darwin.tar.xz"
      sha256 "0f0f43dee49c3e6b383e203645518ec7a7d56858f1978f60b76e7d50bd21fac8"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/LogBrewCo/cli/releases/download/v0.1.29/logbrew-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "9cd14f8119d7f39f8fcf928b84a3a1f3c00f1290c0e425d2d98fb810ef53f02a"
    end
    if Hardware::CPU.intel?
      url "https://github.com/LogBrewCo/cli/releases/download/v0.1.29/logbrew-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "5513bd607c33340b0432850114b6cce5da7e0e46ae07f8340f354108980c48bb"
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
