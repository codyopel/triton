{ stdenv, fetchurl, pkgconfig, libxml2, glib }:

stdenv.mkDerivation rec {
  name = "libcroco-${version}";
  versionMajor = "0.6";
  versionMinor = "10";
  version = "${versionMajor}.${versionMinor}";

  src = fetchurl {
    url = "mirror://gnome/sources/libcroco/${versionMajor}/${name}.tar.xz";
    sha256 = "0v14ajhjdhsnlwp2q65629r53hgc0rrzr31653xw9xbpvw8nc1kj";
  };

  outputs = [ "out" "doc" ];

  buildInputs = [ pkgconfig libxml2 glib ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    platforms = platforms.unix;
  };
}
