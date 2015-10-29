{ stdenv, fetchurl
, autoreconfHook
, bison
, flex

, flac
, id3v2
, vorbisTools
}:

stdenv.mkDerivation rec {
  name = "cuetools-${version}";
  version = "1.4.1";

  src = fetchurl {
    url = "https://github.com/svend/cuetools/archive/${version}.tar.gz";
    sha256 = "01xi3rvdmil9nawsha04iagjylqr1l9v9vlzk99scs8c207l58i4";
  };

  nativeBuildInputs = [
    autoreconfHook
    bison
    flex
  ];

  buildInputs = [
    flac
    id3v2
    vorbisTools
  ];

  meta = with stdenv.lib; {
    description = "Utilities for working with cue & toc files";
    homepage = https://github.com/svend/cuetools;
    license = licenses.gpl2;
    maintainers = with maintainers; [ codyopel ];
    platforms = platforms.all;
  };
}
