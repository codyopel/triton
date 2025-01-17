{stdenv, fetchurl, pkgconfig, openssl, libogg, libopus}:

stdenv.mkDerivation rec {
  name = "opusfile-0.6";
  src = fetchurl {
    url = "http://downloads.xiph.org/releases/opus/${name}.tar.gz";
    sha256 = "19iys2kld75k0210b807i4illrdmj3cmmnrgxlc9y4vf6mxp2a14";
  };

  buildInputs = [ pkgconfig openssl libogg libopus ];

  enableParallelBuilding = true;

  meta = {
    description = "High-level API for decoding and seeking in .opus files";
    homepage = http://www.opus-codec.org/;
    license = stdenv.lib.licenses.bsd3;
    maintainers = with stdenv.lib.maintainers; [ fuuzetsu ];
  };
}
