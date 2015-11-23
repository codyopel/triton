{ stdenv, fetchurl
, pkgconfig
, libiconv

, cogl
#, directfb
, expat
, fontconfig
, freetype
, glib
, libdrm
, libpng
#, librsvg
, libspectre
, lzo
, pixman
#, poppler
, mesa_noglu
#, qt4
, xorg
, zlib
}:

with {
  inherit (stdenv.lib)
    enFlag;
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
    "--disable-gcov"
    "--disable-valgrind"
    (enFlag "xlib" (xorg.libX11 != null && xorg.libXext != null) null)
    (enFlag "xlib-xrender" (xorg.libXrender != null) null)
    (enFlag "xcb" (xorg.libxcb != null) null)
    (enFlag "xlib-xcb" (xorg.libxcb != null) null)
    (enFlag "xcb-shm" (xorg.libxcb != null) null)
    # TODO: qt
    "--disable-qt"
    "--disable-quartz"
    "--disable-quartz-font"
    "--disable-quartz-image"
    "--disable-win32"
    "--disable-win32-font"
    # TODO: package skia
    "--disable-skia"
    "--disable-os2"
    "--disable-beos"
    (enFlag "drm" (libdrm != null) null)
    "--disable-drm"
    # TODO: gallium support
    "--disable-gallium"
    (enFlag "png" (libpng != null) null)
    "--enable-gl"
    "--disable-glesv2"
    # FIXME: cogl recursion
    "--disable-cogl"
    # FIXME: fix directfb mirroring
    "--disable-directfb"
    "--disable-vg"
    "--enable-egl"
    "--enable-glx"
    "--disable-wgl"
    "--enable-script"
    "--enable-ft"
    "--enable-fc"
    "--enable-ps"
    "--enable-pdf"
    "--enable-svg"
    "--disable-test-surfaces"
    "--enable-tee"
    "--enable-xml"
    "--enable-pthread"
    (enFlag "gobject" (glib != null) "yes")
    "--disable-full-testing"
    "--disable-trace"
    "--enable-interpreter"
    "--disable-symbol-lookup"
    #"--enable-some-floating-point"
    "--with-x"
    #(wtFlag "skia" true "yes")
    #(wtFlag "skia-build-type" true "Release")
    "--with-gallium=${mesa_noglu}"
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
  ];

  propagatedBuildInputs = [
    fontconfig
    freetype
    glib
    libpng
    libspectre
    mesa_noglu
    xorg.libX11
    xorg.libxcb
    xorg.libXext
    xorg.libXrender
  ];

  buildInputs = [
    #cogl
    #directfb
    expat
    libdrm
    #librsvg
    lzo
    pixman
    #poppler
    xorg.xcbutil
  ];

  postInstall = ''
    rm -rvf $out/share/gtk-doc
  '' + glib.flattenInclude;

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "A 2D graphics library";
    homepage = http://cairographics.org/;
    license = with licenses; [ lgpl2Plus mpl10 ];
    platforms = platforms.linux;
  };
}
