{ stdenv, fetchurl
, pkgconfig

# Required
, boost
, glib

# Optional
, alsaLib
, audiofile
, avahi
, bzip2
, curl
, dbus
, expat
, faad2
, ffmpeg
, flac
, fluidsynth
, game-music-emu
, icu
, lame
, libao
, libiconv
, libid3tag
, libjack2
, libmad
, libmikmod
, libmms
, libmodplug
, libopus
, libpulseaudio
, libsamplerate
, libshout
, libsndfile
, libupnp
, libvorbis
, mpd_clientlib
, mpg123
, openal
, samba
, shout
, soxr
, sqlite
, systemd
#, twolame
#, wavpack
, yajl
, zlib
, zziplib
# Options
, debugSupport ? false
, documentationSupport ? false
  , xmlto
  , doxygen
}:

with {
  inherit (stdenv.lib)
    enFlag
    wtFlag
    optional
    optionals;
};

stdenv.mkDerivation rec {
  name = "mpd-${version}";
  versionMajor = "0.19";
  versionMinor = "10";
  version = "${versionMajor}.${versionMinor}";

  src = fetchurl {
    url    = "http://www.musicpd.org/download/mpd/${versionMajor}/${name}.tar.xz";
    sha256 = "0laqn68iggqf0h06hg282cvpd9wsjqpjfg5fnn9wk3gr48yyp1n3";
  };

  configureFlags = [
    (enFlag "aac" (faad2 != null) null)
    # TODO: adplug support
    #(enFlag "adplug" true null)
    (enFlag "alsa" (alsaLib != null) null)
    (enFlag "audiofile" (audiofile != null) null)
    (enFlag "bzip2" (bzip2 != null) null)
    # TODO: cdio-paranoia support
    #(enFlag "cdio-paranoia" (libcdio != null) null)
    (enFlag "curl" (curl != null) null)
    (enFlag "database" true null)
    (enFlag "dsd" true null)
    (enFlag "fifo" true null)
    (enFlag "ffmpeg" (ffmpeg != null) null)
    (enFlag "flac" (flac != null) null)
    (enFlag "fluidsynth" (fluidsynth != null) null)
    (enFlag "gme" (game-music-emu != null) null)
    (enFlag "haiku" true null)
    (enFlag "httpd-output" true null)
    (enFlag "iconv" (libiconv != null) null)
    (enFlag "icu" (icu != null) null)
    (enFlag "id3" (libid3tag != null) null)
    (enFlag "inotify" true null)
    (enFlag "ipv6" true null)
    (enFlag "jack" (libjack2 != null) null)
    (enFlag "lame-encoder" (lame != null) null)
    (enFlag "libmpdclient" (mpd_clientlib != null) null)
    # TODO: libwrap support
    #(enFlag "libwrap" true null)
    (enFlag "sndfile" (libsndfile != null) null)
    (enFlag "lsr" (libsamplerate != null) null)
    (enFlag "mad" (libmad != null) null)
    (enFlag "mikmod" (libmikmod != null) null)
    (enFlag "mms" (libmms != null) null)
    (enFlag "modplug" (libmodplug != null) null)
    (enFlag "mpg123" (mpg123 != null) null)
    (enFlag "neighbor-plugins" true null)
    (enFlag "openal" (openal != null) null)
    (enFlag "opus" (libopus != null) null)
    (enFlag "oss" true null)
    "--disable-osx"
    (enFlag "pipe-output" true null)
    (enFlag "pulse" (libpulseaudio != null) null)
    (enFlag "shout" (libshout != null) null)
    "--disable-solaris-output"
    (enFlag "soundcloud" (yajl != null) null)
    (enFlag "sqlite" (sqlite != null) null)
    # TODO: twolame support
    #(enFlag "twolame" (twolame != null) null)
    (enFlag "un" true null)
    (enFlag "upnp" (libupnp != null) null)
    (enFlag "vorbis" (libvorbis != null) null)
    (enFlag "vorbis-encoder" (libvorbis != null) null)
    (enFlag "wave-encoder" true null)
    # FIXME: wavpack support
    #(enFlag "wavpack" (wavpack != null) null)
    (wtFlag "zeroconf" (avahi != null && dbus != null) "avahi")
    (enFlag "zlib" (zlib != null) null)
    (enFlag "zzip" (zziplib != null) null)

    (wtFlag "systemdsystemunitdir" (systemd != null) "$(out)/etc/systemd/system")
    (enFlag "debug" debugSupport null)
    (enFlag "documentation" documentationSupport null)
    (enFlag "werror" false null)
  ];

  NIX_LDFLAGS = [ ] ++ optional (libshout != null) "-lshout";

  nativeBuildInputs = [
    pkgconfig
  ];

  buildInputs = [
    # Required
    boost
    glib
    # Optional
    alsaLib
    audiofile
    avahi
    bzip2
    curl
    dbus
    expat
    faad2
    ffmpeg
    flac
    fluidsynth
    game-music-emu
    icu
    lame
    libao
    libiconv
    libid3tag
    libjack2
    libmad
    libmikmod
    libmms
    libmodplug
    libopus
    libpulseaudio
    libsamplerate
    libshout
    libsndfile
    libupnp
    libvorbis
    mpd_clientlib
    mpg123
    openal
    soxr
    sqlite
    systemd
    #wavpack
    yajl
    zlib
    zziplib
  ] ++ optionals documentationSupport [
    doxygen
    xmlto
  ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "A flexible, powerful daemon for playing music";
    homepage = http://www.musicpd.org/;
    license = licenses.gpl2;
    maintainers = with maintainers; [ codyopel ];
    platforms = platforms.unix;
  };
}