class Bruno < Formula
  desc "bruno"
  homepage "https://github.com/usebruno/bruno"
  version "1.34.2"
  url "https://github.com/usebruno/bruno/releases/download/v#{version}/bruno_#{version}_x86_64_linux.AppImage"
  sha256 "efd87a7322190491b58a6c529d7578e37c0ef8fe8733164ea4d7bebf14e4ca67"

  def install
    bin.install "bruno_#{version}_x86_64_linux.AppImage" => "__appimage_bruno"
  end

  test do
    system "#{bin}/__appimage_bruno", "--appimage-help"
  end
end

