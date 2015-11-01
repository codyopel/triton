{ stdenv, fetchurl
, gettext
, pkgconfig

, bzip2
, cairo
, gdk_pixbuf
, glib
, gobjectIntrospection
, gst_plugins_base
, gstreamer
, libdrm
, libintlOrEmpty
, mesa_noglu
, pango
, xorg
}:

stdenv.mkDerivation rec {
  name = "cogl-${version}";
  versionMajor = "1.16";
  versionMinor = "2";
  version = "${versionMajor}.${versionMinor}";

  src = fetchurl {
    url = "mirror://gnome/sources/cogl/${versionMajor}/${name}.tar.xz";
    sha256 = "1ryljadgrahc359hrhnvbvifw25in9wik9wkxkgnzvs62mcr3gk5";
  };

  configureFlags = [
    "--enable-introspection"
    "--enable-kms-egl-platform"
    "--enable-cogl-gst"
    "--enable-gles1"
    "--enable-gles2"
  ];

  nativeBuildInputs = [
    gettext
    pkgconfig
  ];

  buildInputs = [
    bzip2
    cairo
    gdk_pixbuf
    glib
    gobjectIntrospection
    gstreamer
    gst_plugins_base
    libdrm
    pango
    xorg.libX11
    xorg.libXdamage
    xorg.libXfixes
    xorg.libXrandr
  ];

  propagatedBuildInputs = [
    mesa_noglu # pkg-config
    xorg.libXcomposite # pkg-config
    xorg.libXext # pkg-config
    xorg.libXrandr # pkg-config
  ];

  meta = with stdenv.lib; {
    description = "Library for using 3D graphics hardware for rendering";
    maintainers = with maintainers; [ ];
    platforms = platforms.mesaPlatforms;
  };
}
