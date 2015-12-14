{ stdenv, fetchurl
, ncurses
, xlibsWrapper
, libXaw
, libXpm
, Xaw3d
, pkgconfig
, gettext
, libXft
, dbus
, libpng
, libjpeg
, libungif
, libtiff
, librsvg
, texinfo
, gconf
, libxml2
, imagemagick
, gnutls
, alsaLib
, cairo
, acl
, gpm
, withX ? true
  , gtk3 ? null
}:

assert (libXft != null) -> libpng != null; # probably a bug
assert withX -> gtk3 != null;

let
  toolkit =
    if withX then
      "gtk3"
    else
      "lucid";
in

stdenv.mkDerivation rec {
  name = "emacs-24.5";

  src = fetchurl {
    url = "mirror://gnu/emacs/${name}.tar.xz";
    sha256 = "0kn3rzm91qiswi0cql89kbv6mqn27rwsyjfb8xmwy9m5s8fxfiyx";
  };

  builder = ./builder.sh;

  postPatch = ''
    sed -e 's|/usr/share/locale|${gettext}/share/locale|g' \
        -i ./lisp/international/mule-cmds.el
  '';

  configureFlags =
    if withX then [
      "--with-x-toolkit=${toolkit}"
      "--with-xft"
    ] else [
      "--with-x=no"
      "--with-xpm=no"
      "--with-jpeg=no"
      "--with-png=no"
      "--with-gif=no"
      "--with-tiff=no"
    ];

  buildInputs = [
    ncurses
    gconf
    libxml2
    gnutls
    alsaLib
    pkgconfig
    texinfo
    acl
    gpm
    gettext
    dbus
  ] ++ stdenv.lib.optionals withX [
    xlibsWrapper
    libXaw
    Xaw3d
    libXpm
    libpng
    libjpeg
    libungif
    libtiff
    librsvg
    libXft
    imagemagick
    gconf
    gtk3
  ];

  postInstall = ''
    mkdir -p $out/share/emacs/site-lisp/
    cp ${./site-start.el} $out/share/emacs/site-lisp/site-start.el
  '';

  doCheck = true;
  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "GNU Emacs, the extensible, customizable text editor";
    homepage = http://www.gnu.org/software/emacs/;
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ ];
    platforms = platforms.all;

    # So that Exuberant ctags are preferred
    priority = 1;
  };
}
