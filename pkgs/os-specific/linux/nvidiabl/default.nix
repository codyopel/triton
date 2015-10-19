{ stdenv, fetchurl
, kernel
}:

stdenv.mkDerivation {
  name = "nvidiabl-0.87-${kernel.version}";

  src = fetchurl {
    url = "https://github.com/guillaumezin/nvidiabl/archive/v0.87.tar.gz";
    sha256 = "0daybk0an7wndcmz3ljxwp9x9xqfs5mfp61gdcdyy5yf1i93b855";
  };

  patches = [
    ./linux4compat.patch
  ];

  makeFlags = [
    "KDIR=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
    "DESTDIR=$(out)"
    "KVER=${kernel.modDirVersion}"
  ];

  preConfigure = ''
    sed -i 's|/sbin/depmod|#/sbin/depmod|' Makefile
  '';

  meta = {
    description = "Linux driver for setting the backlight brightness on laptops using NVIDIA GPU";
    homepage = https://github.com/guillaumezin/nvidiabl;
    license = stdenv.lib.licenses.gpl2;
  };
}
