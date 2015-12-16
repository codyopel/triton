{ stdenv, fetchurl
, yasm
}:

stdenv.mkDerivation rec {
  name = "xvidcore-1.3.4";
  
  src = fetchurl {
    url = "http://downloads.xvid.org/downloads/${name}.tar.bz2";
    sha256 = "1xwbmp9wqshc0ckm970zdpi0yvgqxlqg0s8bkz98mnr8p2067bsz";
  };

  # configure/Makefile are not in the root of the source directory
  postUnpack = ''
    sourceRoot="$sourceRoot/build/generic"
  '';

  configureFlags = [
    "--disable-idebug"
    "--disable-iprofile"
    "--disable-gnuprofile"
    "--enable-assembly"
    "--enable-pthread"
    "--disable-macosx_module"
  ];

  nativeBuildInputs = [
    yasm
  ];

  # Remove static libraries
  postInstall = ''
    rm $out/lib/*.a
  '';
  
  meta = with stdenv.lib; {
    description = "MPEG-4 video codec";
    homepage = https://www.xvid.com/;
    license = licenses.gpl2;
    maintainers = with maintainers;  [
      codyopel
    ];
    platforms = [
      "i686-linux"
      "x86_64-linux"
    ];
  };
}

