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

stdenv.mkDerivation rec {
  name = "libbluray-${version}";
  version  = "0.9.2";

  src = fetchurl {
    url = "http://ftp.videolan.org/pub/videolan/libbluray/${version}/${name}.tar.bz2";
    sha256 = "1sp71j4agcsg17g6b85cqz78pn5vknl5pl39rvr6mkib5ps99jgg";
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