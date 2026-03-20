class Hurl < Formula
  desc "A terminal UI API client for humans"
  homepage "https://github.com/robbiemccorkell/hurl"
  version "0.2.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/robbiemccorkell/hurl/releases/download/v0.2.0/hurl-aarch64-apple-darwin.tar.xz"
      sha256 "ec74977a4dd88b478949b19f9c9a1a12d98c92bc99ccf92d3b0ff645313b0c9e"
    end
    if Hardware::CPU.intel?
      url "https://github.com/robbiemccorkell/hurl/releases/download/v0.2.0/hurl-x86_64-apple-darwin.tar.xz"
      sha256 "8cd7edfa737177bb0c4ebc2ef8246e9069938313e3dd60a05212cdf94c177b89"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
      url "https://github.com/robbiemccorkell/hurl/releases/download/v0.2.0/hurl-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "55eba0edaf5f00493730de02cd125ac7e90d1f54df7ffa03ed92be006dee4b17"
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
