{ fetchurl, stdenv
, pkgconfig

, ghostscript
}:

stdenv.mkDerivation rec {
  name = "libspectre-0.2.7";

  src = fetchurl {
    url = "http://libspectre.freedesktop.org/releases/${name}.tar.gz";
    sha256 = "1v63lqc6bhhxwkpa43qmz8phqs8ci4dhzizyy16d3vkb20m846z8";
  };

  nativeBuildInputs = [
    pkgconfig
  ];

  buildInputs = [
    ghostscript
  ];

  doCheck = false;
  enableParallelBuilding = true;

  meta = {
    description = "PostScript rendering library";
    homepage = http://libspectre.freedesktop.org/;
    license = stdenv.lib.licenses.gpl2Plus;
  };
}
