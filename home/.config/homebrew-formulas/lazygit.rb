class Lazygit < Formula
  desc "lazygit"
  homepage "https://github.com/jesseduffield/lazygit"
  version "0.57.0"
  url "https://github.com/jesseduffield/lazygit/releases/download/v0.57.0/lazygit_0.57.0_linux_x86_64.tar.gz"
  # sha256 "efd87a7322190491b58a6c529d7578e37c0ef8fe8733164ea4d7bebf14e4ca67"

  def install
    bin.install "lazygit" => "lazygit"
  end

  test do
    system "#{bin}/lazygit", "--version"
  end
end

