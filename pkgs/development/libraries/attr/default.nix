{ stdenv, fetchurl
, gettext
}:

stdenv.mkDerivation rec {
  name = "attr-2.4.47";

  src = fetchurl {
    url = "mirror://savannah/attr/${name}.src.tar.gz";
    sha256 = "0nd8y0m6awc9ahv0ciiwf8gy54c8d3j51pw9xg7f7cn579jjyxr5";
  };

  configureFlags = [
    "--enable-shared"
    "--enable-gettext"
    "--disable-lib64"
  ];

  buildInputs = [
    gettext
  ];

  installTargets = [
    "install"
    "install-lib"
    "install-dev"
  ];

  preFixup = ''
    # Remove static object
    rm -vf $out/lib/*.a
  '';

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "Library and tools for manipulating extended attributes";
    homepage = http://savannah.nongnu.org/projects/attr/;
    platforms = platforms.all;
  };
}
