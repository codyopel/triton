{ stdenv, fetchurl, pkgconfig, gnome3, gtk3
, itstool, libxml2, python3, python3Packages, pyatspi, at_spi2_core
, dbus, intltool, libwnck3 }:

stdenv.mkDerivation rec {
  name = "accerciser-3.14.0";

  src = fetchurl {
    url = "mirror://gnome/sources/accerciser/3.14/${name}.tar.xz";
    sha256 = "0x05gpajpcs01g7m34g6fxz8122cf9kx3k0lchwl34jy8xfr39gm";
  };

  buildInputs = [
    pkgconfig gtk3 itstool libxml2 python3 pyatspi
    python3Packages.pygobject python3Packages.ipython
    at_spi2_core dbus intltool libwnck3 gnome3.defaultIconTheme
  ];

  wrapPrefixVariables = [ "PYTHONPATH" ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    homepage = https://wiki.gnome.org/Apps/Accerciser;
    description = "Interactive Python accessibility explorer";
    maintainers = gnome3.maintainers;
    license = licenses.bsd3;
    platforms = platforms.linux;
  };
}
