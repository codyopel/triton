{ stdenv, fetchurl
, valgrind
}:

with {
  inherit (stdenv.lib)
    optional;
};

stdenv.mkDerivation rec {
  name = "lz4-${version}";
  version = "131";

  src = fetchurl {
    url = "https://github.com/Cyan4973/lz4/archive/r${version}.tar.gz";
    sha256 = "1vfg305zvj50hwscad24wan9jar6nqj14gdk2hqyr7bb9mhh0kcx";
  };

  makeFlags = [
    "PREFIX=$(out)"
  ];

  buildInputs = optional doCheck valgrind;

  # tests take a very long time
  doCheck = false;
  checkTarget = "test";
  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "Extremely fast compression algorithm";
    homepage = http://www.lz4.org/;
    license = with licenses; [ bsd2 gpl2Plus ];
    maintainers = with maintainers; [ ];
    platforms = platforms.linux;
  };
}
