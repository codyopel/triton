{ stdenv, fetchurl
, gettext
, pkgconfig

, atk
, bzip2
, cairo
, cogl
, fontconfig
, freetype
, gdk_pixbuf
, glib
, gobjectIntrospection
, json_glib
, libdrm
, libxkbcommon
, mesa
, pango
, wayland
, xorg
}:

stdenv.mkDerivation rec {
  name = "clutter-${version}";
  versionMajor = "1.22";
  versionMinor = "4";
  version = "${versionMajor}.${versionMinor}";

  src = fetchurl {
    url = "mirror://gnome/sources/clutter/${versionMajor}/${name}.tar.xz";
    sha256 = "07lydj33iwddzlspdl9zyrb534x12yk4zp003mx6d1sz08bcwxqx";
  };

  configureFlags = [
    "--enable-introspection"
  ];

  nativeBuildInputs = [
    gettext
    pkgconfig
  ];

  buildInputs = [
    atk
    bzip2
    cairo
    cogl
    fontconfig
    freetype
    gdk_pixbuf
    glib
    gobjectIntrospection
    libdrm
    mesa
    pango
    xorg.libX11
    xorg.libXcomposite
    xorg.libXdamage
    xorg.libXext
    xorg.libXrandr
  ];

  propagatedBuildInputs = [
    cogl # pkg-config
    json_glib # pkg-config
    libxkbcommon # pkg-config
    wayland # pkg-config
    xorg.libXi # pkg-config
  ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "Library for creating graphical user interfaces";
    license = licenses.lgpl2Plus;
    homepage = http://www.clutter-project.org/;
    maintainers = with maintainers; [ ];
    platforms = platforms.mesaPlatforms;
  };
}
