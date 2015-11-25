{ stdenv, fetchurl
, python
, pkgconfig
, popt
, intltool
, dbus_glib
, libX11
, xextproto
, libSM
, libICE
, libXtst
, libXi
, gobjectIntrospection
}:

stdenv.mkDerivation rec {
  name = "at-spi2-core-${version}";
  versionMajor = "2.18";
  versionMinor = "3";
  version = "${versionMajor}.${versionMinor}";

  src = fetchurl {
    url = "mirror://gnome/sources/at-spi2-core/${versionMajor}/${name}.tar.xz";
    sha256 = "0afn4x04j5l352vj0dccb2hkpzg3l2vhr8h1yv89fpqmjkfnm8md";
  };

  # ToDo: on non-NixOS we create a symlink from there?
  configureFlags = [
    "--with-dbus-daemondir=/run/current-system/sw/bin/"
  ];

  buildInputs = [
    python
    pkgconfig
    popt
    intltool
    libX11
    xextproto
    libSM
    libICE
    libXtst
    libXi
    gobjectIntrospection
  ];

  propagatedBuildInputs = [
    dbus_glib # pkg-config
  ];

  outputs = [ "out" "doc" ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    platforms = platforms.linux;
  };
}
