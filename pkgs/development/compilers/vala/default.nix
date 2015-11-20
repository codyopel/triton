{ stdenv, fetchurl
, bison
, flex
, libxslt
, pkgconfig

, glib
, libiconv
, libintlOrEmpty
}:

stdenv.mkDerivation rec {
  name = "vala-${version}";
  versionMajor = "0.30";
  versionMinor = "0";
  version = "${versionMajor}.${versionMinor}";

  src = fetchurl {
    url = "mirror://gnome/sources/vala/${versionMajor}/${name}.tar.xz";
    sha256 = "1pyyhfw3zzbhxfscbn8xz70dg6vx0kh8gshzikpxczhg01xk7w31";
  };

  configureFlags = [
    "--disable-maintainer-mode"
    "--disable-unversioned"
    "--disable-coverage"
  ];

  nativeBuildInputs = [
    bison
    flex
    libxslt
    pkgconfig
  ];

  buildInputs = [
    glib
    libiconv
  ] ++ libintlOrEmpty;

  doCheck = false;
  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "Compiler for GObject type system";
    homepage = "http://live.gnome.org/Vala";
    license = licenses.lgpl21Plus;
    maintainers = with maintainers; [ ];
    platforms = platforms.unix;
  };
}
