{stdenv, fetchurl, libdvdcss}:

stdenv.mkDerivation rec {
  name = "libdvdread-${version}";
  version = "5.0.3";

  src = fetchurl {
    url = "http://download.videolan.org/pub/videolan/libdvdread/${version}/libdvdread-${version}.tar.bz2";
    sha256 = "0ayqiq0psq18rcp6f5pz82sxsq66v0kwv0y55dbrcg68plnxy71j";
  };

  NIX_LDFLAGS = [
    "-ldvdcss"
  ];

  buildInputs = [
    libdvdcss
  ];

  postInstall = ''
    ln -s dvdread $out/include/libdvdread
  '';

  meta = {
    homepage = http://dvdnav.mplayerhq.hu/;
    description = "A library for reading DVDs";
    license = stdenv.lib.licenses.gpl2;
    maintainers = [ ];
  };
}
