require 'formula'

class Play < Formula
  homepage 'http://www.playframework.org/'
  head 'https://github.com/playframework/playframework.git'
  url 'http://downloads.typesafe.com/play/2.2.2/play-2.2.2.zip'
  sha1 '9a2fa3c6b9ee36375d814d775bec4335e427dcd2'

  conflicts_with 'sox', :because => 'both install `play` binaries'

  devel do
    url 'http://downloads.typesafe.com/play/2.2.3-RC2/play-2.2.3-RC2.zip'
    sha1 '0b1fa38fbcab0ae84ab96c9cbd8c4d0dd66e6fec'
  end

  def install
    system "./framework/build", "publish-local" if build.head?

    # remove Windows .bat files
    rm Dir['*.bat']
    rm Dir["#{buildpath}/**/*.bat"] if build.head?

    libexec.install Dir['*']
    bin.install_symlink libexec/'play'
  end
end
