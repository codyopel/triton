{ stdenv, fetchurl
, autoreconfHook
}:

stdenv.mkDerivation rec {
  name = "libsass-${version}";
  version = "3.3.1";

  src = fetchurl {
    url = "https://github.com/sass/libsass/archive/${version}.tar.gz";
    sha256 = "0izz9lhdg1cpwrrci7vzs0fd3bcwqdmzcmnbcmq35nnlifzjgb74";
  };

  patchPhase = ''
    export LIBSASS_VERSION=${version}
  '';

  nativeBuildInputs = [
    autoreconfHook
  ];

  meta = with stdenv.lib; {
    description = "A C/C++ implementation of a Sass compiler";
    homepage = https://github.com/sass/libsass;
    license = licenses.mit;
    maintainers = with maintainers; [ codyopel ];
    platforms = platforms.unix;
  };
}
