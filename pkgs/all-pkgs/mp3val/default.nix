{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "mp3val-${version}";
  version = "0.1.8";

  src = fetchurl {
    url = "mirror://sourceforge/mp3val/${name}-src.tar.gz";
    sha256 = "17y3646ghr38r620vkrxin3dksxqig5yb3nn4cfv6arm7kz6x8cm";
  };

  makefile = "Makefile.linux";

  installPhase = ''
    install -Dv mp3val "$out/bin/mp3val"
  '';

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "A tool for validating and repairing MPEG audio streams";
    homepage = http://mp3val.sourceforge.net/index.shtml;
    license = licenses.gpl2;
    maintainers = [ ];
    platforms = platforms.unix;
  };
}