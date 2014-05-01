require 'formula'

class Autoconf < Formula
  homepage 'http://www.gnu.org/software/autoconf'
  url 'http://ftpmirror.gnu.org/autoconf/autoconf-2.69.tar.gz'
  mirror 'http://ftp.gnu.org/gnu/autoconf/autoconf-2.69.tar.gz'
  sha1 '562471cbcb0dd0fa42a76665acf0dbb68479b78a'

  bottle do
    revision 1
    sha1 "319a4ac05d83b5b3db37dcc629a46a412ec1989b" => :mavericks
    sha1 "83184a596d69f3a868e6780c1c8fba309ea28fb2" => :mountain_lion
    sha1 "7d31f63e5ddd1bbbf0397b0b70df1ff9e70f998b" => :lion
  end

  keg_only :provided_until_xcode43

  def install
    ENV['PERL'] = '/usr/bin/perl'

    # force autoreconf to look for and use our glibtoolize
    inreplace 'bin/autoreconf.in', 'libtoolize', 'glibtoolize'
    # also touch the man page so that it isn't rebuilt
    inreplace 'man/autoreconf.1', 'libtoolize', 'glibtoolize'
    system "./configure", "--prefix=#{prefix}"
    system "make install"
    rm_f info/'standards.info'
  end

  test do
    cp "#{share}/autoconf/autotest/autotest.m4", 'autotest.m4'
    system "#{bin}/autoconf", 'autotest.m4'
  end
end


__END__
--- a/bin/autoreconf.in	2012-04-24 15:00:28.000000000 -0700
+++ b/bin/autoreconf.in	2012-04-24 21:51:41.000000000 -0700
@@ -111,7 +111,7 @@
 my $autom4te   = $ENV{'AUTOM4TE'}   || '@bindir@/@autom4te-name@';
 my $automake   = $ENV{'AUTOMAKE'}   || 'automake';
 my $aclocal    = $ENV{'ACLOCAL'}    || 'aclocal';
-my $libtoolize = $ENV{'LIBTOOLIZE'} || 'libtoolize';
+my $libtoolize = $ENV{'LIBTOOLIZE'} || 'glibtoolize';
 my $autopoint  = $ENV{'AUTOPOINT'}  || 'autopoint';
 my $make       = $ENV{'MAKE'}       || 'make';

