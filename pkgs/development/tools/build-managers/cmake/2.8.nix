{ stdenv, fetchurl, fetchpatch
, replace
, curl
, expat
, zlib
, bzip2
, libarchive
, useNcurses ? false
  , ncurses
, useQt4 ? false
  , qt4
}:

with stdenv.lib;

let
  os = stdenv.lib.optionalString;
  majorVersion = "2.8";
  minorVersion = "12.2";
  version = "${majorVersion}.${minorVersion}";
in

stdenv.mkDerivation rec {
  name = "cmake-${os useNcurses "cursesUI-"}${os useQt4 "qt4UI-"}${version}";

  inherit majorVersion;

  src = fetchurl {
    url = "${meta.homepage}files/v${majorVersion}/cmake-${version}.tar.gz";
    sha256 = "0phf295a9cby0v7zqdswr238v5aiy3rb2fs6dz39zjxbmzlp8rcc";
  };

  enableParallelBuilding = true;

  patches =
    [(fetchpatch { # see http://www.cmake.org/Bug/view.php?id=13959
      name = "FindFreetype-2.5.patch";
      url = "http://www.cmake.org/Bug/file_download.php?file_id=4660&type=bug";
      sha256 = "136z63ff83hnwd247cq4m8m8164pklzyl5i2csf5h6wd8p01pdkj";
    })] ++
    # Don't search in non-Nix locations such as /usr, but do search in
    # Nixpkgs' Glibc. 
    optional (stdenv ? glibc) ./search-path.patch;

  buildInputs = [ curl expat zlib bzip2 libarchive ]
    ++ optional useNcurses ncurses
    ++ optional useQt4 qt4;

  CMAKE_PREFIX_PATH = stdenv.lib.concatStringsSep ":" buildInputs;
  
  configureFlags =
    "--docdir=/share/doc/${name} --mandir=/share/man --system-libs"
    + stdenv.lib.optionalString useQt4 " --qt-gui";

  setupHook = ./setup-hook.sh;

  dontUseCmakeConfigure = true;

  preConfigure = optionalString (stdenv ? glibc)
    ''
      source $setupHook
      fixCmakeFiles .
      substituteInPlace Modules/Platform/UnixPaths.cmake --subst-var-by glibc ${stdenv.glibc}
    '';

  meta = {
    homepage = http://www.cmake.org/;
    description = "Cross-Platform Makefile Generator";
    platforms = if useQt4 then qt4.meta.platforms else stdenv.lib.platforms.all;
    maintainers = with stdenv.lib.maintainers; [ urkud mornfall ];
  };
}
