{ stdenv, intltool, fetchurl, gdk_pixbuf, tracker
, python3, libxml2, python3Packages, libnotify
, pkgconfig, gtk3, glib, cairo
, itstool, gnome3, librsvg, gst_all_1 }:

stdenv.mkDerivation rec {
  inherit (import ./src.nix fetchurl) name src;

  propagatedUserEnvPkgs = [ gnome3.gnome_themes_standard ];

  buildInputs = [ pkgconfig gtk3 glib intltool itstool gnome3.libmediaart
                  gdk_pixbuf gnome3.defaultIconTheme librsvg python3
                  gnome3.grilo gnome3.grilo-plugins libxml2
                  python3Packages.pygobject libnotify
                  python3Packages.pycairo python3Packages.dbus gnome3.totem-pl-parser
                  gst_all_1.gstreamer gst_all_1.gst-plugins-base
                  gst_all_1.gst-plugins-good gst_all_1.gst-plugins-bad
                  gnome3.gsettings_desktop_schemas tracker ];

  wrapPrefixVariables = [ "PYTHONPATH" ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    homepage = https://wiki.gnome.org/Apps/Music;
    description = "Music player and management application for the GNOME desktop environment";
    maintainers = gnome3.maintainers;
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
