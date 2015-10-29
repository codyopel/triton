{ stdenv, fetchgit
, cmake
, pkgconfig

, libtiff
, tesseract
}:

stdenv.mkDerivation rec {
  name = "vobsub2srt-${version}";
  version = "2015-09-30";

  src = fetchgit {
    url = https://github.com/ruediger/VobSub2SRT.git;
    rev = "573097e835b72e4a81a1cc6f750e945fab702b19";
    sha256 = "0gxyl89i9mg4jiyavblibvpb7df2nmh1m983012qacmn3dxd5ffb";
  };

  patchPhase = ''
    rm -f ./configure
  '';

  cmakeFlags = [
    "-DBUILD_STATIC=OFF"
  ];

  nativeBuildInputs = [
    cmake
    pkgconfig
  ];

  buildInputs = [
    libtiff
    tesseract
  ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "Converts VobSub subtitles into SRT subtitles";
    homepage = https://github.com/ruediger/VobSub2SRT;
    license = licenses.gpl3Plus;
    maintainers = [ ];
    platforms = platforms.unix;
  };
}
