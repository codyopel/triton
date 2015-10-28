{ stdenv, fetchurl
, ant
, autoreconfHook
, pkgconfig

, fontconfig
, freetype
, jdk
, libaacs
, libbdplus
, libxml2
}:

# Info on how to use:
# https://wiki.archlinux.org/index.php/BluRay

let
  inherit (stdenv.lib)
    optional;
in

stdenv.mkDerivation rec {
  name = "libbluray-${version}";
  version  = "0.9.0";

  src = fetchurl {
    url = "ftp://ftp.videolan.org/pub/videolan/libbluray/${version}/${name}.tar.bz2";
    sha256 = "0kb9znxk6610vi0fjhqxn4z5i98nvxlsz1f8dakj99rg42livdl4";
  };

  patches = [
    # Fix search path for BDJ jarfile
    ./BDJ-JARFILE-path.patch
  ];

  preConfigure = ''
    export JDK_HOME="${jdk.home}"
    export NIX_LDFLAGS="$NIX_LDFLAGS -L${libaacs}/lib -laacs"
    export NIX_LDFLAGS="$NIX_LDFLAGS -L${libbdplus}/lib -lbdplus"
  '';

  nativeBuildInputs = [
    ant
    autoreconfHook
    pkgconfig
  ];

  propagatedBuildInputs = [
    libaacs
  ];

  buildInputs = [
    fontconfig
    freetype
    jdk
    libxml2
  ];

  meta = with stdenv.lib; {
    description = "Library to access Blu-Ray disks for video playback";
    homepage = http://www.videolan.org/developers/libbluray.html;
    license = licenses.lgpl21;
    maintainers = [ ];
  };
}