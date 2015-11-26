{ stdenv, intltool, fetchurl, python
, pkgconfig, gtk3, glib
, itstool, libxml2, docbook_xsl
, gnome3, librsvg, gdk_pixbuf, libxslt }:

stdenv.mkDerivation rec {
  inherit (import ./src.nix fetchurl) name src;

  propagatedUserEnvPkgs = [ gnome3.gnome_themes_standard ];

  buildInputs = [ pkgconfig gtk3 glib intltool itstool libxml2 python
                  gnome3.gsettings_desktop_schemas docbook_xsl
                  gdk_pixbuf gnome3.defaultIconTheme librsvg libxslt ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    homepage = https://wiki.gnome.org/Apps/Glade;
    description = "User interface designer for GTK+ applications";
    maintainers = gnome3.maintainers;
    license = licenses.lgpl2;
    platforms = platforms.linux;
  };
}
