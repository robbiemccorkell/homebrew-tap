class Hurl < Formula
  desc "A terminal UI API client for humans"
  homepage "https://github.com/robbiemccorkell/hurl"
  version "0.3.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/robbiemccorkell/hurl/releases/download/v0.3.0/hurl-aarch64-apple-darwin.tar.xz"
      sha256 "b31495b578d8bd50897f44dfc158c8ebf84dab261440b8406e3c5088478bb392"
    end
    if Hardware::CPU.intel?
      url "https://github.com/robbiemccorkell/hurl/releases/download/v0.3.0/hurl-x86_64-apple-darwin.tar.xz"
      sha256 "67464be0655e00bdb1c6ca21d0df623b41e0dcce536aa1394ad746f3b6f7a2bb"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/robbiemccorkell/hurl/releases/download/v0.3.0/hurl-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "569e1835f67aec7677347c154600d280318fd778327cc5ba1b0fe55760a436da"
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
