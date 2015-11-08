{ stdenv, fetchurl
, yasm

, enable10bit ? false
}:

with {
  inherit (stdenv)
    isi686
    is64bit;
  inherit (stdenv.lib)
    enFlag
    otFlag;
};

assert enable10bit -> is64bit;

stdenv.mkDerivation rec {
  name = "x264-${version}";
  version = "20151105";

  src = fetchurl {
    url = "http://ftp.videolan.org/pub/videolan/x264/snapshots/" +
          "x264-snapshot-${version}-2245-stable.tar.bz2";
    sha256 = "1b39plz7lzmv4mrkpa3rsyc9c5sv2afjmkys6nfryg24wpn0ik9b";
  };

  postPatch = ''
    patchShebangs ./configure
    patchShebangs ./version.sh
  '';

  configureFlags = [
    "--enable-shared"
    (enFlag "pic" (!isi686) null)
    (otFlag "bit-depth" (enable10bit && is64bit) "10")
  ];

  nativeBuildInputs = [
    yasm
  ];

  meta = with stdenv.lib; {
    description = "Library for encoding h.264/AVC video streams";
    homepage = http://www.videolan.org/developers/x264.html;
    license = licenses.gpl2;
    maintainers = [ ];
    platforms = platforms.unix;
  };
}
