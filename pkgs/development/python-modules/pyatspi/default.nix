{ stdenv, fetchurl
, pkgconfig
, python3
, pygobject
, at_spi2_core
, gtk2
}:

stdenv.mkDerivation rec {
  name = "pyatspi-${version}";
  versionMajor = "2.18";
  versionMinor = "0";
  version = "${versionMajor}.${versionMinor}";

  src = fetchurl {
    url = "mirror://gnome/sources/pyatspi/${versionMajor}/${name}.tar.xz";
    sha256 = "0imbyk2v6c11da7pkwz91313pkkldxs8zfg81zb2ql6h0nnh6vzq";
  };

  buildInputs = [
    pkgconfig
    python3
    pygobject
    at_spi2_core
    gtk2
  ];

  meta = with stdenv.lib; {
    description = "Python 3 bindings for at-spi";
    homepage = http://www.linuxfoundation.org/en/AT-SPI_on_D-Bus;
    license = licenses.gpl2;
    maintainers = with maintainers; [ jgeerds ];
  };
}
