{ stdenv, fetchurl

, openssl
}:

let name = "libbsd-0.8.1";
in stdenv.mkDerivation {
  inherit name;

  src = fetchurl {
    url = "http://libbsd.freedesktop.org/releases/${name}.tar.xz";
    sha256 = "1c7r58y3jz0251y7l54jcyik4xr4y2lki7v8kf9ww2vjmn0qgg5d";
  };

  patchPhase = ''
    substituteInPlace Makefile \
      --replace "/usr" "$out" \
      --replace "{exec_prefix}" "{prefix}"
  '';

  buildInputs = [
    openssl
  ];

  meta = with stdenv.lib; {
    description = "Common functions found on BSD systems";
    homepage = http://libbsd.freedesktop.org/;
    license = licenses.bsd3;
    platforms = [
      "i686-linux"
      "x86_64-linux"
    ];
  };
}
