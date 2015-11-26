{ stdenv, fetchhg
, cmake
, pkgconfig

, fftw
}:

stdenv.mkDerivation rec {
  name = "eigen-${version}";
  # Not all C++11 fixes have been backported to 3.2, use 3.3-pre
  version = "2015-11-24";

  src = fetchhg {
    url = "https://bitbucket.org/eigen/eigen";
    rev = "6105862db40fe8fa832c56963ecc8a4d99415d35";
    sha256 = "0ll6x4y5apbxdsk0y2m4j7m0qx7ff6clfwk3d7fxprjsdsqyc9j0";
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
