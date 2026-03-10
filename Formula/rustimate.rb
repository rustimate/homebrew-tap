class Rustimate < Formula
  desc "Cinematic DSL renderer for code and terminal videos"
  homepage "https://qubitai.in/rustimate.html`"
  url "https://github.com/rustimate/rustimate/releases/download/v0.1.0/rustimate-macos.tar.gz"
  sha256 "c9683b8c3c3b6ba1cb45cd74dbc384040f53b79f7b377cf07339be1d9b5d4aee"
  license "Commercial"

  def install
    bin.install "rustimate"
  end

  test do
    system "#{bin}/rustimate", "--version"
  end
end
