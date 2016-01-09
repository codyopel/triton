{ stdenv, fetchurl
, cmake

, qt5

, channel ? "5.5"
}:

with {
  inherit (builtins.getAttr "qttools" (import (../.. + "/sources-${channel}.nix")))
    versionMicro
    sha256;
  inherit (stdenv.lib)
    cmFlag;
};

stdenv.mkDerivation rec {
  name = "qttools-${channel}.${versionMicro}";

  src = fetchurl {
    url = "https://download.qt.io/archive/qt/${channel}/" +
          "${channel}.${versionMicro}/submodules/" +
          "qttools-opensource-src-${channel}.${versionMicro}.tar.xz";
    inherit sha256;
  };

  cmakeFlags = [

  ];

  nativeBuildInputs = [
    cmake
  ];

  buildInputs = [
    qt5.qtbase
  ];

  meta = with stdenv.lib; {
    description = "Provides functionality for near-realtime simulation systems";
    homepage = "http://www.qt.io/";
    license = licenses.gpl3;
    maintainers = with maintainers; [ ];
    platforms = [
      "i686-linux"
      "x86_64-linux"
    ];
  };
}
