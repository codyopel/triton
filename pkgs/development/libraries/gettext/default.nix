{ stdenv, fetchurl
, libiconv
, libintlOrEmpty
, xz
}:

with {
  inherit (stdenv)
    isSunOS;
  inherit (stdenv.lib)
    optionals
    optionalString;
};

stdenv.mkDerivation rec {
  name = "gettext-0.19.6";

  src = fetchurl {
    url = "mirror://gnu/gettext/${name}.tar.gz";
    sha256 = "0pb9vp4ifymvdmc31ks3xxcnfqgzj8shll39czmk8c1splclqjzd";
  };

  LDFLAGS = optionals isSunOS [
    "-lm"
    "-lmd"
    "-lmp"
    "-luutil"
    "-lnvpair"
    "-lnsl"
    "-lidmap"
    "-lavl"
    "-lsec"
  ];

  configureFlags = [
    "--disable-java"
    "--disable-native-java"
    "--disable-csharp"
    "--enable-largefile"
    "--enable-threads=${if isSunOS then "solaris" else "posix"}"
    "--enable-nls"
    "--enable-rpath"
    "--enable-c++"
    "--enable-relocatable"
    "--enable-libasprintf"
    "--disable-acl"
    "--enable-openmp"
    "--disable-curses"
    "--without-included-gettext"
    # glib depends on gettext so avoid circular deps
    "--with-included-glib"
    # libcroco depends on glib which ... ^^^
    "--with-included-libcroco"
    # this will _disable_ libunistring (since it is not bundled),
    # see gentoo bug #326477
    "--with-included-linunistring"
    "--with-included-libxml"
    "--with-included-libxml2"
    "--with-emacs"
    "--without-git"
    "--without-cvs"
    "--without-bzip2"
    "--with-xz"
  ];

  # On cross building, gettext supposes that the wchar.h from libc
  # does not fulfill gettext needs, so it tries to work with its
  # own wchar.h file, which does not cope well with the system's
  # wchar.h and stddef.h (gcc-4.3 - glibc-2.9)
  preConfigure = ''
    if test -n "$crossConfig"; then
      echo gl_cv_func_wcwidth_works=yes > cachefile
      configureFlags="$configureFlags --cache-file=`pwd`/cachefile"
    fi
  '';

  buildInputs = [
    libiconv
    xz
  ] ++ libintlOrEmpty;

  outputs = [ "out" "doc" ];

  crossAttrs = {
    buildInputs = stdenv.lib.optional (stdenv ? ccCross && stdenv.ccCross.libc ? libiconv)
      stdenv.ccCross.libc.libiconv.crossDrv;
    # Gettext fails to guess the cross compiler
    configureFlags = "CXX=${stdenv.cross.config}-g++";
  };

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "Well integrated set of translation tools and documentation";
    homepage = http://www.gnu.org/software/gettext/;
    maintainers = [ ];
    platforms = platforms.all;
  };
}
