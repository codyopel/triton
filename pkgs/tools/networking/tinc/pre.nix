{ stdenv, fetchgit
, autoreconfHook
, texinfo

, ncurses
, lzo
, openssl
, readline
, zlib
}:

stdenv.mkDerivation rec {
  name = "tinc-1.1pre-2015-11-26";

  src = fetchgit {
    url = "git://tinc-vpn.org/tinc";
    rev = "cef40b8b978694fc0e7c02e292fcbb60806bf028";
    sha256 = "0xs0pps8n380d42x1qjv3j6yfxqxmxzcppz1c1s7a8lmi3cy161n";
  };

  configureFlags = [
    "--sysconfdir=/etc"
    "--localstatedir=/var"
  ];

  nativeBuildInputs = [
    autoreconfHook
    texinfo
  ];

  buildInputs = [
    ncurses
    lzo
    openssl
    readline
    zlib
  ];

  meta = with stdenv.lib; {
    description = "VPN daemon with full mesh routing";
    homepage = http://www.tinc-vpn.org/;
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ wkennington ];
    platforms = platforms.linux;
  };
}
