# source: https://www.jetbrains.com/toolbox-app/download/download-thanks.html?platform=linux
class JetbrainsToolbox < Formula
  desc "Jetbrains Toolbox"
  homepage "https://www.jetbrains.com/toolbox/app/"
  version "3.1.2.64642"
  url "https://download.jetbrains.com/toolbox/jetbrains-toolbox-#{version}.tar.gz"

  # sha256 "a082bb0a0f3d51240ad7cb64c9fe6492cfd17dc22c7cc17695a66f8beaaef6d6"

  def install
    libexec.install Dir["*"]
    bin.install_symlink("#{libexec}/bin/jetbrains-toolbox" => "jetbrains-toolbox")
  end

  test do
    system "#{bin}/jetbrains-toolbox", "--version"
  end
end
