{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "gzip-1.6";

  src = fetchurl {
    url = "mirror://gnu/gzip/${name}.tar.xz";
    sha256 = "0ivqnbhiwd12q8hp3qw6rpsrpw2jg5y2mymk8cn22lsx90dfvprp";
  };

  # In stdenv-linux, prevent a dependency on bootstrap-tools.
  makeFlags = [
    "SHELL=/bin/sh"
    "GREP=grep"
  ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "GNU zip compression program";
    homepage = http://www.gnu.org/software/gzip/;
    license = licenses.gpl3Plus;
    platforms = platforms.all;
  };
}
