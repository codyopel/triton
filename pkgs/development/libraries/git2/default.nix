{stdenv, fetchurl
, cmake
, pkgconfig
, python

, curl
, ctags
, http-parser
, libssh2
, openssl
, zlib

, tests ? true
}:

with {
  inherit (stdenv.lib)
    cmFlag
    optionals;
};

stdenv.mkDerivation rec {
  version = "0.23.4";
  name = "libgit2-${version}";

  src = fetchurl {
    name = "${name}.tar.gz";
    url = "https://github.com/libgit2/libgit2/tarball/v${version}";
    sha256 = "0ss9cpcm4mr7060x9xg7nap4mqnnc1gv98xmmfz6qhmasfhcijxv";
  };

  cmakeFlags = [
    "-DBUILD_SHARED_LIBS=ON"
    "-DTHREADSAFE=ON"
    (cmFlag "BUILD_CLAR" tests)
    "-DBUILD_EXAMPLES=OFF"
    "-DTAGS=ON"
    "-DPROFILE=OFF"
    "-DENABLE_TRACE=OFF"
    "-DUSE_ICONV=ON"
    "-DUSE_SSH=ON"
    "-DUSE_GSSAPI=OFF"
    "-DVALGRIND=OFF"
    "-DCURL=ON"
  ];

  nativeBuildInputs = [
    cmake
    pkgconfig
  ] ++ optionals tests [
    python
  ];

  buildInputs = [
    curl
    ctags
    http-parser
    libssh2
    openssl
    zlib
  ];

  meta = with stdenv.lib; {
    description = "The Git linkable library";
    homepage = http://libgit2.github.com/;
    license = licenses.gpl2;
    platforms = [
      "i686-linux"
      "x86_64-linux"
    ];
  };
}
