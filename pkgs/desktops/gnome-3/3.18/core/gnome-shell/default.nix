{ fetchurl, stdenv
, docbook_xsl
, docbook_xsl_ns
, intltool
, libtool
, makeWrapper
, pkgconfig

, accountsservice
, at_spi2_atk
, at_spi2_core
, atk
, clutter
, cogl
, dbus
, gdk_pixbuf
, gdm
, gnome3
, gobjectIntrospection
, gstreamer
, ibus
, json_glib
, libcanberra_gtk3
, libcroco
, libical
, libgweather
, libpulseaudio
, librsvg
, libsecret
, libsoup
, libstartup_notification
, libxkbcommon
, libxml2
, mesa_noglu
, networkmanager
, networkmanagerapplet
, nss
, p11_kit
, pango
, polkit
, spidermonkey_24
, sqlite
, telepathy_glib
, telepathy_logger
, unzip
, upower
, wayland
, xorg

, python3

, libffi
, zlib
, glib
}:

# http://sources.gentoo.org/cgi-bin/viewvc.cgi/gentoo-x86/gnome-base/gnome-shell/gnome-shell-3.10.2.1.ebuild?revision=1.3&view=markup

stdenv.mkDerivation rec {
  name = "gnome-shell-${version}";
  versionMajor = "3.18";
  versionMinor = "3";
  version = "${versionMajor}.${versionMinor}";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-shell/${versionMajor}/${name}.tar.xz";
    sha256 = "16sicxdp08yfaj4hiyzvbspb5jk3fpmi291272zhx5vgc3wbl5w5";
  };

  configureFlags = [
    # Needed to find /etc/NetworkManager/VPN
    "--sysconfdir=/etc"
    "--enable-nls"
    "--enable-schemas-compile"
    "--enable-systemd"
    "--enable-browser-plugin"
    "--enable-introspection"
    "--enable-networkmanager"
    "--enable-glibtest"
    "--disable-gtk-doc"
    "--disable-gtk-doc-html"
    "--disable-gtk-doc-pdf"
    "--disable-man"
    "--enable-compile-warnings"
    "--enable-Werror"
  ];

  nativeBuildInputs = [
    docbook_xsl
    docbook_xsl_ns
    intltool
    libtool
    makeWrapper
    pkgconfig
  ];

  buildInputs = with gnome3; [
    accountsservice
    at_spi2_atk
    at_spi2_core
    atk
    caribou
    clutter
    cogl
    dbus
    defaultIconTheme
    evolution_data_server
    gcr
    gdk_pixbuf
    gdm
    glib
    gjs
    gnome_control_center
    gnome_desktop
    gnome_keyring
    gnome-menus
    gnome_session
    gnome3.gnome-bluetooth
    # not declared at build time, but typelib is needed at runtime
    # also requires libffi
    gnome3.libgweather
    gnome3.gnome-clocks # schemas needed
    gnome3.gnome_settings_daemon
    gobjectIntrospection
    gsettings_desktop_schemas
    gstreamer
    gtk
    ibus
    json_glib
    libcanberra_gtk3
    libcroco
    libical
    libpulseaudio
    librsvg
    libsecret
    libsoup
    libstartup_notification
    libxkbcommon
    libxml2
    mesa_noglu
    mutter
    networkmanager
    networkmanagerapplet
    nss
    p11_kit
    pango
    polkit
    python3
    spidermonkey_24
    sqlite
    telepathy_glib
    telepathy_logger
    upower
    wayland
    xorg.libSM
    xorg.libICE
    xorg.libXinerama
    xorg.libXtst
  ];

  preBuild = ''
    patchShebangs src/data-to-c.pl
    substituteInPlace data/Makefile --replace " install-keysDATA" ""
  '';

  installFlags = [
    "keysdir=$(out)/share/gnome-control-center/keybindings"
  ];

  preFixup = with gnome3; ''
    gtk3AppsWrapperArgs+=("--prefix PATH : ${unzip}/bin")
    gtk3AppsWrapperArgs+=("--prefix XDG_DATA_DIRS : ${evolution_data_server}/share")

    echo "${unzip}/bin" > $out/${passthru.mozillaPlugin}/extra-bin-path
  '';

  enableParallelBuilding = true;

  passthru = {
    mozillaPlugin = "/lib/mozilla/plugins";
  };

  meta = with stdenv.lib; {
    platforms = platforms.linux;
    maintainers = gnome3.maintainers;
  };

}
