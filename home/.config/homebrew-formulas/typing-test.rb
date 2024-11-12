class TypingTest < Formula
  desc "typing test"
  homepage "https://github.com/lemnos/tt"
  url "https://github.com/lemnos/tt/releases/download/v0.4.2/tt-linux"
  version "0.4.2"
  sha256 "46ce8f8fb3e80a394b67004befb6ec4770c61138832e4d91fb807a1a41cfb04e"

  def install
    bin.install "tt-linux" => "typing-test"
  end

  test do
    system "#{bin}/typing-test", "--version"
  end
end

