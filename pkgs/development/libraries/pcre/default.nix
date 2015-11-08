{ stdenv, fetchurl
, unicodeSupport ? true
, cplusplusSupport ? true
}:

stdenv.mkDerivation rec {
  #name = "pcre-8.37";
  name = "pcre-8.38-RC1";

  src = fetchurl {
    #url = "ftp://ftp.csx.cam.ac.uk/pub/software/programming/pcre/${name}.tar.bz2";
    #sha256 = "17bqykp604p7376wj3q2nmjdhrb6v1ny8q08zdwi7qvc02l9wrsi";
    url = "http://pub.wak.io/nixos/tarballs/${name}.tar.bz2";
    sha256 = "60106bd136df843b9542127ffe6767e66a8d8452de345b1ed5c9e1b7f2376379";
  };

  #patches = [
  #  ./cve-2015-3210.patch
  #  ./cve-2015-5073.patch
  #];

  configureFlags = ''
    --enable-jit
    ${if unicodeSupport then "--enable-unicode-properties" else ""}
    ${if !cplusplusSupport then "--disable-cpp" else ""}
  '';

  outputs = [ "out" "doc" "man" ];

  # we are running out of stack on both freeBSDs on Hydra
  doCheck = with stdenv; !isFreeBSD;

  meta = with stdenv.lib; {
    homepage = "http://www.pcre.org/";
    description = "A library for Perl Compatible Regular Expressions";
    license = licenses.bsd3;
    maintainers = [ ];
    platforms = platforms.all;
  };
}
