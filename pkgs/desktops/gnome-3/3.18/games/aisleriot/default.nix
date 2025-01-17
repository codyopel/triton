{ stdenv, fetchurl, pkgconfig, gnome3, intltool, itstool, gtk3
, gconf, librsvg, libxml2, desktop_file_utils
, guile, libcanberra_gtk3 }:

stdenv.mkDerivation rec {
  inherit (import ./src.nix fetchurl) name src;

  configureFlags = [ "--with-card-theme-formats=svg" ];

  buildInputs = [ pkgconfig intltool itstool gtk3 gconf
                  librsvg libxml2 desktop_file_utils guile libcanberra_gtk3 ];

  meta = with stdenv.lib; {
    homepage = https://wiki.gnome.org/Apps/Aisleriot;
    description = "A collection of patience games written in guile scheme";
    maintainers = gnome3.maintainers;
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
  };
}
