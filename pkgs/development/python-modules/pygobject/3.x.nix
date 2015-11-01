{ stdenv, fetchurl
, python
, pkgconfig
, glib
, gobjectIntrospection
, pycairo
, cairo
, bzip2
}:

stdenv.mkDerivation rec {
  name = "pygobject-${version}";
  versionMajor = "3.18";
  versionMinor = "2";
  version = "${versionMajor}.${versionMinor}";

  src = fetchurl {
    url = "mirror://gnome/sources/pygobject/${versionMajor}/${name}.tar.xz";
    sha256 = "0prc3ky7g50ixmfxbc7zf43fw6in4hw2q07667hp8swi2wassg1a";
  };

  propagatedBuildInputs = [
    pycairo
    cairo
    gobjectIntrospection
  ];

  buildInputs = [
    python
    pkgconfig
    glib
    bzip2
  ];

  meta = {
    description = "Python bindings for Glib";
    homepage = http://live.gnome.org/PyGObject;
  };
}
