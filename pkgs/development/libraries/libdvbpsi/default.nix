{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "libdvbpsi-${version}";
  version = "1.3.0";

  src = fetchurl {
    url = "http://download.videolan.org/pub/libdvbpsi/${version}/" +
          "${name}.tar.bz2";
    sha256 = "1zm1n1np0nmx209m66ky4bvf06978vi2j7xxkf8jyrl0378x3zm2";
  };

  meta = with stdenv.lib; {
    description = "Library for decoding & generation of MPEG TS and DVB PSI tables";
    homepage = http://www.videolan.org/developers/libdvbpsi.html ;
    license = licenses.lgpl21;
    platforms = [
      "i686-linux"
      "x86_64-linux"
    ];
  };
}
