{ stdenv, fetchurl, pkgconfig, gnome3, gtk3, flex, bison, libxml2, intltool,
  itstool, python }:

stdenv.mkDerivation rec {
  inherit (import ./src.nix fetchurl) name src;

  enableParallelBuilding = true;

  buildInputs = [ pkgconfig flex bison gtk3 libxml2 gnome3.gjs gnome3.gdl
    gnome3.libgda gnome3.gtksourceview intltool itstool python ];

  meta = with stdenv.lib; {
    description = "Software development studio";
    homepage = http://anjuta.org/;
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
