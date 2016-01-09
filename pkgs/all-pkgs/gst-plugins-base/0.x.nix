{ stdenv, fetchurl
, pkgconfig

, alsaLib
, cdparanoia
, glib
, gnome
, gobjectIntrospection
, gstreamer_0
, isocodes
, libogg
, libtheora
, libv4l
, libvisual
, libvorbis
, libxml2
, orc
, pango
, tremor
, xorg
, zlib
}:

stdenv.mkDerivation rec {
  name = "gst-plugins-base-0.10.36";

  src = fetchurl {
    url = "http://gstreamer.freedesktop.org/src/gst-plugins-base/${name}.tar.xz";
    sha256 = "0jp6hjlra98cnkal4n6bdmr577q8mcyp3c08s3a02c4hjhw5rr0z";
  };

  patches = [
    ./gst-plugins-base-0.10-gcc-4.9.patch
    ./gst-plugins-base-0.10-resync-ringbuffer.patch
  ];

  postPatch = ''
    # Fix hardcoded path
    sed -i configure \
      -e 's@/bin/echo@echo@g'

    # The AC_PATH_XTRA macro unnecessarily pulls in libSM and libICE even
    # though they are not actually used. This needs to be fixed upstream by
    # replacing AC_PATH_XTRA with PKG_CONFIG calls.
    sed -i configure \
      -e 's:X_PRE_LIBS -lSM -lICE:X_PRE_LIBS:'
  '';

  configureFlags = [
    "--disable-maintainer-mode"
    "--enable-nls"
    "--enable-rpath"
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
    "--enable-gobject-cast-checks"
    "--enable-glib-asserts"
    "--enable-orc"
    "--enable-Bsymbolic"
    "--enable-adder"
    "--enable-app"
    "--enable-audioconvert"
    "--enable-audiorate"
    "--enable-audiotestsrc"
    "--enable-encoding"
    "--enable-ffmpegcolorspace"
    "--enable-gdp"
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
    "--enable-gst_v4l"
    "--enable-alsa"
    "--enable-cdparanoia"
    "--enable-gnome_vfs"
    # FIXME: compilation fails with ivorbis(tremor)
    "--disable-ivorbis"
    "--enable-gio"
    "--enable-libvisual"
    "--enable-ogg"
    "--disable-oggtest"
    "--enable-pango"
    "--enable-theora"
    "--enable-vorbis"
    "--disable-vorbistest"
    "--disable-freetypetest"
    "--with-audioresample-format=float"
    "--with-x"
    "--with-gudev"
  ];

  nativeBuildInputs = [
    pkgconfig
  ];

  propagatedBuildInputs = [
    glib
    gstreamer_0
  ];

  buildInputs = [
    alsaLib
    cdparanoia
    gnome.gnome_vfs
    gobjectIntrospection
    isocodes
    libogg
    libtheora
    libv4l
    libvisual
    libvorbis
    libxml2
    orc
    pango
    #tremor
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
