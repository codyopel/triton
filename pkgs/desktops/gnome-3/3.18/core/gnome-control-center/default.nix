{ stdenv, fetchurl
, pkgconfig
, gnome3
, ibus
, intltool
, upower
, libcanberra_gtk3
, accountsservice
, libpwquality
, libpulseaudio
, gdk_pixbuf
, librsvg
, libxkbfile
, libnotify
, libxml2
, polkit
, libxslt
, libgtop
, libsoup
, colord
, colord-gtk
, cracklib
, python
, libkrb5
, networkmanagerapplet
, networkmanager
, libwacom
, samba
, shared_mime_info
, tzdata
, icu
, libtool
, udev
, libgudev
, docbook_xsl
, docbook_xsl_ns
, modemmanager
, clutter
, clutter_gtk
, fontconfig
, sound-theme-freedesktop
, cups
, xorg
}:

# http://ftp.gnome.org/pub/GNOME/teams/releng/3.10.2/gnome-suites-core-3.10.2.modules
# TODO: bluetooth, wacom, printers

stdenv.mkDerivation rec {
  name = "gnome-control-center-${version}";
  versionMajor = "3.18";
  versionMinor = "2";
  version = "${versionMajor}.${versionMinor}";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-control-center/${versionMajor}/${name}.tar.xz";
    sha256 = "1bgqg1sl3cp2azrwrjgwx3jzk9n3w76xpcyvk257qavx4ibn3zin";
  };

  patches = [
    ./vpn_plugins_path.patch
  ];

  postPatch = ''
    # Patch path to gnome version file
    sed -e 's|DATADIR "/gnome/gnome-version.xml"|"${gnome3.gnome_desktop}/share/gnome/gnome-version.xml"|' \
      -i panels/info/cc-info-panel.c
  '';

  configureFlags = [
    "--disable-maintainer-mode"
    "--disable-debug"
    "--enable-compile-warnings"
    "--enable-nls"
    "--disable-documentation"
    "--enable-ibus"
    "--enable-cups"
    "--disable-update-mimedb"
    "--disable-more-warnings"
    "--with-x"
    "--without-cheese"
  ];

  propagatedUserEnvPkgs = [
    gnome3.gnome_themes_standard
    gnome3.libgnomekbd
  ];

  buildInputs = with gnome3; [
    pkgconfig
    intltool
    ibus
    gtk
    glib
    upower
    libcanberra_gtk3
    gsettings_desktop_schemas
    libxml2
    gnome_desktop
    gnome_settings_daemon
    polkit
    libxslt
    libgtop
    gnome-menus
    gnome_online_accounts
    libsoup
    colord
    libpulseaudio
    fontconfig
    colord-gtk
    libpwquality
    accountsservice
    libkrb5
    networkmanagerapplet
    libwacom
    samba
    libnotify
    libxkbfile
    shared_mime_info
    icu
    libtool
    docbook_xsl
    docbook_xsl_ns
    gnome3.grilo
    gdk_pixbuf
    gnome3.defaultIconTheme
    librsvg
    clutter
    clutter_gtk
    gnome3.vino
    udev
    libgudev
    networkmanager
    modemmanager
    gnome3.gnome-bluetooth
    cups
    xorg.libSM
  ];

  preBuild = ''
    substituteInPlace tz.h \
      --replace "/usr/share/zoneinfo/zone.tab" "${tzdata}/share/zoneinfo/zone.tab"
    substituteInPlace panels/datetime/tz.h \
      --replace "/usr/share/zoneinfo/zone.tab" "${tzdata}/share/zoneinfo/zone.tab"

    # hack to make test-endianess happy
    mkdir -p $out/share/locale
    substituteInPlace panels/datetime/test-endianess.c \
      --replace "/usr/share/locale/" "$out/share/locale/"
  '';

  preFixup = with gnome3; ''
    for i in $out/share/applications/* ; do
      substituteInPlace $i \
        --replace "gnome-control-center" "$out/bin/gnome-control-center"
    done
  '';

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "Utilities to configure the GNOME desktop";
    license = licenses.gpl2Plus;
    maintainers = gnome3.maintainers;
    platforms = platforms.linux;
  };

}
