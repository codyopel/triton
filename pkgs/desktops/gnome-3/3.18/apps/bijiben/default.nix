{ stdenv, intltool, fetchurl, pkgconfig, glib
, evolution_data_server, evolution, sqlite
, itstool, desktop_file_utils
, clutter_gtk, libuuid, webkitgtk, zeitgeist
, gnome3, librsvg, gdk_pixbuf, libxml2, libsoup }:

stdenv.mkDerivation rec {
  inherit (import ./src.nix fetchurl) name src;

  doCheck = true;

  propagatedUserEnvPkgs = [ gnome3.gnome_themes_standard ];

  buildInputs = [ pkgconfig glib intltool itstool libxml2
                  clutter_gtk libuuid webkitgtk gnome3.tracker
                  gnome3.gnome_online_accounts zeitgeist desktop_file_utils
                  gnome3.gsettings_desktop_schemas
                  gdk_pixbuf gnome3.defaultIconTheme librsvg
                  evolution_data_server evolution sqlite libsoup ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    homepage = https://wiki.gnome.org/Apps/Bijiben;
    description = "Note editor designed to remain simple to use";
    maintainers = gnome3.maintainers;
    license = licenses.gpl3;
    platforms = platforms.linux;
  };
}
