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
, withGUI ? false, qt5 ? null # Disabled for now until upstream issues are resolved
, legacyGUI ? true, wxGTK ? null
# For now the wxwidgets gui must be enabled, if wxwidgets is disabled
# the build system doesn't install desktop entries, icons, etc...
}:

with {
  inherit (stdenv.lib)
    enableFeature
    optional;
};

assert withGUI -> qt5 != null;
assert legacyGUI -> wxGTK != null;

stdenv.mkDerivation rec {
  name = "mkvtoolnix-${version}";
  version = "8.5.1";

  src = fetchurl {
    url = "http://www.bunkus.org/videotools/mkvtoolnix/sources/${name}.tar.xz";
    sha256 = "0hsvvlgsxbxm2cwqwadxbl83rr7l9n6ps4y0j30zlsi3xx8y36nv";
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
    "--with-boost-libdir=${boost.lib}/lib"
    "--without-curl"
  ] ++ (
    if (withGUI || legacyGUI) then [
      "--with-mkvtoolnix-gui"
      "--enable-gui"
      (enableFeature withGUI "qt")
      (enableFeature legacyGUI "wxwidgets")
    ] else [
      "--disable-gui"
    ]
  );

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
  ] ++ optional withGUI qt5
    ++ optional legacyGUI wxGTK;

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
    maintainers = with maintainers; [ codyopel ];
    platforms = platforms.linux;
  };
}
