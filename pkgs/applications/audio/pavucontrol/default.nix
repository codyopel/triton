{ fetchurl, stdenv
, gettext
, intltool
, pkgconfig

, libpulseaudio
, gtkmm
, libcanberra_gtk3
, librsvg
, gnome3
}:

stdenv.mkDerivation rec {
  name = "pavucontrol-3.0";

  src = fetchurl {
    url = "http://freedesktop.org/software/pulseaudio/pavucontrol/${name}.tar.xz";
    sha256 = "14486c6lmmirkhscbfygz114f6yzf97h35n3h3pdr27w4mdfmlmk";
  };

  configureFlags = [
    "--enable-gtk3"
    "--disable-lynx"
    "--enable-nls"
  ];

  nativeBuildInputs = [
    gettext
    intltool
    pkgconfig
  ];

  buildInputs = [
    libpulseaudio
    gtkmm
    libcanberra_gtk3
    librsvg
    gnome3.defaultIconTheme
  ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "PulseAudio Volume Control";
    homepage = http://freedesktop.org/software/pulseaudio/pavucontrol/ ;
    license = stdenv.lib.licenses.gpl2Plus;
    maintainers = with maintainers; [ ];
    platforms = platforms.linux;
  };
}
