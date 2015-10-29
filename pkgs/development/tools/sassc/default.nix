{ stdenv, fetchurl
, autoreconfHook

, libsass
}:

stdenv.mkDerivation rec {
  name = "sassc-${version}";
  version = "3.3.1";

  src = fetchurl {
    url = "https://github.com/sass/sassc/archive/${version}.tar.gz";
    sha256 = "0694gdjd7983g15ccdv4znr0wccy9a5jb93x5rp965vasip8d6z9";
  };

  patchPhase = ''
    export SASSC_VERSION=${version}
  '';

  nativeBuildInputs = [
    autoreconfHook
  ];

  buildInputs = [
    libsass
  ];

  meta = with stdenv.lib; {
    description = "A front-end for libsass";
    homepage = https://github.com/sass/sassc/;
    license = licenses.mit;
    maintainers = with maintainers; [ codyopel ];
    platforms = platforms.unix;
  };
}
