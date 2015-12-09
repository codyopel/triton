{ fetchurl, stdenv
, pkgconfig
, glib
, dbus_glib
, json_glib
, upower
, libxslt
, intltool
, systemd
, gtk3
, gnome3
, xorg
, mesa_noglu
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
    "--enable-compile-warnings"
    #"--enable-session-selector"
    "--enable-gconf"
    "--enable-systemd"
    "--enable-consolkit"
    "--disable-docbook-doc"
    "--disable-man"
    "--enable-nls"
    "--enable-schemas-compile"
    "--enable-ipv6"
    "--with-xtrans"
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
    systemd
    xorg.libSM
    xorg.libXcomposite
    mesa_noglu
  ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    maintainers = gnome3.maintainers;
    platforms = platforms.linux;
  };
}
