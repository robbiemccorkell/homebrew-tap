class Hurl < Formula
  desc "A terminal UI API client for humans"
  homepage "https://github.com/robbiemccorkell/hurl"
  version "0.1.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/robbiemccorkell/hurl/releases/download/v0.1.0/hurl-aarch64-apple-darwin.tar.xz"
      sha256 "51707256c0755df0d17551629dac0b9d4f740955d9e7a3b02d345bde1c8d0856"
    end
    if Hardware::CPU.intel?
      url "https://github.com/robbiemccorkell/hurl/releases/download/v0.1.0/hurl-x86_64-apple-darwin.tar.xz"
      sha256 "5f485e5b7d502d81f0bbe6bd8146cc3c61d2ff46bf6b33dad5d10de15c5de137"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
      url "https://github.com/robbiemccorkell/hurl/releases/download/v0.1.0/hurl-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "3df68b4a92abf6e1c3ca9990826164ba23fcbfd5c9f66601d4c24cbfed410bec"
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
