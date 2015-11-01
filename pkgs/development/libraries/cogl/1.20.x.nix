{ stdenv, fetchurl
, gettext
, pkgconfig

, bzip2
, cairo
, gdk_pixbuf
, glib
, gobjectIntrospection
, gst_all_1
, libdrm
, libintlOrEmpty
, mesa_noglu
, pango
, wayland
, xorg
}:

stdenv.mkDerivation rec {
  name = "cogl-${version}";
  versionMajor = "1.20";
  versionMinor = "0";
  version = "${versionMajor}.${versionMinor}";

  src = fetchurl {
    url = "mirror://gnome/sources/cogl/${versionMajor}/${name}.tar.xz";
    sha256 = "0aqrj7gc0x7v536vdycgn2i23fj3nx3qwdd3mwgx7rr9b14kb7kj";
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
    gst_all_1.gstreamer
    gst_all_1.gst-plugins-base
    libdrm
    pango
    wayland
    xorg.libX11
    xorg.libXdamage
    xorg.libXfixes
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
