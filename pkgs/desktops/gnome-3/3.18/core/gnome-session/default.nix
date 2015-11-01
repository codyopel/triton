{ fetchurl, stdenv
, pkgconfig
, glib
, dbus_glib
, json_glib
, upower
, libxslt
, intltool
, makeWrapper
, systemd
, xorg
, gtk3
, gnome3
}:

stdenv.mkDerivation rec {
  name = "gnome-session-${version}";
  versionMajor = "3.18";
  versionMinor = "1.2";
  version = "${versionMajor}.${versionMinor}";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-session/${versionMajor}/${name}.tar.xz";
    sha256 = "0icajbzqf5llvp5s8nafwkhwz6a6jmwn4hhs81bk0bpzawyq4zdk";
  };

  configureFlags = [
    "--enable-systemd"
  ];

  buildInputs = [
    pkgconfig
    glib
    gnome3.gnome_desktop
    gtk3
    dbus_glib
    json_glib
    libxslt
    gnome3.gnome_settings_daemon
    xorg.xtrans
    gnome3.defaultIconTheme
    gnome3.gsettings_desktop_schemas
    upower
    intltool
    gnome3.gconf
    makeWrapper
    systemd
  ];

  preFixup = ''
    wrapProgram "$out/bin/gnome-session" \
      --prefix GI_TYPELIB_PATH : "$GI_TYPELIB_PATH" \
      --suffix XDG_DATA_DIRS : "$out/share:$GSETTINGS_SCHEMAS_PATH"
  '';

  meta = with stdenv.lib; {
    maintainers = gnome3.maintainers;
    platforms = platforms.linux;
  };
}
