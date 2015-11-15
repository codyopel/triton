{ stdenv, fetchurl, pkgconfig, libxml2, glib }:

stdenv.mkDerivation rec {
  name = "libcroco-${version}";
  versionMajor = "0.6";
  versionMinor = "9";
  version = "${versionMajor}.${versionMinor}";

  src = fetchurl {
    url = "mirror://gnome/sources/libcroco/${versionMajor}/${name}.tar.xz";
    sha256 = "1bp01c6974p65wkyj0j6k0glvba5z0d8v9h7rarmagl1s6padf9q";
  };

  outputs = [ "out" "doc" ];

  buildInputs = [ pkgconfig libxml2 glib ];

  meta = with stdenv.lib; {
    platforms = platforms.unix;
  };
}
