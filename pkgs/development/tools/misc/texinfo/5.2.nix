{ stdenv, fetchurl, ncurses, perl, xz, interactive ? false }:

stdenv.mkDerivation rec {
  name = "texinfo-5.2";

  src = fetchurl {
    url = "mirror://gnu/texinfo/${name}.tar.xz";
    sha256 = "1njfwh2z34r2c4r0iqa7v24wmjzvsfyz4vplzry8ln3479lfywal";
  };

  buildInputs = [ perl xz ]
    ++ stdenv.lib.optional interactive ncurses;

  preInstall = ''
    installFlags="TEXMF=$out/texmf-dist";
    installTargets="install install-tex";
  '';

  doCheck = !stdenv.isDarwin;

  meta = {
    description = "The GNU documentation system";
    homepage = "http://www.gnu.org/software/texinfo/";
    license = stdenv.lib.licenses.gpl3Plus;
    platforms = stdenv.lib.platforms.all;
    branch = "5";
  };
}
