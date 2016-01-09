{ stdenv, fetchurl
, pkgconfig
, python

, alsaLib
, cdparanoia
, glib
, gobjectIntrospection
, gstreamer
, isocodes
, libogg
, libtheora
, libvisual
, libvorbis
, orc
, pango
, tremor
, xorg
, zlib
}:

stdenv.mkDerivation rec {
  name = "gst-plugins-base-1.6.2";

  src = fetchurl {
    url = "http://gstreamer.freedesktop.org/src/gst-plugins-base/${name}.tar.xz";
    sha256 = "08jkqyjw0h8aja2cy7p7yn0ja2j77pimaj8w3vbnwljiwh0d8pf7";
  };

  configureFlags = [
    "--disable-maintainer-mode"
    "--enable-nls"
    "--enable-rpath"
    "--disable-fatal-warnings"
    "--disable-debug"
    "--disable-profiling"
    "--disable-valgrind"
    "--disable-gcov"
    "--disable-examples"
    "--enable-external"
    "--enable-experimental"
    "--enable-largefile"
    "--enable-introspection"
    "--disable-gtk-doc"
    "--disable-gtk-doc-html"
    "--disable-gtk-doc-pdf"
    "--enable-gobject-cast-checks"
    "--enable-glib-asserts"
    "--enable-orc"
    "--enable-Bsymbolic"
    "--disable-static-plugins"
    "--enable-adder"
    "--enable-app"
    "--enable-audioconvert"
    "--enable-audiorate"
    "--enable-audiotestsrc"
    "--enable-encoding"
    "--enable-videoconvert"
    "--enable-gio"
    "--enable-playback"
    "--enable-audioresample"
    "--enable-subparse"
    "--enable-tcp"
    "--enable-typefind"
    "--enable-videotestsrc"
    "--enable-videorate"
    "--enable-videoscale"
    "--enable-volume"
    "--enable-iso-codes"
    "--enable-zlib"
    "--enable-x"
    "--enable-xvideo"
    "--enable-xshm"
    "--enable-alsa"
    "--enable-cdparanoia"
    "--enable-ivorbis"
    "--enable-libvisual"
    "--enable-ogg"
    "--enable-pango"
    "--enable-theora"
    "--enable-vorbis"
    "--enable-gio_unix_2_0"
    "--disable-freetypetest"
    "--with-audioresample-format=float"
  ];

  nativeBuildInputs = [
    pkgconfig
    python
  ];

  propagatedBuildInputs = [
    glib
    gstreamer
  ];

  buildInputs = [
    alsaLib
    cdparanoia
    gobjectIntrospection
    isocodes
    libogg
    libtheora
    libvisual
    libvorbis
    orc
    pango
    tremor
    xorg.libX11
    xorg.libXext
    xorg.libXv
    zlib
  ];

  meta = with stdenv.lib; {
    description = "Basepack of plugins for gstreamer";
    homepage = http://gstreamer.freedesktop.org;
    license = licenses.lgpl2plus;
    maintainers = with maintainers; [
      codyopel
    ];
    platforms = [
      "i686-linux"
      "x86_64-linux"
    ];
  };
}
