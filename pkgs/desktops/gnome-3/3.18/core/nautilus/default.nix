{ stdenv, fetchurl, pkgconfig, libxml2, dbus_glib, shared_mime_info, libexif
, gtk, gnome3, libunique, intltool, gobjectIntrospection
, libnotify, exempi, librsvg, tracker
, xorg
}:

stdenv.mkDerivation rec {
  name = "nautilus-${version}";
  versionMajor = "3.18";
  versionMinor = "2";
  version = "${versionMajor}.${versionMinor}";

  src = fetchurl {
    url = "mirror://gnome/sources/nautilus/${versionMajor}/${name}.tar.xz";
    sha256 = "0jj23n8vmmyc4gp5xhiz7slsxwksydp26blxi5m154yaw9lgdp38";
  };

  buildInputs = [
    pkgconfig libxml2 dbus_glib shared_mime_info libexif gtk libunique intltool
    exempi librsvg
    gnome3.gnome_desktop gnome3.adwaita-icon-theme
    gnome3.gsettings_desktop_schemas libnotify tracker
    xorg.libICE xorg.libSM
  ];

  patches = [ ./extension_dir.patch ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    platforms = platforms.linux;
    maintainers = gnome3.maintainers;
  };
}
