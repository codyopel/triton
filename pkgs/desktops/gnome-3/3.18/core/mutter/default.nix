{ fetchurl, stdenv
, gettext
, intltool
, libtool
, makeWrapper
, pkgconfig

, glib
, gnome3
, gobjectIntrospection
, upower
, cairo
, pango
, cogl
, clutter
, libstartup_notification
, libcanberra
, libgudev
, zenity
, xkeyboard_config
, libxkbfile
, libxkbcommon
, libinput
, systemd
, wayland
, xorg
, gtk3
}:

stdenv.mkDerivation rec {
  name = "mutter-3.18.1";
  versionMajor = "3.18";
  versionMinor = "1";
  version = "${versionMajor}.${versionMinor}";

  src = fetchurl {
    url = "mirror://gnome/sources/mutter/${versionMajor}/${name}.tar.xz";
    sha256 = "1ab959z5fgi4rq0ifxdqvpdbv99a2b1lfgvj327s9crdvk4ygpjg";
  };

  patches = [
    ./x86.patch
    ./math.patch
  ];

  NIX_CFLAGS_COMPILE = [
    # fatal error: gio/gunixfdlist.h: No such file or directory
    "-I${gnome3.glib}/include/gio-unix-2.0"
  ];

  configureFlags = [
    "--enable-nls"
    "--enable-glibtest"
    "--enable-schemas-compile"
    "--enable-verbose-mode"
    "--enable-sm"
    "--enable-startup-notification"
    "--disable-installed-tests"
    "--enable-introspection"
    # TODO: requires clutter wayland support
    "--enable-native-backend"
    # TODO: requires clutter wayland support
    "--enable-wayland"
    "--disable-debug"
    "--enable-compile-warnings"
    "--with-libcanberra"
    "--with-x"
  ];

  nativeBuildInputs = [
    gettext
    pkgconfig
    intltool
    libtool
    makeWrapper
  ];

  buildInputs = [
    cairo
    clutter
    cogl
    glib
    gnome3.geocode_glib
    gnome3.gnome_desktop
    gobjectIntrospection
    gnome3.gsettings_desktop_schemas
    gtk3
    libcanberra
    libgudev
    libinput
    libstartup_notification
    libxkbcommon
    libxkbfile
    pango
    systemd
    upower
    wayland
    xkeyboard_config
    xorg.libICE
    xorg.libSM
    xorg.libX11
    xorg.libxcb
    xorg.libXcomposite
    xorg.libXcursor
    xorg.libXdamage
    xorg.libXext
    xorg.libXfixes
    xorg.libXi
    xorg.libXinerama
    xorg.libXrandr
    xorg.libXrender
    zenity
  ];

  

  preFixup = ''
    wrapProgram "$out/bin/mutter" \
      --prefix XDG_DATA_DIRS : "$GSETTINGS_SCHEMAS_PATH"
  '';

  meta = with stdenv.lib; {
    maintainers = gnome3.maintainers;
    platforms = platforms.linux;
  };

}
