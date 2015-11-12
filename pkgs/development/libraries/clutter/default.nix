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
, libgudev
, libinput
, libxkbcommon
, mesa
, pango
, udev
, xorg
, wayland
}:

stdenv.mkDerivation rec {
  name = "clutter-${version}";
  versionMajor = "1.24";
  versionMinor = "2";
  version = "${versionMajor}.${versionMinor}";

  src = fetchurl {
    url = "mirror://gnome/sources/clutter/${versionMajor}/${name}.tar.xz";
    sha256 = "0qyd0cw17wi8gl6y9z2j2lh2gwghxskfmsdvw4ayrgxwnj6cjccn";
  };

  configureFlags = [
    "--enable-glibtest"
    "--enable-Bsymbolic"
    "--enable-x11-backend"
    "--disable-win32-backend"
    "--disable-quartz-backend"
    "--enable-wayland-backend"
    "--enable-egl-backend"
    "--disable-mir-backend"
    "--disable-cex100-backend"
    "--enable-wayland-compositor"
    "--enable-tslib-input"
    "--enable-evdev-input"
    "--enable-xinput"
    "--enable-gdk-pixbuf"
    "--disable-debug"
    "--enable-introspection"
    "--disable-deprecated"
    "--disable-maintainer-flags"
    "--disable-gcov"
    "--enable-introspection"
    "--disable-gtk-doc"
    "--disable-gtk-doc-html"
    "--disable-gtk-doc-pdf"
    "--disable-docs"
    "--enable-nls"
    "--enable-rpath"
    "--disable-installed-tests"
    "--disable-always-build-tests"
    "--disable-examples"
    "--with-x"
  ];

  nativeBuildInputs = [
    gettext
    pkgconfig
  ];

  buildInputs = [
    bzip2
    fontconfig
    freetype
    gdk_pixbuf
    gobjectIntrospection
    libdrm
    libgudev
    libinput
    mesa
    udev
    xorg.inputproto
    xorg.libXrandr
  ];

  propagatedBuildInputs = [
    atk # pkgconfig
    cairo # pkgconfig
    cogl # pkgconfig
    glib # pkgconfig
    json_glib # pkgconfig
    libxkbcommon # pkgconfig
    pango # pkgconfig
    wayland # pkgconfig
    xorg.libX11 # pkgconfig
    xorg.libXcomposite # pkgconfig
    xorg.libXdamage # pkgconfig
    xorg.libXext # pkgconfig
    xorg.libXi # pkgconfig
  ];

  enableParallelBuilding = false;

  meta = with stdenv.lib; {
    description = "Library for creating graphical user interfaces";
    license = licenses.lgpl2Plus;
    homepage = http://www.clutter-project.org/;
    maintainers = with maintainers; [ ];
    platforms = platforms.mesaPlatforms;
  };
}
