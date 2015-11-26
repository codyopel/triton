{ stdenv, fetchurl, pkgconfig, gtk3, gnome3, gdk_pixbuf, librsvg
, intltool, itstool, libcanberra_gtk3, libxml2, dconf }:

stdenv.mkDerivation rec {
  inherit (import ./src.nix fetchurl) name src;

  buildInputs = [ pkgconfig gtk3 gnome3.defaultIconTheme gdk_pixbuf librsvg
                  dconf libxml2 libcanberra_gtk3 itstool intltool ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    homepage = https://wiki.gnome.org/Apps/Iagno;
    description = "Computer version of the game Reversi, more popularly called Othello";
    maintainers = gnome3.maintainers;
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
