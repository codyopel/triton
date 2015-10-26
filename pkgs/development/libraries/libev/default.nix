{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "libev-4.20";

  src = fetchurl {
    url = "http://dist.schmorp.de/libev/Attic/${name}.tar.gz";
    sha256 = "17j47pbkr65a18mfvy2861p5k7w4pxmdgiw723ryfqd9gx636w7q";
  };

  meta = with stdenv.lib; {
    description = "A high-performance event loop/event model";
    license = licenses.bsd2; # or GPL2+
    maintainers = [ ];
    platforms = platforms.all;
  };
}
