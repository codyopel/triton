{ stdenv, intltool, fetchurl, libgweather, libnotify
, pkgconfig, gtk3, glib, gsound
, itstool, libcanberra_gtk3, libtool
, gnome3, librsvg, gdk_pixbuf, geoclue2
, libxml2
}:

stdenv.mkDerivation rec {
  inherit (import ./src.nix fetchurl) name src;

  doCheck = true;

  buildInputs = [ pkgconfig gtk3 glib intltool itstool libcanberra_gtk3
                  gnome3.gsettings_desktop_schemas
                  gdk_pixbuf gnome3.defaultIconTheme librsvg
                  gnome3.gnome_desktop gnome3.geocode_glib geoclue2
                  libgweather libnotify libtool gsound
                  libxml2
  ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    homepage = https://wiki.gnome.org/Apps/Clocks;
    description = "Clock application designed for GNOME 3";
    maintainers = gnome3.maintainers;
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
