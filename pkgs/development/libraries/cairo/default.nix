{ stdenv, fetchurl
, pkgconfig
, libiconv
, libintlOrEmpty

, cogl
#, directfb
, expat
, fontconfig
, freetype
, glib
, libpng
#, librsvg
, lzo
, pixman
#, poppler
, mesa_noglu
#, qt4
, udev
, xorg
, zlib
}:

with {
  inherit (stdenv.lib)
    enFlag
    wtFlag;
};

stdenv.mkDerivation rec {
  name = "cairo-1.14.4";

  src = fetchurl {
    url = "http://cairographics.org/releases/${name}.tar.xz";
    sha256 = "05p75r914d809711yg9rapgmmi4hymzbarhd3w0yrfadhiy9rv7n";
  };

  configureFlags = [
    "--disable-gtk-doc"
    "--disable-gtk-doc-html"
    "--disable-gtk-doc-pdf"
    #largefile
    #atomic
    "--disable-gcov"
    "--disable-valgrind"
    (enFlag "xlib" (xorg.libX11 != null && xorg.libXext != null) "yes")
    (enFlag "xlib-xrender" (xorg.libXrender != null) "yes")
    (enFlag "xcb" (xorg.libxcb != null) "yes")
    (enFlag "xlib-xcb" (xorg.libxcb != null) "yes")
    (enFlag "xcb-shm" (xorg.libxcb != null) "yes")
    # TODO: qt
    #(enFlag "qt" (qt4 != null) "yes")
    "--disable-qt"
    "--disable-quartz"
    "--disable-quartz-font"
    "--disable-quartz-image"
    "--disable-win32"
    "--disable-win32-font"
    # TODO: package skia
    #(enFlag "skia")
    "--disable-skia"
    "--disable-os2"
    "--disable-beos"
    # FIXME: intel failures
    #(enFlag "drm" (udev != null) "yes")
    "--disable-drm"
    # TODO: gallium support
    #(enFlag "gallium" true "yes")
    "--disable-gallium"
    (enFlag "png" (libpng != null) "yes")
    # Prefer gles over gl
    "--disable-gl"
    (enFlag "glesv2" true "yes")
    # FIXME: cogl recursion
    #(enFlag "cogl" (cogl != null) "yes")
    "--disable-cogl"
    # FIXME: fix directfb mirroring
    #(enFlag "directfb" (directfb != null) "yes")
    "--disable-directfb"
    "--disable-vg"
    (enFlag "egl" true "yes")
    "--disable-glx"
    "--disable-wgl"
    (enFlag "script" true "yes")
    (enFlag "ft" true "yes")
    (enFlag "fc" true "yes")
    # TODO: requires libspectre
    #(enFlag "ps" true "yes")
    (enFlag "pdf" true "yes")
    (enFlag "svg" true "yes")
    (enFlag "test-surfaces" false "yes")
    (enFlag "tee" true "yes")
    (enFlag "xml" true "yes")
    (enFlag "pthread" true "yes")
    (enFlag "gobject" (glib != null) "yes")
    (enFlag "full-testing" false "yes")
    (enFlag "trace" false "yes")
    (enFlag "interpreter" true "yes")
    (enFlag "synbol-lookup" false "yes")
    "--enable-some-floating-point"
    (wtFlag "x" (xorg != null) null)
    #(wtFlag "skia" true "yes")
    #(wtFlag "skia-build-type" true "Release")
    (wtFlag "gallium" true "${mesa_noglu}")
  ];

  preConfigure = ''
    # Work around broken `Requires.private' that prevents Freetype
    # `-I' flags to be propagated.
    sed -i "src/cairo.pc.in" \
        -es'|^Cflags:\(.*\)$|Cflags: \1 -I${freetype}/include/freetype2 -I${freetype}/include|g'
  '';

  nativeBuildInputs = [
    pkgconfig
    libiconv
  ] ++ libintlOrEmpty;

  buildInputs = [
    #cogl
    #directfb
    expat
    #librsvg
    lzo
    pixman
    #poppler
    udev
    xorg.xcbutil
    zlib
  ];

  propagatedBuildInputs = [
    fontconfig
    freetype
    glib
    libpng
    mesa_noglu
    xorg.libX11
    xorg.libxcb
    xorg.libXext
    xorg.libXrender
  ];

  postInstall = "rm -rf $out/share/gtk-doc";

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "A 2D graphics library";
    homepage = http://cairographics.org/;
    license = with licenses; [ lgpl2Plus mpl10 ];
    platforms = platforms.linux;
  };
}
