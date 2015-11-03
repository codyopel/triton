{ stdenv, fetchurl, ncurses, lzma }:

stdenv.mkDerivation rec {
  name = "texinfo-4.13a";

  src = fetchurl {
    url = "mirror://gnu/texinfo/texinfo-4.13a.tar.lzma";
    sha256 = "1rf9ckpqwixj65bw469i634897xwlgkm5i9g2hv3avl6mv7b0a3d";
  };

  buildInputs = [ ncurses ];
  nativeBuildInputs = [ lzma ];

  # Disabled because we don't have zdiff in the stdenv bootstrap.
  #doCheck = true;

  meta = {
    description = "The GNU documentation system";
    homepage = http://www.gnu.org/software/texinfo/;
    license = stdenv.lib.licenses.gpl3Plus;
    branch = "4";
  };
}
