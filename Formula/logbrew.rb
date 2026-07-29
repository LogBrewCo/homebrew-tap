class Logbrew < Formula
  desc "Developer-first observability command-line interface"
  homepage "https://logbrew.co"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/LogBrewCo/cli/releases/download/v0.1.28/logbrew-cli-aarch64-apple-darwin.tar.xz"
      sha256 "d915503682b07541f52852d00f445b56cac97d6ef4606f902e2dc3db32fd3761"
    end
    if Hardware::CPU.intel?
      url "https://github.com/LogBrewCo/cli/releases/download/v0.1.28/logbrew-cli-x86_64-apple-darwin.tar.xz"
      sha256 "90b1a1d6a80e00257bd785ac210c4e125361d67bef5a8a097189f0d0f953119e"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/LogBrewCo/cli/releases/download/v0.1.28/logbrew-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "60b23900f59d0a06caacc89a97a35c4828e7f233194fd764e5d0825c25648631"
    end
    if Hardware::CPU.intel?
      url "https://github.com/LogBrewCo/cli/releases/download/v0.1.28/logbrew-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "b716627ca8dd8771c928d19bca7a1ea665830b7d4463b383e6f0ebf208fe4a20"
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
