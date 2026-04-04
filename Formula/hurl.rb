class Hurl < Formula
  desc "A terminal UI API client for humans"
  homepage "https://github.com/robbiemccorkell/hurl"
  version "0.3.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/robbiemccorkell/hurl/releases/download/v0.3.2/hurl-aarch64-apple-darwin.tar.xz"
      sha256 "2c6de22861eb2747e2d8ccefd25d6d7e966f144a1656bf36d6b7d21f1fadcc04"
    end
    if Hardware::CPU.intel?
      url "https://github.com/robbiemccorkell/hurl/releases/download/v0.3.2/hurl-x86_64-apple-darwin.tar.xz"
      sha256 "cc0f4ac737cdce3500b852d2c3d27d3f49a83ead1198c7345c86bb08c00612f2"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/robbiemccorkell/hurl/releases/download/v0.3.2/hurl-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "fa5e89d6a39d5c6a7da64bf4107906ad3dbd43a66ae394299c3e35a570a392e4"
  end

  BINARY_ALIASES = {
    "aarch64-apple-darwin":     {},
    "x86_64-apple-darwin":      {},
    "x86_64-pc-windows-gnu":    {},
    "x86_64-unknown-linux-gnu": {},
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
    bin.install "hurl" if OS.mac? && Hardware::CPU.arm?
    bin.install "hurl" if OS.mac? && Hardware::CPU.intel?
    bin.install "hurl" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
