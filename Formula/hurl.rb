class Hurl < Formula
  desc "A terminal UI API client for humans"
  homepage "https://github.com/robbiemccorkell/hurl"
  version "0.3.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/robbiemccorkell/hurl/releases/download/v0.3.1/hurl-aarch64-apple-darwin.tar.xz"
      sha256 "47c5cc245baeb419bdcd946b4bbbf5c7e020e8ffdb6979c6510813060b7b64bf"
    end
    if Hardware::CPU.intel?
      url "https://github.com/robbiemccorkell/hurl/releases/download/v0.3.1/hurl-x86_64-apple-darwin.tar.xz"
      sha256 "9990696acc58b52087cf1d1a7e03d852e486e772bbef4d05734d0c4391307191"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/robbiemccorkell/hurl/releases/download/v0.3.1/hurl-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "ae116260777d257f6a5b20cf613c97170b7495864ec819abaca356d0896a14c9"
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
