class Rustimate < Formula
  desc "Cinematic DSL renderer for code and terminal videos"
  homepage "https://qubitai.in/rustimate.html"
  license "Commercial"

  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/rustimate/rustimate/releases/download/v0.1.0/rustimate-macos-aarch64.tar.gz"
      sha256 "4766082da53780ab5cc044b3ef5d6c312363745568d6f5d30602ec22fc8f95fa"
    else
      url "https://github.com/rustimate/rustimate/releases/download/v0.1.0/rustimate-macos-x86_64.tar.gz"
      sha256 "fcb8d4b9b83e83a83096382e4b9d5212e3ff3cd9420aaf7fe3aa1ffb1cad697e"
    end
  elsif OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/rustimate/rustimate/releases/download/v0.1.0/rustimate-linux-aarch64.tar.gz"
      sha256 "49edf839df77237c676fa920ce068ca750547c7f3f9122eccb6f035fdc4018d7"
    else
      url "https://github.com/rustimate/rustimate/releases/download/v0.1.0/rustimate-linux-x86_64.tar.gz"
      sha256 "38840c27bf04c6411ccfb714fb7965d9a8a7c8c1b91df091f6fd91a210247034"
    end
  end

  def install
    bin.install "rustimate"
  end

  test do
    system "#{bin}/rustimate", "--version"
  end
end
