{ stdenv, fetchurl

, alsaLib
, dbus
, libjack2
, qt4
}:

# TODO: add qt5 support

stdenv.mkDerivation rec {
  version = "0.4.1";
  name = "qjackctl-${version}";

  src = fetchurl {
    url = "mirror://sourceforge/qjackctl/${name}.tar.gz";
    sha256 = "1ldzw84vb0x51y7r2sizx1hj4js9sr8s1v8g55nc2npmm4g4w0lq";
  };

  configureFlags = [
    "--disable-debug"
    "--enable-qt4"
    "--disable-qt5"
    "--enable-system-tray"
    "--enable-jack-midi"
    "--enable-jack-session"
    "--enable-jack-port-aliases"
    "--enable-jack-metadata"
    "--enable-jack-version"
    "--enable-alsa-seq"
    "--enable-portaudio"
    "--enable-dbus"
    "--enable-xunique"
    "--disable-stacktrace"
  ];

  buildInputs = [
    alsaLib
    dbus
    libjack2
    qt4
  ];

  meta = with stdenv.lib; {
    description = "Application to control the JACK sound server daemon";
    homepage = http://qjackctl.sourceforge.net/;
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ codyopel ];
    platforms = platforms.linux;
  };
}
