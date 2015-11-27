{ stdenv, fetchurl
, gettext
, pkgconfig

, atk
, bzip2
, cairo
, gdk_pixbuf
, glib
, gobjectIntrospection
, gst_all_1
, json_glib
, libdrm
, libintlOrEmpty
, libxkbcommon
, mesa_noglu
, pango
, wayland
, xorg
}:

with {
  inherit (stdenv.lib)
    enFlag
    optionalString;
};

stdenv.mkDerivation rec {
  name = "cogl-${version}";
  versionMajor = "1.22";
  versionMinor = "0";
  version = "${versionMajor}.${versionMinor}";

  src = fetchurl {
    url = "mirror://gnome/sources/cogl/${versionMajor}/${name}.tar.xz";
    sha256 = "14daxqrid5039xmq9yl4pk86awng1n9zgl6ysblhc4gw2ifzp7b8";
  };

  postPatch = ''
    # Do not build examples
    sed -e "s/^\(SUBDIRS +=.*\)examples\(.*\)$/\1\2/" \
      -i Makefile.am Makefile.in
  '' + optionalString (!doCheck) ''
    # For some reason the configure switch will not completely disable
    # tests being built
    sed -e "s/^\(SUBDIRS =.*\)test-fixtures\(.*\)$/\1\2/" \
      -e "s/^\(SUBDIRS +=.*\)tests\(.*\)$/\1\2/" \
      -e "s/^\(.*am__append.* \)tests\(.*\)$/\1\2/" \
      -i Makefile.am Makefile.in || die
  '';

  configureFlags = [
    "--disable-installed-tests"
    #"--enable-emscripten"
    "--disable-standalone"
    "--disable-debug"
    (enFlag "unit-tests" doCheck null)
    "--enable-cairo"
    "--disable-profile"
    "--disable-maintainer-flags"
    "--enable-deprecated"
    "--enable-glibtest"
    "--enable-glib"
    "--enable-cogl-pango"
    "--enable-cogl-gst"
    "--enable-cogl-path"
    "--enable-gdk-pixbuf"
    "--disable-quartz-image"
    "--disable-examples-install"
    "--enable-gles1"
    "--enable-gles2"
    "--enable-gl"
    "--enable-cogl-gles2"
    "--enable-glx"
    "--disable-wgl"
    "--enable-null-egl-platform"
    "--disable-gdl-egl-platform"
    "--enable-wayland-egl-platform"
    "--enable-kms-egl-platform"
    "--enable-wayland-egl-server"
    "--disable-android-egl-platform"
    "--disable-mir-egl-platform"
    "--enable-xlib-egl-platform"
    "--disable-gtk-doc"
    "--disable-gtk-doc-html"
    "--disable-gtk-doc-pdf"
    "--enable-nls"
    "--enable-rpath"
    "--enable-introspection"
    "--with-x"
  ];

  nativeBuildInputs = [
    gettext
    pkgconfig
  ];

  buildInputs = [
    atk
    bzip2
    cairo
    gobjectIntrospection
    gst_all_1.gstreamer
    gst_all_1.gst-plugins-base
    json_glib
    pango
    xorg.libXfixes
  ];

  propagatedBuildInputs = [
    gdk_pixbuf
    glib
    libdrm
    libxkbcommon
    mesa_noglu
    wayland
    xorg.libX11
    xorg.libXcomposite
    xorg.libXdamage
    xorg.libXext
    xorg.libXi
    xorg.libXrandr
  ];

  doCheck = false;
  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "Library for using 3D graphics hardware for rendering";
    maintainers = with maintainers; [ ];
    platforms = platforms.mesaPlatforms;
  };
}
