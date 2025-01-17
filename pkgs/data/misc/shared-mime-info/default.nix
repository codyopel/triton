{stdenv, fetchurl
, gettext
, intltool
, pkgconfig

, libxml2
, glib
}:

stdenv.mkDerivation rec {
  name = "shared-mime-info-1.5";

  src = fetchurl {
    url = "http://freedesktop.org/~hadess/${name}.tar.xz";
    sha256 = "1021x95xbkfc5ipx3gi2rdc0y6x2pv36yyzxc5pg6nr6xd02hhfn";
  };

  configureFlags = [
    "--enable-nls"
    "--enable-default-make-check"
    "--disable-update-mimedb"
  ];

  nativeBuildInputs = [
    gettext
    intltool
    pkgconfig
  ];

  buildInputs = [
    glib
    libxml2
  ];

  preFixup = ''
    $out/bin/update-mime-database -V $out/share/mime
  '';

  doCheck = true;
  enableParallelBuilding = false;

  meta = {
    description = "The Shared MIME-info Database specification";
    homepage = http://freedesktop.org/wiki/Software/shared-mime-info;
  };
}
