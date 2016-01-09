{ stdenv, fetchurl
, gettext
, pkgconfig

, wxGTK
, gtk2
, gtk3
, glib
, zlib
, perl
, intltool
, libogg
, libvorbis
, libmad
, alsaLib
, libsndfile
, portaudio
, soxr
, flac
, lame
, expat
, libid3tag
, ffmpeg
/*, portaudio - given up fighting their portaudio.patch */
}:

# TODO: soundtouch, detach sbsms

with {
  inherit (stdenv)
    isi686
    isx86_64;
  inherit (stdenv.lib)
    enFlag;
};

stdenv.mkDerivation rec {
  name = "audacity-${version}";
  version = "2.1.1";

  src = fetchurl {
    url = "https://github.com/audacity/audacity/archive/Audacity-${version}.tar.gz";
    sha256 = "1dnxp5yfc03ny3b43arzxpws4gbli14hzjxxyh49pcf0q5xgzi8m";
  };

  # use system libs
  postPatch = ''
    mv lib-src lib-src-rm
    mkdir lib-src
    mv lib-src-rm/{Makefile*,lib-widget-extra,portaudio-v19,portmixer,portsmf,FileDialog,sbsms,libnyquist} lib-src/
    rm -r lib-src-rm/
  '';

  configureFlags = [
    "--disable-maintainer-mode"
    "--enable-nls"
    "--enable-rpath"
    "--disable-static-wx"
    "--enable-unicode"
    "--disable-debug"
    (enFlag "sse" (isi686 || isx86_64) null)
    "--disable-universal_binary"
    "--enable-dynamic-loading"
    "--enable-gtk3"
    "--enable-nyquist"
    "--disable-audio-units"
    "--enable-ladspa"
    "--disable-quicktime"
    "--enable-vst"
    #"--with-lib-preference=system local"
    "--with-expat"
    "--with-ffmpeg"
    "--with-lame"
    "--with-libflac"
    "--with-libid3tag"
    "--with-libmad"
    #"--with-sbsms"
    "--with-libsndfile"
    #"--with-soundtouch"
    "--with-libsoxr"
    #"--with-twolame"
    #"--with-libvamp"
    "--with-libvorbis"
    #"--with-lv2"
    "--with-portaudio"
    "--with-midi"
    "--with-widget-extra"
    "--with-portmixer"
  ];

  nativeBuildInputs = [
    gettext
    pkgconfig
  ];

  buildInputs = [
    alsaLib
    expat
    flac
    ffmpeg
    gtk2
    gtk3
    lame
    libid3tag
    libmad
    libsndfile
    libvorbis
    portaudio
    soxr
    wxGTK
  ];

  #dontDisableStatic = true;
  doCheck = true;
  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "Sound editor with graphical UI";
    homepage = http://audacity.sourceforge.net;
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ codyopel ];
    platforms = [
      "i686-linux"
      "x86_64-linux"
    ];
  };
}
