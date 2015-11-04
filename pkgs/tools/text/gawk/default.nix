{ stdenv, fetchurl
, readlineSupport ? false
  , readline
}:

with {
  inherit (stdenv.lib)
    optional
    wtFlag;
};

stdenv.mkDerivation rec {
  name = "gawk-4.1.3";

  src = fetchurl {
    url = "mirror://gnu/gawk/${name}.tar.xz";
    sha256 = "09d6pmx6h3i2glafm0jd1v1iyrs03vcyv2rkz12jisii3vlmbkz3";
  };

  buildInputs = optional readlineSupport readline;

  configureFlags = [
    (wtFlag "readline" readlineSupport "${readline}")
  ];

  postInstall = "rm $out/bin/gawk-*";

  doCheck = true;
  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "GNU implementation of the Awk programming language";
    homepage = http://www.gnu.org/software/gawk/;
    license = licenses.gpl3Plus;
    maintainers = [ ];
  };
}
