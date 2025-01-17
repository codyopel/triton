{ stdenv, fetchurl, alsaLib, bash, help2man, pkgconfig, xlibsWrapper, python3, libxslt }:

stdenv.mkDerivation rec {
  name = "lirc-0.9.3a";

  src = fetchurl {
    url = "mirror://sourceforge/lirc/${name}.tar.bz2";
    sha256 = "08pgfsi40d0iq0xwnfkz53whphcnsx8ycxvp65anzd6vrgv0rzws";
  };

  preBuild = "patchShebangs .";

  buildInputs = [ alsaLib help2man pkgconfig xlibsWrapper python3 libxslt ];

  configureFlags = [
    "--with-driver=devinput"
    "--sysconfdir=/etc"
    "--localstatedir=/var"
    "--enable-sandboxed"
  ];

  makeFlags = [ "m4dir=$(out)/m4" ];

  installFlags = [
    "sysconfdir=\${out}/etc"
    "localstatedir=\${TMPDIR}"
  ];

  meta = with stdenv.lib; {
    description = "Allows to receive and send infrared signals";
    homepage = http://www.lirc.org/;
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = with maintainers; [ pSub ];
  };
}
