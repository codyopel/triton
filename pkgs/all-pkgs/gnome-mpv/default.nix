{ stdenv, fetchurl
, autoconf
, autoconf-archive
, automake
, gettext
, intltool
, libtool
, makeWrapper
, pkgconfig

, glib
, gnome3
, gtk3
, epoxy
, librsvg
, mpv
, wayland
, xorg
, youtube-dl
}:

stdenv.mkDerivation rec {
  name = "gnome-mpv-${version}";
  version = "0.6";

  src = fetchurl {
    url = "https://github.com/gnome-mpv/gnome-mpv/archive/v${version}.tar.gz";
    sha256 = "1h1m6igagcbd7mdmsg0476z5vq126ksqfnv2my90mk2m41dlqm71";
  };

  configureFlags = ''
    "--disable-maintainer-mode"
    "--enable-nls"
    "--enable-schemas-compile"
    "--disable-debug"
  '';

  preConfigure = ''
    # Ignore autogen.sh and run the command manually
    aclocal --install -I m4
    intltoolize --copy --automake
    autoreconf --install -Wno-portability
  '';

  NIX_CFLAGS_COMPILE = [
    "-I${glib}/include/gio-unix-2.0"
  ];

  nativeBuildInputs = [
    autoconf
    autoconf-archive
    automake
    gettext
    intltool
    libtool
    makeWrapper
    pkgconfig
  ];

  buildInputs = [
    glib
    gtk3
    epoxy
    librsvg
    mpv
    wayland
    xorg.libX11
    youtube-dl
  ];

  meta = with stdenv.lib; {
    description = "A simple GTK+ frontend for mpv";
    homepage = https://github.com/gnome-mpv/gnome-mpv;
    license = licenses.gpl3;
    maintainers = [ ];
    platforms = [
      "i686-linux"
      "x86_64-linux"
    ];
  };
}