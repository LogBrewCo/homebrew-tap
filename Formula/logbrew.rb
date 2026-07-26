class Logbrew < Formula
  desc "Public command-line interface for LogBrew."
  homepage "https://logbrew.co"
  version "0.1.23"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/LogBrewCo/cli/releases/download/v0.1.23/logbrew-cli-aarch64-apple-darwin.tar.xz"
      sha256 "9824a3e161c108b9b7ba323e5b5770ccb1b8e8e77363e7c16e174c0924fcd43c"
    end
    if Hardware::CPU.intel?
      url "https://github.com/LogBrewCo/cli/releases/download/v0.1.23/logbrew-cli-x86_64-apple-darwin.tar.xz"
      sha256 "53cb2b042b6b7c66a0708a20c8bf77ce55b10bdadabe6cf98b5124ce3fc2eae1"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/LogBrewCo/cli/releases/download/v0.1.23/logbrew-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "c56918ebf310513dc1f6e056e9980cc58f3f3dbec5cf61491839185c0b6c1554"
    end
    if Hardware::CPU.intel?
      url "https://github.com/LogBrewCo/cli/releases/download/v0.1.23/logbrew-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "b82cdf86ae2250283e6bbbad7d9646298b7759acf29cd1a36b96793349a5ab86"
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
