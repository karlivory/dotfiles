class JetbrainsToolbox < Formula
  desc "Jetbrains Toolbox"
  homepage "https://www.jetbrains.com/toolbox/app/"
  version "2.5.1.34629"
  url "https://download-cdn.jetbrains.com/toolbox/jetbrains-toolbox-#{version}.tar.gz"

  sha256 "a082bb0a0f3d51240ad7cb64c9fe6492cfd17dc22c7cc17695a66f8beaaef6d6"

  def install
    libexec.install Dir["*"]
    bin.install_symlink("#{libexec}/jetbrains-toolbox" => "jetbrains-toolbox")
  end

  test do
    system "#{bin}/jetbrains-toolbox", "--version"
  end
end
