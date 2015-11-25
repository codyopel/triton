{ stdenv, fetchurl, ncurses, perl, xz, interactive ? false }:

stdenv.mkDerivation rec {
  name = "texinfo-6.0";

  src = fetchurl {
    url = "mirror://gnu/texinfo/${name}.tar.xz";
    sha256 = "1r3i6jyynn6ab45fxw5bms8mflk9ry4qpj6gqyry72vfd5c47fhi";
  };

  buildInputs = [ perl xz ]
    ++ stdenv.lib.optional interactive ncurses;

  preInstall = ''
    installFlags="TEXMF=$out/texmf-dist";
    installTargets="install install-tex";
  '';

  doCheck = false;

  meta = {
    homepage = "http://www.gnu.org/software/texinfo/";
    description = "The GNU documentation system";
    license = stdenv.lib.licenses.gpl3Plus;
    platforms = stdenv.lib.platforms.all;


    branch = "6";
  };
}
