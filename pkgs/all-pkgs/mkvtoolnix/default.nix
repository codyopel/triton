{ stdenv, fetchurl
, gettext
, pkgconfig
, ruby
# Required
, boost
, expat
, file
, flac
, libebml
, libmatroska
, libogg
, libvorbis
#, pugixml (not packaged)
, xdg_utils
, zlib
# Optionals
, qt5
}:

with {
  inherit (stdenv.lib)
    enFlag
    optionals;
};

assert qt5 != null -> qt5.base != null;

stdenv.mkDerivation rec {
  name = "mkvtoolnix-${version}";
  version = "8.6.1";

  src = fetchurl {
    url = "http://www.bunkus.org/videotools/mkvtoolnix/sources/${name}.tar.xz";
    sha256 = "0xzsr39rq291p1ccybivw19ss7bgf7lcwhvmjlfg0fm8nraq6pc1";
  };

  patchPhase = ''
    patchShebangs ./rake.d/
    patchShebangs ./Rakefile
    # Force ruby encoding to use UTF-8 or else when enabling qt5 the Rakefile may
    # fail with `invalid byte sequence in US-ASCII' due to UTF-8 characters
    # This workaround replaces an arbitrary comment in the drake file
    sed -e 's,#--,Encoding.default_external = Encoding::UTF_8,' -i ./drake
  '';

  configureFlags = [
    "--with-flac"
    # Curl is only used to check for updates
    "--without-curl"
    "--with-boost-libdir=${boost.lib}/lib"
    "--with-gettext"
    "--without-tools"
    (enFlag "qt" (qt5 != null) null)
    "--disable-static-qt"
  ];

  nativeBuildInputs = [
    gettext
    pkgconfig
    ruby
  ];

  buildInputs = [
    boost
    expat
    file
    flac
    libebml
    libmatroska
    libogg
    libvorbis
    xdg_utils
    zlib
  ] ++ optionals (qt5 != null) [
    qt5.base
  ];

  buildPhase = ''
    ./drake
  '';

  installPhase = ''
    ./drake install
  '';

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "Cross-platform tools for Matroska";
    homepage = http://www.bunkus.org/videotools/mkvtoolnix/;
    license = licenses.gpl2;
    maintainers = with maintainers; [
      codyopel
    ];
    platforms = [
      "i686-linux"
      "x86_64-linux"
    ];
  };
}
