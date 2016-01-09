{ stdenv, fetchurl
, pkgconfig

, glib
, gst-plugins-base_0
, gstreamer_0
, libv4l
, orc
}:

stdenv.mkDerivation rec {
  name = "gst-plugins-good-0.10.31";

  src = fetchurl {
    url = "http://gstreamer.freedesktop.org/src/gst-plugins-good/${name}.tar.xz";
    sha256 = "0r1b54yixn8v2l1dlwmgpkr0v2a6a21id5njp9vgh58agim47a3p";
  };

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
    "--enable-schemas-install"
    "--disable-gtk-doc"
    "--enable-gobject-cast-checks"
    "--enable-glib-asserts"
    "--enable-orc"
    "--enable-gconftool"
    "--enable-videofilter"
    "--enable-alpha"
    "--enable-apetag"
    "--enable-audiofx"
    "--enable-audioparsers"
    "--enable-auparse"
    "--enable-autodetect"
    "--enable-avi"
    "--enable-cutter"
    "--enable-debugutils"
    "--enable-deinterlace"
    "--enable-effectv"
    "--enable-equalizer"
    "--enable-flv"
    "--enable-id3demux"
    "--enable-icydemux"
    "--enable-interleave"
    "--enable-flx"
    "--enable-goom"
    "--enable-goom2k1"
    "--enable-imagefreeze"
    "--enable-isomp4"
    "--enable-law"
    "--enable-level"
    "--enable-matroska"
    "--enable-monoscope"
    "--enable-multifile"
    "--enable-multipart"
    "--enable-replaygain"
    "--enable-rtp"
    "--enable-rtpmanager"
    "--enable-rtsp"
    "--enable-shapewipe"
    "--enable-smpte"
    "--enable-spectrum"
    "--enable-udp"
    "--enable-videobox"
    "--enable-videocrop"
    "--enable-videomixer"
    "--enable-wavenc"
    "--enable-wavparse"
    "--enable-y4m"

    "--disable-directsound"
    "--disable-oss"
    "--disable-oss4"
    "--disable-sunaudio"
    "--disable-osx_audio"
    "--disable-osx_video"
    "--enable-gst_v4l2"
    "--enable-x"
    "--enable-xshm"
    "--enable-xvideo"
    "--disable-aalib"
    "--disable-aalibtest"
    "--disable-annodex"
    "--enable-cairo"
    "--enable-cairo_gobject"
    "--disable-esd"
    "--disable-esdtest"
    "--enable-flac"
    "--enable-gconf"
    "--enable-gdk_pixbuf"
    "--disable-hal"
    "--enable-jack"
    "--enable-jpeg"
    "--enable-libcaca"
    "--disable-libdv"
    "--enable-libpng"
    "--enable-pulse"
    "--enable-dv1394"
    "--disable-shout2"
    "--enable-soup"
    "--enable-speex"
    "--enable-taglib"
    "--enable-wavpack"
    "--enable-zlib"
    "--enable-bz2"

    "--without-gtk"

    "--with-gudev"
    "--with-libv4l2"
    "--with-x"
    #"--with-jpeg-mmx", path to MMX'ified JPEG library
  ];

  nativeBuildInputs = [
    pkgconfig
  ];

  buildInputs = [
    glib
    gst-plugins-base_0
    gstreamer_0
    libv4l
    orc
  ];

  meta = with stdenv.lib; {
    description = "";
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
