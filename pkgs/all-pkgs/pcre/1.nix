{ stdenv, fetchurl
, autoreconfHook

, bzip2
, zlib

, unicodeSupport ? true
, cplusplusSupport ? true
}:

with {
  inherit (stdenv.lib)
    enFlag;
};

stdenv.mkDerivation rec {
  name = "pcre-8.38";

  src = fetchurl {
    url = "ftp://ftp.csx.cam.ac.uk/pub/software/programming/pcre/${name}.tar.bz2";
    sha256 = "1pvra19ljkr5ky35y2iywjnsckrs9ch2anrf5b0dc91hw8v2vq5r";
  };

  configureFlags = [
    "--enable-pcre8"
    "--enable-pcre16"
    "--enable-pcre32"
    (enFlag "cpp" cplusplusSupport null)
    "--enable-jit"
    "--enable-pcregrep-jit"
    "--enable-utf"
    (enFlag "unicode-properties" unicodeSupport null)
    (enFlag "pcregrep-libz" (zlib != null) null)
    (enFlag "pcregrep-libbz2" (bzip2 != null) null)
    "--disable-pcretest-libedit"
    "--disable-pcretest-libreadline"
    "--disable-valgrind"
    "--disable-coverage"
  ];

  nativeBuildInputs = [
    autoreconfHook
  ];

  buildInputs = [
    bzip2
    zlib
  ];

  outputs = [ "out" "doc" "man" ];

  doCheck = true;
  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "Perl Compatible Regular Expressions";
    homepage = "http://www.pcre.org/";
    license = licenses.bsd3;
    maintainers = [ ];
    platforms = platforms.all;
  };
}
