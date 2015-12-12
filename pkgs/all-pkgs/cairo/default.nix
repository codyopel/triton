{ stdenv, fetchurl
, pkgconfig
, libiconv

, cogl
, expat
, fontconfig
, freetype
, glib
, libpng
, libspectre
, lzo
, pixman
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
  name = "cairo-1.14.6";

  src = fetchurl {
    url = "http://cairographics.org/releases/${name}.tar.xz";
    sha256 = "05pa5r914d809711yg9rapgmmi4hymzbarhd3w0yrfadhiy9rv7n";
  };

  configureFlags = [
    "--disable-gtk-doc"
    "--disable-gtk-doc-html"
    "--disable-gtk-doc-pdf"
    "--disable-gcov"
    "--disable-valgrind"
    "--enable-xlib"
    "--enable-xlib-xrender"
    "--enable-xcb"
    "--enable-xlib-xcb"
    "--enable-xcb-shm"
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
    "--disable-drm"
    "--disable-gallium"
    "--enable-libpng"
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
    "--enable-gobject"
    "--disable-full-testing"
    "--disable-trace"
    "--enable-interpreter"
    "--disable-symbol-lookup"
    #"--enable-some-floating-point"
    "--with-x"
    #(wtFlag "skia" true "yes")
    #(wtFlag "skia-build-type" true "Release")
    "--without-gallium"
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
    expat
    lzo
    pixman
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
