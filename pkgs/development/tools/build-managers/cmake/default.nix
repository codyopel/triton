{ stdenv, fetchurl
, bzip2
, curl
, expat
, libarchive
, xz
, zlib
, useNcurses ? false
  , ncurses
, useQt4 ? false
  , qt4
}:

with {
  inherit (stdenv.lib)
    concatStringsSep
    optional
    optionalString;
};

let
  os = optionalString;
  majorVersion = "3.4";
  minorVersion = "1";
  version = "${majorVersion}.${minorVersion}";
in

stdenv.mkDerivation rec {
  name = "cmake-${os useNcurses "cursesUI-"}${os useQt4 "qt4UI-"}${version}";

  inherit majorVersion;

  src = fetchurl {
    url = "http://www.cmake.org/files/v${majorVersion}/cmake-${version}.tar.gz";
    sha256 = "1qhkq72m8wch9kh0nr7fiq38rbxk9cspn5h8aq6pzhqdv2yn456l";
  };

  setupHook = ./setup-hook.sh;

  patches =
    # Don't search in non-Nix locations such as /usr, but do search in
    # Nixpkgs' Glibc.
    optional (stdenv ? glibc) ./search-path-3.2.patch;

  configureFlags = [
    "--docdir=/share/doc/${name}"
    "--mandir=/share/man"
    "--no-system-jsoncpp"
    "--system-libs"
  ] ++ optional useQt4 "--qt-gui"
    ++ ["--"]
    ++ optional (!useNcurses) "-DBUILD_CursesDialog=OFF";

  preConfigure = optionalString (stdenv ? glibc) ''
    source $setupHook
    fixCmakeFiles .
    substituteInPlace Modules/Platform/UnixPaths.cmake \
      --subst-var-by glibc ${stdenv.glibc}
  '';

  buildInputs = [
    bzip2
    curl
    expat
    libarchive
    xz
    zlib
  ] ++ optional useNcurses ncurses
    ++ optional useQt4 qt4;

  CMAKE_PREFIX_PATH = concatStringsSep ":" buildInputs;

  dontUseCmakeConfigure = true;
  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "Cross-Platform Makefile Generator";
    homepage = http://www.cmake.org/;
    maintainers = with maintainers; [ ];
    platforms =
      if useQt4 then
        qt4.meta.platforms
      else
        platforms.all;
  };
}
