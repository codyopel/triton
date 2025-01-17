{ stdenv, fetchurl
, autoreconfHook

, bzip2
, zlib
}:

with {
  inherit (stdenv.lib)
    enFlag;
};

stdenv.mkDerivation rec {
  name = "pcre2-10.20";
  src = fetchurl {
    url = "ftp://ftp.csx.cam.ac.uk/pub/software/programming/pcre/${name}.tar.bz2";
    sha256 = "0yj8mm9ll9zj3v47rvmmqmr1ybxk72rr2lym3rymdsf905qjhbik";
  };

  configureFlags = [
    "--enable-pcre2-8"
    "--enable-pcre2-16"
    "--enable-pcre2-32"
    "--disable-debug"
    "--enable-jit"
    "--enable-pcre2grep-jit"
    "--enable-unicode"
    "--enable-stack-for-recursion"
    (enFlag "pcre2grep-libz" (zlib != null) null)
    (enFlag "pcre2grep-libbz2" (bzip2 != null) null)
    "--disable-pcre2test-libedit"
    "--disable-pcre2test-libreadline"
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
