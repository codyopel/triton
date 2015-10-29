{ stdenv, fetchurl
, pkgconfig
# Optional
, fftw
, libsndfile
, werror ? false
, optimizations ? true
, cpuclip ? true
}:

with {
  inherit (stdenv.lib)
    enFlag;
};

stdenv.mkDerivation rec {
  name = "libsamplerate-0.1.8";

  src = fetchurl {
    url = "http://www.mega-nerd.com/SRC/${name}.tar.gz";
    sha256 = "01hw5xjbjavh412y63brcslj5hi9wdgkjd3h9csx5rnm8vglpdck";
  };

  configureFlags = [
    (enFlag "fftw" (fftw != null) null)
    (enFlag "sndfile" (libsndfile != null) null)
    (enFlag "gcc-werror" werror null)
    (enFlag "gcc-pipe" true null)
    (enFlag "gcc-opt" optimizations null)
    (enFlag "cpu-clip" cpuclip null)
  ];

  nativeBuildInputs = [
    pkgconfig
  ];

  buildInputs = [
    fftw
    libsndfile
  ];

  meta = with stdenv.lib; {
    description = "Sample Rate Converter for audio";
    homepage = http://www.mega-nerd.com/SRC/index.html;
    licenses = licenses.gpl3;
    maintainers = with maintainers; [ wkennington ];
    platforms = platforms.all;
  };
}
