{ stdenv, fetchFromGitHub
, autoreconfHook
, pkgconfig

, cairo
, ffmpeg
, ffms
, libjpeg_original
, log4cpp
, pango

# Optional
, qt4 # Avxedit support
}:

with {
  inherit (stdenv.lib)
    enFlag
    optional;
};

stdenv.mkDerivation rec {
  name = "avxsynth-${version}";
  version = "2015-04-07";

  src = fetchFromGitHub {
    owner = "avxsynth";
    repo = "avxsynth";
    rev = "80dcb7ec8d314bc158130c92803308aa8e5e9242";
    sha256 = "0kckggvgv68b0qjdi7ms8vi97b46dl63n60qr96d2w67lf2nk87z";
  };

  configureFlags = [
    "--enable-autocrop"
    "--enable-framecapture"
    "--enable-subtitle"
    "--enable-ffms2"
    (enFlag "avxedit" (qt4 != null) null)
    "--with-jpeg=${libjpeg}/lib"
  ];

  nativeBuildInputs = [
    autoreconfHook
    pkgconfig
  ];

  buildInputs = [
    cairo
    ffmpeg
    ffms
    libjpeg
    log4cpp
    pango
    qt4
  ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "A script system that allows advanced non-linear editing";
    homepage = https://github.com/avxsynth/avxsynth;
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ codyopel ];
    platforms = platforms.linux;
  };
}