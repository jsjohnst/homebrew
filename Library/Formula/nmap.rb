require 'formula'

class Nmap < Formula
  homepage "http://nmap.org/"
  head "https://guest:@svn.nmap.org/nmap/", :using => :svn
  url "http://nmap.org/dist/nmap-6.46.tar.bz2"
  sha1 "e19dd4d35d76b24b084665b90c423f53bc7fdcfe"

  bottle do
    sha1 "078e882985fe74919fa280067244a5400ad8ad63" => :mavericks
    sha1 "f0a1dbc5e190c5da169bb6ab22f438a0be3ac845" => :mountain_lion
    sha1 "8617fe3e4e3ddb50902968d8323a4cc9bef92bd1" => :lion
  end

  depends_on "openssl"

  conflicts_with 'ndiff', :because => 'both install `ndiff` binaries'

  fails_with :llvm do
    build 2334
  end

  def install
    ENV.deparallelize

    args = %W[
      --prefix=#{prefix}
      --with-libpcre=included
      --with-liblua=included
      --with-openssl=#{Formula["openssl"].prefix}
      --without-nmap-update
      --without-zenmap
      --disable-universal
    ]

    system "./configure", *args
    system "make" # separate steps required otherwise the build fails
    system "make install"
  end

  def patches
      # The configure script has a C file to test for some functionality that
      # uses void main(void). This does not compile with clang but does compile
      # with GCC/gcc-llvm. This small patch fixes the issues so that the
      # project will compile without issues with clang as well.
      #
      # See: https://github.com/mxcl/homebrew/issues/10300
      DATA
  end
end

__END__
--- nmap-5.51/nbase/configure	2012-02-18 02:40:16.000000000 -0700
+++ nmap-5.51/nbase/configure.old	2012-02-18 02:40:01.000000000 -0700
@@ -4509,7 +4509,7 @@
 #include <sys/socket.h>
 #endif

-void main(void) {
+int main(void) {
     struct addrinfo hints, *ai;
     int error;

@@ -4641,7 +4641,7 @@
 #include <netinet/in.h>
 #endif

-void main(void) {
+int main(void) {
     struct sockaddr_in sa;
     char hbuf[256];
     int error;
