{ stdenv, fetchurl, glib, pkgconfig, gtk3, gnome3, intltool, itstool, libxml2, libarchive
, attr, bzip2, acl, librsvg, gdk_pixbuf }:

stdenv.mkDerivation rec {
  inherit (import ./src.nix fetchurl) name src;

  # TODO: support nautilus
  # it tries to create {nautilus}/lib/nautilus/extensions-3.0/libnautilus-fileroller.so

  buildInputs = [ glib pkgconfig gtk3 intltool itstool libxml2 libarchive
                  gnome3.defaultIconTheme attr bzip2 acl gdk_pixbuf librsvg ];

  meta = with stdenv.lib; {
    homepage = https://wiki.gnome.org/Apps/FileRoller;
    description = "Archive manager for the GNOME desktop environment";
    platforms = platforms.linux;
    maintainers = gnome3.maintainers;
  };
}
