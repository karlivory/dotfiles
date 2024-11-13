class Insomnia < Formula
  desc "insomnia"
  homepage "https://github.com/Kong/insomnia"
  version "10.1.1"
  url "https://github.com/Kong/insomnia/releases/download/core@#{version}/Insomnia.Core-#{version}.AppImage"
  sha256 "0e054aef334fe93fb6c6b1f3be7704b330500876eb757bd251cc8b72f2907a9a"

  def install
    bin.install "Insomnia.Core-#{version}.AppImage" => "__appimage_insomnia"
  end

  test do
    system "#{bin}/__appimage_insomnia", "--appimage-help"
  end
end

