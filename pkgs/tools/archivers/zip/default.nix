{ stdenv, fetchurl
, bzip2
, enableNLS ? true
, libnatspec ? null
, libiconv
}:

with {
  inherit (stdenv.lib)
    optional
    optionals;
};

assert enableNLS -> libnatspec != null;

stdenv.mkDerivation {
  name = "zip-3.0";

  src = fetchurl {
    urls = [
      ftp://ftp.info-zip.org/pub/infozip/src/zip30.tgz
      http://pkgs.fedoraproject.org/repo/pkgs/zip/zip30.tar.gz/7b74551e63f8ee6aab6fbc86676c0d37/zip30.tar.gz
    ];
    sha256 = "0sb3h3067pzf3a7mlxn1hikpcjrsvycjcnj9hl9b1c3ykcgvps7h";
  };

  patches = optionals enableNLS [
    ./natspec-gentoo.patch.bz2
  ];

  NIX_CFLAGS_COMPILE = [
    "-DLARGE_FILE_SUPPORT"
    "-DUIDGID_NOT_16BIT"
    "-DBZIP2_SUPPORT"
    "-DCRYPT"
    "-DUNICODE_SUPPORT"
  ];

  makefile = "unix/Makefile";

  makeFlags = "generic";

  installFlags=[
    "prefix=$(out)"
    "INSTALL=install"
  ];

  buildInputs = [
    bzip2
    libiconv
  ] ++ optional enableNLS libnatspec;

  meta = with stdenv.lib; {
    description = "Compressor/archiver for creating and modifying zipfiles";
    homepage = http://www.info-zip.org;
    maintainers = [ ];
    platforms = platforms.all;
  };
}
