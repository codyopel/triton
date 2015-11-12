{ fetchurl, stdenv }:

stdenv.mkDerivation rec {
  name = "libffi-3.2.1";

  src = fetchurl {
    url = "ftp://sourceware.org/pub/libffi/${name}.tar.gz";
    sha256 = "0dya49bnhianl0r65m65xndz6ls2jn1xngyn72gd28ls3n7bnvnh";
  };

  configureFlags = [
    "--with-gcc-arch=generic" # no detection of -march= or -mtune=
    "--enable-pax_emutramp"
  ];

  postInstall = ''
    # Install headers in the right place.
    ln -s${if (stdenv.isFreeBSD || stdenv.isOpenBSD) then "" else "r"}v "$out/lib/"libffi*/include "$out/include"
  '';

  # Don't run the native `strip' when cross-compiling.
  dontStrip = stdenv ? cross;

  meta = with stdenv.lib; {
    description = "A foreign function call interface library";
    homepage = http://sourceware.org/libffi/;
    license = licenses.free;
    maintainers = [ ];
    platforms = platforms.all;
  };
}
