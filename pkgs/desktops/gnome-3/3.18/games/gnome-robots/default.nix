{ stdenv, fetchurl, pkgconfig, gnome3, gtk3
, librsvg, libcanberra_gtk3, intltool, itstool, libxml2 }:

stdenv.mkDerivation rec {
  inherit (import ./src.nix fetchurl) name src;

  buildInputs = [
    pkgconfig gtk3 intltool itstool librsvg libcanberra_gtk3
    libxml2 gnome3.defaultIconTheme
  ];

  meta = with stdenv.lib; {
    homepage = https://wiki.gnome.org/Apps/Robots;
    description = "Avoid the robots and make them crash into each other";
    maintainers = gnome3.maintainers;
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
