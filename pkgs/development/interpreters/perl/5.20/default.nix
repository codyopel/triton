{ stdenv, fetchurl

, enableThreading ? stdenv ? glibc
}:

with {
  inherit (stdenv.lib)
    optional
    optionalString;
};

# We can only compile perl with threading on platforms where we have a
# real glibc in the stdenv.
#
# Instead of silently building an unthreaded perl if this is not the
# case, we force callers to disableThreading explicitly, therefore
# documenting the platforms where the perl is not threaded.
#
# In the case of stdenv linux boot stage1 it's not possible to use
# threading because of the simpleness of the bootstrap glibc, so we
# use enableThreading = false there.
assert enableThreading -> (stdenv ? glibc);

let
  libc = if stdenv.cc.libc or null != null then stdenv.cc.libc else "/usr";
in

stdenv.mkDerivation rec {
  name = "perl-5.20.3";

  src = fetchurl {
    url = "mirror://cpan/authors/id/S/SH/SHAY/${name}.tar.gz";
    sha256 = "0jlvpd5l5nk7lzfd4akdg1sw6vinbkj6izclyyr0lrbidfky691m";
  };

  setupHook = ./setup-hook.sh;

  patches = [
    # Do not look in /usr etc. for dependencies.
    ./no-sys-dirs.patch
  ] ++ optional stdenv.isSunOS ./ld-shared.patch;

  postPatch = ''
    patchShebangs Configure

    # configure tests require a static glibc, libpthreads_nonshared.a
    sed -e 's/libswanted="cl pthread/libswanted="cl/' -i Configure
  '';

  configureScript = "./Configure";

  # Build a thread-safe Perl with a dynamic libperls.o.  We need the
  # "installstyle" option to ensure that modules are put under
  # $out/lib/perl5 - this is the general default, but because $out
  # contains the string "perl", Configure would select $out/lib.
  # Miniperl needs -lm. perl needs -lrt.
  configureFlags = [
    "-de"
    "-Dcc=cc"
    "-Uinstallusrbinperl"
    "-Dinstallstyle=lib/perl5"
    "-Duseshrplib"
    "-Dlocincpth=${libc}/include"
    "-Dloclibpth=${libc}/lib"
  ] ++ optional enableThreading "-Dusethreads";

  preConfigure = ''
    configureFlags="$configureFlags -Dprefix=$out -Dman1dir=$out/share/man/man1 -Dman3dir=$out/share/man/man3"

    ${optionalString stdenv.isArm ''
      configureFlagsArray=(-Dldflags="-lm -lrt")
    ''}
  '';

  preBuild = optionalString (!(stdenv ? cc && stdenv.cc.nativeTools)) ''
    # fix hardcoded `/bin/pwd` path
    substituteInPlace dist/PathTools/Cwd.pm \
      --replace "'/bin/pwd'" "'$(type -tP pwd)'"
  '';

  outputs = [ "out" "man" ];

  dontAddPrefix = true;
  enableParallelBuilding = true;

  passthru = {
    libPrefix = "lib/perl5/site_perl";
  };

  meta = with stdenv.lib; {
    description = "The Perl 5 programmming language";
    homepage = https://www.perl.org/;
    maintainers = [ ];
    platforms = platforms.all;
  };
}
