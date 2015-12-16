{ stdenv, fetchurl
, pkgconfig

, libusb1
}:

stdenv.mkDerivation rec {
  name = "libmtp-1.1.10";

  src = fetchurl {
    url = "mirror://sourceforge/libmtp/${name}.tar.gz";
    sha256 = "0183r5is1z6qmdbj28ryz8k8dqijll4drzh8lic9xqig0m68vvhy";
  };

  configureFlags = [
    "--with-udev=$$out/lib/udev"
  ];

  nativeBuildInputs = [
    pkgconfig
  ];

  propagatedBuildInputs = [
    libusb1
  ];

  meta = with stdenv.lib; {
    description = "An implementation of Microsoft's Media Transfer Protocol";
    homepage = http://libmtp.sourceforge.net;
    maintainers = [ ];
    platforms = [
      "i686-linux"
      "x86_64-linux"
    ];
  };
}
