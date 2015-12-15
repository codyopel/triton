{ fetchurl, stdenv
, pkgconfig
, gnome3
, intltool
, glib
, libnotify
, lcms2
, libXtst
, libxkbfile
, libpulseaudio
, libcanberra_gtk3
, upower
, colord
, libgweather
, polkit
, geoclue2
, librsvg
, xf86_input_wacom
, udev
, libwacom
, libxslt
, libtool
, networkmanager
, docbook_xsl
, docbook_xsl_ns
, makeWrapper
, ibus
, xkeyboard_config
, xorg
, cups
, libgudev
}:

stdenv.mkDerivation rec {
  name = "gnome-settings-daemon-${version}";
  versionMajor = "3.18";
  versionMinor = "2";
  version = "${versionMajor}.${versionMinor}";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-settings-daemon/${versionMajor}/${name}.tar.xz";
    sha256 = "0vzwf875csyqx04fnra6zicmzcjc3s13bxxpcizlys12iwjwfw9h";
  };

  NIX_CFLAGS_COMPILE = [
    # fatal error: gio/gunixfdlist.h: No such file or directory
    "-I${glib}/include/gio-unix-2.0"
  ];

  buildInputs = with gnome3; [
    intltool
    pkgconfig
    ibus
    gtk3
    glib
    gsettings_desktop_schemas
    networkmanager
    libnotify
    gnome_desktop
    lcms2
    libXtst
    libxkbfile
    libpulseaudio
    libcanberra_gtk3
    upower
    colord
    libgweather
    xkeyboard_config
    polkit
    geocode_glib
    geoclue2
    librsvg
    xf86_input_wacom
    udev
    libwacom
    libxslt
    libtool
    docbook_xsl
    docbook_xsl_ns
    makeWrapper
    gnome_themes_standard
    xorg.libXi
    xorg.libXfixes
    cups
    libgudev
  ];

  preFixup = ''
    gtk3AppsWrapperArgs+=("--prefix PATH : ${glib}/bin")
  '';

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    maintainers = gnome3.maintainers;
    platforms = platforms.linux;
  };
}
