{ stdenv, fetchurl
, xcb-util-cursor
, xorg
}:

stdenv.mkDerivation rec {
  name = "spectrwm-2.7.2";

  src = fetchurl {
    url = "https://github.com/conformal/spectrwm/archive/SPECTRWM_2_7_2.tar.gz";
    sha256 = "1yssqnhxlfl1b60gziqp8c5pzs1lr8p6anrnp9ga1zfdql3b7993";
  };

  sourceRoot = "spectrwm-SPECTRWM_2_7_2/linux";

  makeFlags = [
    "PREFIX=$(out)"
  ];

  buildInputs = [
    xcb-util-cursor
    xorg.libX11
    xorg.libxcb
    xorg.libXcursor
    xorg.libXft
    xorg.libXrandr
    xorg.libXt
    xorg.xcbutil
    xorg.xcbutilkeysyms
    xorg.xcbutilwm
  ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "A tiling window manager";
    homepage = "https://github.com/conformal/spectrwm";
    license = licenses.isc;
    maintainers = with maintainers; [ ];
    platforms = [
      "i686-linux"
      "x86_64-linux"
    ];
  };

}
