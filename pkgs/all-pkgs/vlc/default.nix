{ stdenv, fetchurl
, pkgconfig

, a52dec
, alsaLib
, avahi
, bzip2
, dbus
, faad2
, flac
, ffmpeg
, freefont_ttf
, fribidi
, gnutls
, libass
, libbluray
, libcaca
, libcddb
, libdc1394
, libdvbpsi
, libdvdnav
, libebml
, libgcrypt
, libjack2
, libkate
, libmad
, libmatroska
, libmtp
, liboggz
, libopus
, libpulseaudio
, libraw1394
, librsvg
, libsamplerate
, libtheora
, libtiff
, libtiger
, libupnp
, libv4l
, libva
, libvdpau
, libvorbis
, libxml2
, lua
, mpeg2dec
, perl
, qt4
, samba
, schroedinger
, SDL
, SDL_image
, speex
, taglib
, udev
, unzip
, xorg
, xz
, zlib

, onlyLibVLC ? false
}:

with {
  inherit (stdenv.lib)
    optional;
};

stdenv.mkDerivation rec {
  name = "vlc-${version}";
  version = "2.2.1";

  src = fetchurl {
    url = "http://download.videolan.org/vlc/${version}/${name}.tar.xz";
    sha256 = "1jqzrzrpw6932lbkf863xk8cfmn4z2ngbxz7w8ggmh4f6xz9sgal";
  };

  patches = [
    ./lua_53_compat.patch
  ];

  configureFlags = [
    "--enable-alsa"
    "--with-kde-solid=$out/share/apps/solid/actions"
    "--enable-dc1394"
    "--enable-ncurses"
    "--enable-vdpau"
    "--enable-dvdnav"
    "--enable-samplerate"
  ] ++ optional onlyLibVLC  "--disable-vlc";

  preConfigure = ''
    sed -e "s@/bin/echo@echo@g" -i configure
  '';

  nativeBuildInputs = [
    pkgconfig
  ];

  buildInputs = [
    a52dec
    alsaLib
    avahi
    bzip2
    dbus
    faad2
    flac
    ffmpeg
    freefont_ttf
    fribidi
    gnutls
    libass
    libbluray
    libcaca
    libcddb
    libdc1394
    libdvbpsi
    libdvdnav
    libdvdnav.libdvdread
    libebml
    libgcrypt
    libjack2
    libkate
    libmad
    libmatroska
    libmtp
    liboggz
    libopus
    libpulseaudio
    libraw1394
    librsvg
    libsamplerate
    libtheora
    libtiff
    libtiger
    libupnp
    libv4l
    libva
    libvdpau
    libvorbis
    libxml2
    lua
    mpeg2dec
    perl
    qt4
    samba
    schroedinger
    SDL
    SDL_image
    speex
    taglib
    udev
    unzip
    xorg.xcbutilkeysyms
    xorg.libXpm
    xorg.xlibsWrapper
    xorg.libXv
    xorg.libXvMC
    xz
    zlib
  ];

  preBuild = ''
    substituteInPlace \
      modules/text_renderer/freetype.c \
      --replace /usr/share/fonts/truetype/freefont/FreeSerifBold.ttf \
      ${freefont_ttf}/share/fonts/truetype/FreeSerifBold.ttf
  '';

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "Cross-platform media player and streaming server";
    homepage = http://www.videolan.org/vlc/;
    platforms = platforms.linux;
    license = licenses.lgpl21Plus;
  };
}