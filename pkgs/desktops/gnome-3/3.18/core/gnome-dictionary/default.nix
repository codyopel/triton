{ stdenv, intltool, fetchurl
, pkgconfig, gtk3, glib
, bash, itstool, libxml2
, gnome3, librsvg, gdk_pixbuf, file }:

stdenv.mkDerivation rec {
  inherit (import ./src.nix fetchurl) name src;

  doCheck = true;

  NIX_CFLAGS_COMPILE = "-I${gnome3.glib}/include/gio-unix-2.0";

  propagatedUserEnvPkgs = [ gnome3.gnome_themes_standard ];
  propagatedBuildInputs = [ gdk_pixbuf gnome3.defaultIconTheme librsvg ];

  buildInputs = [ pkgconfig gtk3 glib intltool itstool libxml2 file
                  gnome3.gsettings_desktop_schemas ];

  meta = with stdenv.lib; {
    homepage = https://wiki.gnome.org/Apps/Dictionary;
    description = "Dictionary is the GNOME application to look up definitions";
    maintainers = gnome3.maintainers;
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
