{ stdenv, fetchurl
, autoreconfHook
# Required
, libogg
, libvorbis
, libxml2
, libxslt
# Optional
, curl
, libkate
, libopus
, libtheora
, openssl
, speex
}:

with {
  inherit (stdenv.lib)
    enFlag
    wtFlag;
};

stdenv.mkDerivation rec {
  name = "icecast-2.4.2";

  src = fetchurl {
    url = "http://downloads.xiph.org/releases/icecast/${name}.tar.gz";
    sha256 = "0krzczymg1mza68sfi5hw46cnncrs54pj959c7ncqm246vxf46ma";
  };

  patches = [
    # Allow disabling libkate, must re-run autoreconf
    # https://bugs.gentoo.org/show_bug.cgi?id=368539
    ./icecast-libkate.patch
  ];

  configureFlags = [
    (enFlag "kate" (libkate != null) null)
    (wtFlag "theora" (libtheora != null) null)
    (wtFlag "speex" (speex != null) null)
    (wtFlag "curl" (curl != null) null)
    (wtFlag "openssl" (openssl != null) null)
    (enFlag "yp" (curl != null) null)
  ];

  nativeBuildInputs = [
    autoreconfHook
  ];

  buildInputs = [
    # Required
    libogg
    libvorbis
    libxml2
    libxslt
    # Optional
    curl
    libkate
    libopus
    libtheora
    openssl
    speex
  ];

  meta = with stdenv.lib; {
    description = "Server software for streaming multimedia";
    homepage = http://www.icecast.org;
    license = licenses.gpl2;
    maintainers = with maintainers; [ ];
  };
}
