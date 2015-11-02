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
# Required
# Optional



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
    #(wtFlag "gtk" true "2.0")
    (wtFlag "gtk" (gtk3 != null) "3.0")

    # requires gtk2 for plugin process
    (enFlag "webkit2" true null)

    (enFlag "spellcheck" true null)

    #(enFlag "driectfb-target" true null)
    (enFlag "x11-target" true null)
    (enFlag "wayland-target" true null)

    (enFlag "glx" false null)
    (enFlag "gles2" true null)
    (enFlag "egl" true null)
    (enFlag "webgl" true null)
    (enFlag "accelerated-compositing" true null)
    (enFlag "gamepad" false null) 
    (enFlag "svg" true null)
    (enFlag "svg-fonts" true null)
    (enFlag "opcode-stats" false null) # !jit
    #(enFlag "css-filters" true null)
    (enFlag "introspection" true null)
    (enFlag "credential-storage" true null)
    (enFlag "geolocation" true null)
    (enFlag "video" true null)
    (enFlag "web-audio" true null)
    (enFlag "battery-status" false null)
    # tests???
    (enFlag "coverage" true null)
    (enFlag "jit" true null) # disables ftl
    (enFlag "ftl-jit" false null) # llvm
    (enFlag "dependency-tracking" true null)
    #(enFlag "gtk-doc" false null)
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

  buildInputs = [
    atk
    cairo
    enchant
    fontconfig
    freetype
    geoclue2
    glib
    gobjectIntrospection
    gtk2
    gtk3
    gst_all_1.gst-plugins-base
    gst_all_1.gstreamer
    harfbuzz
    icu
    libjpeg
    libpng
    libsecret
    libsoup
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
