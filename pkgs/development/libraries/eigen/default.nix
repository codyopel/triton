{ stdenv, fetchurl
, cmake
, pkgconfig

, fftw
}:

stdenv.mkDerivation rec {
  name = "eigen-${version}";
  version = "3.2.6";
  
  src = fetchurl {
    url = "http://bitbucket.org/eigen/eigen/get/${version}.tar.gz";
    name = "eigen-${version}.tar.gz";
    sha256 = "0my9gy73kjg53zy83p3cahmm9y0zjh3l4r3nhihd2ikiqwalxqdn";
  };

  cmakeFlags = [
    "-DEIGEN_BUILD_TESTS=ON"
    "-DEIGEN_TEST_NO_FORTRAN=ON"
    "-DEIGEN_TEST_NO_OPENGL=ON"
  ];

  NIX_CFLAGS_COMPILE = [
    "-std=c++11"
  ];
  
  nativeBuildInputs = [
    cmake
    pkgconfig
  ];

  buildInputs = [
    fftw
  ];
  
  meta = with stdenv.lib; {
    description = "C++ template library for linear algebra: vectors, matrices, and related algorithms";
    license = licenses.lgpl3Plus;
    homepage = http://eigen.tuxfamily.org ;
    platforms = platforms.unix;
    maintainers = with stdenv.lib.maintainers; [ ];
    inherit version;
  };
}
