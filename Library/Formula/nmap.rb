require 'formula'

class Nmap < Formula
  homepage 'http://nmap.org/6/'
  url 'http://nmap.org/dist/nmap-6.01.tar.bz2'
  sha1 'e397e453893930d14e9bb33a847d15b94b7ee83a'

  head 'https://guest:@svn.nmap.org/nmap/', :using => :svn

  # Leopard's version of OpenSSL isn't new enough
  depends_on "openssl" if MacOS.version == :leopard

  fails_with :llvm do
    build 2334
  end

  def install
    ENV.deparallelize

    args = %W[--prefix=#{prefix}
              --with-libpcre=included
              --with-liblua=included
              --without-zenmap
              --disable-universal]

    if MacOS.version == :leopard
      openssl = Formula.factory('openssl')
      args << "--with-openssl=#{openssl.prefix}"
    end

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
