{ stdenv, fetchurl }:

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
    "--enable-pcre2grep-git"
    "--enable-rebuild-chartables"
    "--enable-unicode"
  ];

  meta = with stdenv.lib; {
    description = "Perl Compatible Regular Expressions";
    homepage = "http://www.pcre.org/";
    license = licenses.bsd3;
    maintainers = [ ];
    platforms = platforms.all;
  };
}
