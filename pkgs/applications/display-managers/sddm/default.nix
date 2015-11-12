{ stdenv, fetchpatch, fetchFromGitHub, cmake, pkgconfig, libxcb
, libpthreadstubs, libXdmcp, libXau, qtbase, qtdeclarative, qttools, pam
, systemd
}:

let
  version = "0.13.0";
in
stdenv.mkDerivation rec {
  name = "sddm-${version}";

  src = fetchFromGitHub {
    owner = "sddm";
    repo = "sddm";
    rev = "v${version}";
    sha256 = "0c3q8lpb123m9k5x3i71mm8lmyzhknw77zxh89yfl8qmn6zd61i1";
  };

  nativeBuildInputs = [ cmake pkgconfig qttools ];

  buildInputs = [ libxcb libpthreadstubs libXdmcp libXau qtbase qtdeclarative pam systemd ];

  patches = [ (fetchpatch {
                url = "https://github.com/sddm/sddm/commit/9bc21ee7da5de6b2531d47d1af4d7b0a169990b9.patch";
                sha256 = "1pda0wf4xljdadja7iyh5c48h0347imadg9ya1dw5slgb7w1d94l";
              })
              ./cmake_paths.patch
            ];

  cmakeFlags = [ "-DCONFIG_FILE=/etc/sddm.conf" ];

  preConfigure = ''
    export cmakeFlags="$cmakeFlags -DQT_IMPORTS_DIR=$out/lib/qt5/qml -DCMAKE_INSTALL_SYSCONFDIR=$out/etc -DSYSTEMD_SYSTEM_UNIT_DIR=$out/lib/systemd/system"
  '';

  postInstall = ''
    wrapQtProgram $out/bin/sddm
    wrapQtProgram $out/bin/sddm-greeter
  '';

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "QML based X11 display manager";
    homepage = https://github.com/sddm/sddm;
    platforms = platforms.linux;
    maintainers = with maintainers; [ abbradar ];
  };
}
