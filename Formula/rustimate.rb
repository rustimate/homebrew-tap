class Rustimate < Formula
  desc "Cinematic DSL renderer for code and terminal videos"
  homepage "https://qubitai.in/rustimate.html"
  license "Commercial"

  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/rustimate/rustimate/releases/download/v0.1.0/rustimate-macos-aarch64.tar.gz"
      sha256 "ac62178db5098f818a448254b8030656429c071203858a1aa50495ab89a7d77c"
    else
      url "https://github.com/rustimate/rustimate/releases/download/v0.1.0/rustimate-macos-x86_64.tar.gz"
      sha256 "5c7165bf82d77cf5affa8eea469b3f74f2f11882a6ae3d143e5a26a0b39e93b4"
    end
  elsif OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/rustimate/rustimate/releases/download/v0.1.0/rustimate-linux-aarch64.tar.gz"
      sha256 "3f8262e6601194fda806e0207f08f257d4b4c638a7cdb864f4ca1c8daac54cb8"
    else
      url "https://github.com/rustimate/rustimate/releases/download/v0.1.0/rustimate-linux-x86_64.tar.gz"
      sha256 "9425ad4af9f38d20f06a0538744ab13f6a6fefc0021e1b409b70d5e3f2c65bd2"
    end
  end

  def install
    bin.install "rustimate"
  end

  test do
    system "#{bin}/rustimate", "--version"
  end
end
