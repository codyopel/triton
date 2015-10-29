{ stdenv, fetchurl
# Optional
, giflib
, libjpeg
, libpng
, libtiff
, libwebp
, openjpeg
, zlib
, programs ? true
}:

with {
  inherit (stdenv.lib)
    enFlag
    wtFlag;
};

stdenv.mkDerivation rec {
  name = "leptonica-1.72";

  src = fetchurl {
    url = "http://www.leptonica.org/source/${name}.tar.gz";
    sha256 = "0mhzvqs0im04y1cpcc1yma70hgdac1frf33h73m9z3356bfymmbr";
  };

  configureFlags = [
    (enFlag "programs" programs null)
    (wtFlag "giflib" (giflib != null) null)
    (wtFlag "jpeg" (openjpeg != null) null)
    (wtFlag "libopenjpeg" (openjpeg != null) null)
    (wtFlag "libpng" (libpng != null) null)
    (wtFlag "libtiff" (libtiff != null) null)
    (wtFlag "libwebp" (libwebp != null) null)
    (wtFlag "zlib" (zlib != null) null)
  ];

  propagatedBuildInputs = [
    giflib
    libwebp
    openjpeg
  ];

  buildInputs = [
    libjpeg
    libpng
    libtiff
    zlib
  ];

  meta = with stdenv.lib; {
    description = "Image processing and analysis library";
    homepage = http://www.leptonica.org/;
    # Its own license: http://www.leptonica.org/about-the-license.html
    license = licenses.free;
  };
}
