{ fetchurl, stdenv, zlib }:

stdenv.mkDerivation rec {
  name = "fastjar-0.98";

  src = fetchurl {
    url = "mirror://savannah/fastjar/${name}.tar.gz";
    sha256 = "0iginbz2m15hcsa3x4y7v3mhk54gr1r7m3ghx0pg4n46vv2snmpi";
  };

  buildInputs = [ zlib ];

  doCheck = true;

  meta = {
    description = "Fast Java archiver written in C";

    longDescription = ''
      Fastjar is a version of Sun's `jar' utility, written entirely in C, and
      therefore quite a bit faster.  Fastjar can be up to 100x faster than
      the stock `jar' program running without a JIT.
    '';

    homepage = http://savannah.nongnu.org/projects/fastjar/;

    license = stdenv.lib.licenses.gpl2Plus;
    platforms = stdenv.lib.platforms.linux;
    maintainers = [ ];
  };
}
