class Yaak < Formula
  desc "yaak"
  homepage "https://github.com/getyaak/app"
  version "2024.11.5"
  url "https://github.com/getyaak/app/releases/download/v#{version}/yaak_#{version}_amd64.AppImage"
  sha256 "3ee87adcfd0b064df2ea08db9b1246fe990823c93b3f5135e7954a5790a1c388"

  def install
    bin.install "yaak_#{version}_amd64.AppImage" => "__appimage_yaak"
  end

  test do
    system "#{bin}/__appimage_yaak", "--appimage-help"
  end
end

