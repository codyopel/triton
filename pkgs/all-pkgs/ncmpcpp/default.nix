{ stdenv, fetchurl
, pkgconfig
# Required
, boost
, icu
, mpd_clientlib
, ncurses
, readline
, libiconv
# Optional
, curl # Lyric fetching
, fftw # Visualizer screen
, taglib # Tag editor screen
, outputsSupport ? false # outputs screen
, clockSupport ? false # clock screen
}:

with {
  inherit (stdenv.lib)
    enFlag
    optional
    wtFlag;
};

stdenv.mkDerivation rec {
  name = "ncmpcpp-${version}";
  version = "0.7";

  src = fetchurl {
    url = "http://ncmpcpp.rybczak.net/stable/${name}.tar.bz2";
    sha256 = "0xzz0g9whqjcjaaqmsw5ph1zvpi2j5v3i5k73g7916rca3q4z4jh";
  };

  configureFlags = [
    "BOOST_LIB_SUFFIX="
    (enFlag "outputs" outputsSupport null)
    (enFlag "visualizer" (fftw != null) null)
    (enFlag "clock" clockSupport null)
    "--enable-unicode"
    (wtFlag "curl" (curl != null) null)
    (wtFlag "fftw" (fftw != null) null)
    "--without-pdcurses"
    (wtFlag "taglib" (taglib != null) null)
  ];

  nativeBuildInputs = [
    pkgconfig
  ];

  buildInputs = [
    boost
    curl
    fftw
    icu
    libiconv
    mpd_clientlib
    ncurses
    readline
    taglib
  ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "A featureful ncurses based MPD client inspired by ncmpc";
    homepage = http://ncmpcpp.rybczak.net/;
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ ];
    platforms = [
      "i686-linux"
      "x86_64-linux"
    ];
  };
}
