{ stdenv, fetchurl
, pkgconfig
, gtk3
, intltool
, xorg
}:

stdenv.mkDerivation rec {
  name = "libwnck-${version}";
  versionMajor = "3.14";
  versionMinor = "0";
  version = "${versionMajor}.${versionMinor}";

  src = fetchurl {
    url = "mirror://gnome/sources/libwnck/${versionMajor}/${name}.tar.xz";
    sha256 = "074jww04z8g9r1acndqap79wx4kbm3rpkf4lcg1v82b66iv0027m";
  };

  patches = [
    ./install_introspection_to_prefix.patch
  ];

  nativeBuildInputs = [
    pkgconfig
    intltool
  ];

  buildInputs = [
    gtk3
    xorg.libX11
    xorg.libXi
    xorg.libXext
    xorg.libXfixes
  ];
}
