{ stdenv, fetchurl, pkgconfig, xorg }:

stdenv.mkDerivation rec {
  name = "libvdpau-1.1.1";

  src = fetchurl {
    url = "http://people.freedesktop.org/~aplattner/vdpau/${name}.tar.bz2";
    sha256 = "0dnpb0yh7v6rvckx82kxg045rd9rbsw25wjv7ad5n8h94s9h2yl5";
  };

  nativeBuildInputs = [
    pkgconfig
  ];

  buildInputs = [
    xorg.dri2proto
    xorg.libXext
  ];

  propagatedBuildInputs = [
    xorg.libX11
  ];

  meta = with stdenv.lib; {
    description = "Video Decode and Presentation API for Unix";
    homepage = http://people.freedesktop.org/~aplattner/vdpau/;
    license = licenses.mit;
    maintainers = [ ];
    platforms = platforms.unix;
  };
}