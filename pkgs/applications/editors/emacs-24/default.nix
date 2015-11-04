{ stdenv, fetchurl, ncurses, xlibsWrapper, libXaw, libXpm, Xaw3d
, pkgconfig, gettext, libXft, dbus, libpng, libjpeg, libungif
, libtiff, librsvg, texinfo, gconf, libxml2, imagemagick, gnutls
, alsaLib, cairo, acl, gpm
, withX ? true
, withGTK3 ? false, gtk3 ? null
, withGTK2 ? true, gtk2
}:

assert (libXft != null) -> libpng != null;      # probably a bug
assert withGTK2 -> withX;
assert withGTK3 -> withX;
assert withGTK2 -> !withGTK3 && gtk2 != null;
assert withGTK3 -> !withGTK2 && gtk3 != null;

let
  toolkit =
    if withGTK3 then "gtk3"
    else if withGTK2 then "gtk2"
    else "lucid";
in

stdenv.mkDerivation rec {
  name = "emacs-24.5";

  builder = ./builder.sh;

  src = fetchurl {
    url    = "mirror://gnu/emacs/${name}.tar.xz";
    sha256 = "0kn3rzm91qiswi0cql89kbv6mqn27rwsyjfb8xmwy9m5s8fxfiyx";
  };

  postPatch = ''
    sed -i 's|/usr/share/locale|${gettext}/share/locale|g' lisp/international/mule-cmds.el
  '';

  buildInputs =
    [ ncurses gconf libxml2 gnutls alsaLib pkgconfig texinfo acl gpm gettext ]
    ++ stdenv.lib.optional stdenv.isLinux dbus
    ++ stdenv.lib.optionals withX
      [ xlibsWrapper libXaw Xaw3d libXpm libpng libjpeg libungif libtiff librsvg
        libXft
        imagemagick gconf ]
    ++ stdenv.lib.optional (withX && withGTK2) gtk2
    ++ stdenv.lib.optional (withX && withGTK3) gtk3;

  configureFlags =
    if withX then [
      "--with-x-toolkit=${toolkit}" "--with-xft"
    ] else [
      "--with-x=no"
      "--with-xpm=no"
      "--with-jpeg=no"
      "--with-png=no"
      "--with-gif=no"
      "--with-tiff=no"
    ];

  postInstall = ''
    mkdir -p $out/share/emacs/site-lisp/
    cp ${./site-start.el} $out/share/emacs/site-lisp/site-start.el
  '';

  doCheck = true;

  meta = with stdenv.lib; {
    description = "GNU Emacs 24, the extensible, customizable text editor";
    homepage    = http://www.gnu.org/software/emacs/;
    license     = licenses.gpl3Plus;
    maintainers = with maintainers; [ ];
    platforms   = platforms.all;

    # So that Exuberant ctags is preferred
    priority = 1;
  };
}
