class Logbrew < Formula
  desc "Developer-first observability command-line interface"
  homepage "https://logbrew.co"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/LogBrewCo/cli/releases/download/v0.1.35/logbrew-cli-aarch64-apple-darwin.tar.xz"
      sha256 "81a61ac26f499f5f5169920757b2b4a1dfff90f2f36dd5dd83137ae7d744552a"
    end
    if Hardware::CPU.intel?
      url "https://github.com/LogBrewCo/cli/releases/download/v0.1.35/logbrew-cli-x86_64-apple-darwin.tar.xz"
      sha256 "9ebfea47c6d79f467306b64ba504610df9282ca5476f0c9b25859ca2b21c7b88"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/LogBrewCo/cli/releases/download/v0.1.35/logbrew-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "0003bcde7bca40294a059fd830b01fc639b0efde1b49058fab6ec7948eaed9aa"
    end
    if Hardware::CPU.intel?
      url "https://github.com/LogBrewCo/cli/releases/download/v0.1.35/logbrew-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "b09a6344ba144d372cfafcb10eea9b0993ae153f6ccb1f605d3242ad7e756cca"
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
