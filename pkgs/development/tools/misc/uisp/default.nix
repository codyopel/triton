{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "uisp-20050207";

  src = fetchurl {
    url = "mirror://gentoo/${name}.tar.gz";
    sha256 = "1bncxp5yxh9r1yrp04vvhfiva8livi1pwic7v8xj99q09zrwahvw";
  };

  meta = {
    description = "Tool for AVR microcontrollers which can interface to many hardware in-system programmers";
    license = stdenv.lib.licenses.gpl2;
    homepage = http://savannah.nongnu.org/projects/uisp;
  };
}
