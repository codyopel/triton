{ stdenv, fetchurl
, autoreconfHook
}:

stdenv.mkDerivation rec {
  name = "libmkv-${version}";
  version = "0.6.5.1";
  
  src = fetchurl {
    url = "https://github.com/saintdev/libmkv/archive/${version}.tar.gz";
    sha256 = "007g9i3591l01ycfn8c0s5xcd87lvk8ws7fs9y1zjm5kp848mw21";
  };

  nativeBuildInputs = [
    autoreconfHook
  ];

  # From Handbrake
  patches = [
    ./A01-hbmv-pgs.patch
    ./A02-audio-out-sampling-freq.patch
    ./P00-mingw-large-file.patch
  ];

  meta = with stdenv.lib; {
    homepage = https://github.com/saintdev/libmkv;
    license = licenses.gpl2;
    maintainers = [ ];
  };
}
