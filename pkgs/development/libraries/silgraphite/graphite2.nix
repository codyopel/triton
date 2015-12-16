{ stdenv, fetchurl, pkgconfig, cmake }:

stdenv.mkDerivation rec {
  version = "1.3.3";
  name = "graphite2-${version}";

  src = fetchurl {
    url = "mirror://sourceforge/silgraphite/graphite2/${name}.tgz";
    sha256 = "1n22vvi4jl83m4sqhvd7v31bhyhyd8j6c3yjgh4zjfyrvid16jrg";
  };

  nativeBuildInputs = [
    cmake
    pkgconfig
  ];

  meta = with stdenv.lib; {
    description = "An advanced font engine";
    maintainers = with maintainers; [ ];
    platforms = [
      "i686-linux"
      "x86_64-linux"
    ];
  };
}
