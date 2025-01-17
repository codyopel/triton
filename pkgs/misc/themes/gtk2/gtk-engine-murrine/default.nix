{ stdenv, fetchurl, pkgconfig, intltool, gtk2, pixman }:

stdenv.mkDerivation {
  name = "gtk-engine-murrine-0.98.2";

  src = fetchurl {
    url = "mirror://gnome/sources/murrine/0.98/murrine-0.98.2.tar.xz";
    sha256 = "129cs5bqw23i76h3nmc29c9mqkm9460iwc8vkl7hs4xr07h8mip9";
  };

  buildInputs = [ pkgconfig intltool gtk2 pixman ];

  meta = {
    description = "A very flexible theme engine";
    license = stdenv.lib.licenses.lgpl3;
    platforms = stdenv.lib.platforms.linux;
  };
}
