class Logbrew < Formula
  desc "Public command-line interface for LogBrew."
  homepage "https://logbrew.co"
  version "0.1.7"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/LogBrewCo/cli/releases/download/v0.1.7/logbrew-cli-aarch64-apple-darwin.tar.xz"
      sha256 "e3a2797fbf1f48291daec2e4135a4084464a310765b9b46603aedcb891de994c"
    end
    if Hardware::CPU.intel?
      url "https://github.com/LogBrewCo/cli/releases/download/v0.1.7/logbrew-cli-x86_64-apple-darwin.tar.xz"
      sha256 "210a7ca39cb3b4471044758b263ac4e96ad60db6ee3811bcae143f896c944fca"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/LogBrewCo/cli/releases/download/v0.1.7/logbrew-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "c03ba0403bd1ba8d7f47dc041185c748f5873a59b00b7e72db80b6c2af559720"
    end
    if Hardware::CPU.intel?
      url "https://github.com/LogBrewCo/cli/releases/download/v0.1.7/logbrew-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "2ae59862713e108c0e502ec9cc6c736cc168a723a3612b7b62c856312d5248d4"
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
