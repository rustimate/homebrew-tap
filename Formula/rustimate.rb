class Rustimate < Formula
  desc "Cinematic DSL renderer for code and terminal videos"
  homepage "https://qubitai.in/rustimate.html"
  license "Commercial"

  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/rustimate/rustimate/releases/download/v0.1.0/rustimate-macos-aarch64.tar.gz"
      sha256 "fdcb1c1be43acc31532f8e6f2fdd5685a281d85ad17abcdd3f1bef8e3d56306a"
    else
      url "https://github.com/rustimate/rustimate/releases/download/v0.1.0/rustimate-macos-x86_64.tar.gz"
      sha256 "3ee68694b62b6a9d076035a45bd0fbf70a57f94c76eee3d07c505a37c469593c"
    end
  elsif OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/rustimate/rustimate/releases/download/v0.1.0/rustimate-linux-aarch64.tar.gz"
      sha256 "8255a7597624b9d46b17ea0befe92eeb1fa037e8e019fbf2bd0b813c63240fe1"
    else
      url "https://github.com/rustimate/rustimate/releases/download/v0.1.0/rustimate-linux-x86_64.tar.gz"
      sha256 "34a0822c99cda51566853183fa27cb049ce8f67cd9a0486ec83ae8725825904d"
    end
  end

  def install
    bin.install "rustimate"
  end

  test do
    system "#{bin}/rustimate", "--version"
  end
end
