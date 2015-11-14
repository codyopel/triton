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

stdenv.mkDerivation rec {
  name = "libbluray-${version}";
  version  = "0.9.1";

  src = fetchurl {
    url = "ftp://ftp.videolan.org/pub/videolan/libbluray/${version}/${name}.tar.bz2";
    sha256 = "0h1r5z263cyr97bay89p1x4k6cbyv73gr7syv0rpp402b2jpyr6r";
  };

  patches = [
    # Fix search path for BDJ jarfile
    ./BDJ-JARFILE-path.patch
  ];

  configureFlags = [
    "--disable-werror"
    "--enable-optimizations"
    "--disable-examples"
    "--enable-bdjava"
    "--enable-udf"
    "--disable-doxygen-doc"
    "--disable-doxygen-dot"
    "--disable-doxygen-man"
    "--disable-doxygen-rtf"
    "--disable-doxygen-xml"
    "--disable-doxygen-chm"
    "--disable-doxygen-chi"
    "--disable-doxygen-html"
    "--disable-doxygen-ps"
    "--disable-doxygen-pdf"
    "--with-libxml2"
    "--with-freetype"
    "--with-fontconfig"
    "--with-bdj-type=j2se"
    #"--with-bdj-bootclasspath="
  ];

  NIX_LDFLAGS = [
    "-L${libaacs}/lib"
    "-laacs"
    "-L${libbdplus}/lib"
    "-lbdplus"
  ];

  preConfigure = ''
    export JDK_HOME="${jdk.home}"
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