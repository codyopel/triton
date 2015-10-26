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
  name = "tinc-1.1pre-2015-09-25";

  src = fetchgit {
    url = "git://tinc-vpn.org/tinc";
    rev = "73068238436d8a22abb86e67b08f573b09fd04e1";
    sha256 = "1j8bvvzvciy21s24jdpi089svy7wipg9pm84s98xjlp2plchj5dj";
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
