{ stdenv, fetchurl
  # Build
, autoreconfHook
, bison
, flex
, gettext
, gperf
, perl
, pkgconfig
, python
, ruby
, which

, atk
, cairo
, enchant
, fontconfig
, freetype
, geoclue2
, glib
, gobjectIntrospection
, gtk2
, gtk3
, gst_all_1
, harfbuzz
, icu
, libjpeg
, libpng
, libsecret
, libsoup
, libwebp
, libxml2
, libxslt
, pango
, mesa_noglu
, sqlite
, upower
, wayland
, xorg
, zlib
}:

with {
  inherit (stdenv.lib)
    enFlag
    wtFlag;
};

assert gtk3 != null;

stdenv.mkDerivation rec {
  name = "webkitgtk-2.4.9";

  src = fetchurl {
    url = "http://webkitgtk.org/releases/${name}.tar.xz";
    sha256 = "0r651ar3p0f8zwl7764kyimxk5hy88cwy116pv8cl5l8hbkjkpxg";
  };

  CC = "cc";

  patchs = [
    ./webkit-gtk-jpeg-9a.patch
  ];

  prePatch = ''
    patchShebangs ./Tools/gtk
  '';

  # patch *.in between autoreconf and configure
  postAutoreconf = "patch -p1 < ${./webcore-svg-libxml-cflags.patch}";

  configureFlags = [
    "--enable-largefile"
    "--enable-webkit1"
    "--enable-webkit2"
    "--disable-debug"
    "--disable-developer-mode"
    "--enable-optimizations"
    "--enable-x11-target"
    "--enable-wayland-target"
    "--disable-win32-target"
    "--disable-quartz-target"
    "--disable-directfb-target"
    "--enable-spellcheck"
    "--enable-credential-storage"
    "--disable-glx"
    "--enable-egl"
    "--enable-gles2"
    "--disable-gamepad"
    "--enable-video"
    "--enable-geolocation"
    "--enable-svg"
    "--enable-svg-fonts"
    "--enable-web-audio"
    "--disable-battery-status"
    "--disable-coverage"
    "--enable-fast-malloc"
    "--disable-debug-symbols"
    "--enable-webgl"
    "--enable-accelerated-compositing"
    "--enable-jit"
    "--disable-ftl-jit" # llvm
    "--disable-opcode-stats"
    "--enable-introspection"
    "--enable-glibtest"
    "--enable-schemas-compile"
    "--disable-maintainer-mode"
    "--with-gtk=3.0"
  ];

  nativeBuildInputs = [
    autoreconfHook
    perl
    python
    ruby
    bison
    gperf
    flex
    pkgconfig
    which
    gettext
  ];

  propagatedBuildInputs = [
    glib
    gtk3
    libsoup
  ];

  buildInputs = [
    atk
    cairo
    enchant
    fontconfig
    freetype
    geoclue2
    gobjectIntrospection
    gtk2
    gst_all_1.gst-plugins-base
    gst_all_1.gstreamer
    harfbuzz
    icu
    libjpeg
    libpng
    libsecret
    libwebp
    libxml2
    libxslt
    pango
    mesa_noglu
    sqlite
    upower
    wayland
    xorg.libXcomposite
    xorg.libXdamage
    xorg.libXrender
    xorg.libXt
    zlib
  ];

  enableParallelBuilding = true;

  dontAddDisableDepTrack = true;

  meta = with stdenv.lib; {
    description = "Web content rendering engine, GTK+ port";
    homepage = "http://webkitgtk.org/";
    license = licenses.bsd2;
    maintainers = with maintainers; [ ];
    platforms = platforms.linux;
  };
}
