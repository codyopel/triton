{ stdenv, fetchgit
, zlib
, openssl
}:

stdenv.mkDerivation rec {
  name = "rtmpdump-${version}";
  version = "2015-01-15";

  src = fetchgit {
    url = git://git.ffmpeg.org/rtmpdump;
    # Currently the latest commit is used (a release has not been made since 2011, i.e. '2.4')
    rev = "a107cef9b392616dff54fabfd37f985ee2190a6f";
    sha256 = "178h5j7w20g2h9mn6cb7dfr3fa4g4850hpl1lzxmi0nk3blzcsvl";
  };

  makeFlags = [
    ''prefix=$(out)''
    "CRYPTO=OPENSSL"
  ];

  propagatedBuildInputs = [
    zlib
    openssl
  ];

  meta = with stdenv.lib; {
    description = "Toolkit for RTMP streams";
    homepage = http://rtmpdump.mplayerhq.hu/;
    license = licenses.gpl2;
    maintainers = with maintainers; [ codyopel ];
    platforms = platforms.unix;
  };
}
