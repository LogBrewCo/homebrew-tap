class Logbrew < Formula
  desc "Developer-first observability command-line interface"
  homepage "https://logbrew.co"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/LogBrewCo/cli/releases/download/v0.1.47/logbrew-cli-aarch64-apple-darwin.tar.xz"
      sha256 "206ba0e936d1f7b8f8815fdf5533f6f81706cfa5910b93dcee272a8c81f539e2"
    end
    if Hardware::CPU.intel?
      url "https://github.com/LogBrewCo/cli/releases/download/v0.1.47/logbrew-cli-x86_64-apple-darwin.tar.xz"
      sha256 "3dbe5c1755fa33eb31ddafffd22ec1b06c8d3de6cb0b18cf42f861caf699e30d"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/LogBrewCo/cli/releases/download/v0.1.47/logbrew-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "8cd6e78d8e4690f4685e7f62b8e356c0aee066a456f2fdcf4a2bb4d587eed3d3"
    end
    if Hardware::CPU.intel?
      url "https://github.com/LogBrewCo/cli/releases/download/v0.1.47/logbrew-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "7ef333ec81af51ca615c0ef143f22848b97b37f1eaff3dc6ce0c877fd49e8531"
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
