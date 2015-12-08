{ stdenv, fetchurl

, fixedPoint ? false
, withCustomModes ? true
}:

with {
  inherit (stdenv)
    isArm;
  inherit (stdenv.lib)
    enFlag;
};

stdenv.mkDerivation rec {
  name = "libopus-${version}";
  version = "1.1.1";

  src = fetchurl {
    url = "http://downloads.xiph.org/releases/opus/opus-${version}.tar.gz";
    sha256 = "07iplfwim26b6k1bqjyciaqvihps9rk5gi8385axa83ppmbgz14v";
  };

  configureFlags = [
    "--disable-maintainer-mode"
    (enFlag "fixed-point" fixedPoint null)
    "--disable-fixed-point-debug"
    (enFlag "flost-api" (!fixedPoint) null)
    (enFlag "custom-modes" withCustomModes null)
    "--disable-flost-approx"
    "--enable-asm"
    "--enable-rtcd"
    (enFlag "intrinsics" (isArm && !fixedPoint) null)
    "--disable-assertions"
    "--disable-fuzzing"
    "--disable-doc"
    "--disable-extra-programs"
  ];

  doCheck = true;
  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "Highly versatile audio codec";
    homepage = http://www.opus-codec.org/;
    license = stdenv.lib.licenses.bsd3;
    maintainers = with maintainers; [ ];
    platforms = [
      "i686-linux"
      "x86_64-linux"
    ];
  };
}
