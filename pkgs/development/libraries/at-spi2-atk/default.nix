{ stdenv, fetchurl
, python
, pkgconfig
, popt
, atk
, libX11
, libICE
, xorg
, libXi
, intltool
, dbus_glib
, at_spi2_core
, libSM
}:

stdenv.mkDerivation rec {
  name = "at-spi2-atk-${version}";
  versionMajor = "2.18";
  versionMinor = "1";
  version = "${versionMajor}.${versionMinor}";

  src = fetchurl {
    url = "mirror://gnome/sources/at-spi2-atk/${versionMajor}/${name}.tar.xz";
    sha256 = "0bf1g5cj84rmx7p1q547vwbc0hlpcs2wrxnmv96lckfkhs9mzcf4";
  };

  buildInputs = [
    python
    pkgconfig
    popt
    atk
    libX11
    libICE
    xorg.libXtst
    libXi
    intltool
    dbus_glib
    at_spi2_core
    libSM
  ];

  meta = with stdenv.lib; {
    platforms = platforms.linux;
  };
}