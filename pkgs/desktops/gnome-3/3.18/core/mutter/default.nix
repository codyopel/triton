{ fetchurl, stdenv, pkgconfig, gnome3, intltool, gobjectIntrospection
, upower, cairo
, pango, cogl, clutter, libstartup_notification, libcanberra, zenity
, libcanberra_gtk3
, libtool, makeWrapper, xkeyboard_config, libxkbfile, libxkbcommon
, xorg
}:

stdenv.mkDerivation rec {
  name = "mutter-3.18.1";

  src = fetchurl {
    url = mirror://gnome/sources/mutter/3.18/mutter-3.18.1.tar.xz;
    sha256 = "1ab959z5fgi4rq0ifxdqvpdbv99a2b1lfgvj327s9crdvk4ygpjg";
  };

  patches = [
    ./x86.patch
    ./math.patch
  ];

  # fatal error: gio/gunixfdlist.h: No such file or directory
  NIX_CFLAGS_COMPILE = "-I${gnome3.glib}/include/gio-unix-2.0";

  configureFlags = "--with-x --disable-static --enable-shape --enable-sm --enable-startup-notification --enable-xsync --enable-verbose-mode --with-libcanberra"; 

  buildInputs = with gnome3; [
    pkgconfig intltool glib gobjectIntrospection gtk gsettings_desktop_schemas
    upower
    gnome_desktop cairo pango cogl clutter zenity libstartup_notification
    libcanberra
    gnome3.geocode_glib
    libcanberra_gtk3 zenity libtool makeWrapper xkeyboard_config libxkbfile
    libxkbcommon
    xorg.libXcursor
    xorg.libXinerama
    xorg.libSM
  ];

  preFixup = ''
    wrapProgram "$out/bin/mutter" \
      --prefix XDG_DATA_DIRS : "$GSETTINGS_SCHEMAS_PATH"
  '';

  meta = with stdenv.lib; {
    platforms = platforms.linux;
    maintainers = gnome3.maintainers;
  };

}
