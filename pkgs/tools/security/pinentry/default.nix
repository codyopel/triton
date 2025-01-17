{ fetchurl, stdenv, pkgconfig
, libgpgerror, libassuan, libcap ? null, ncurses ? null, gtk2 ? null, qt4 ? null
}:

let
  hasX = gtk2 != null || qt4 != null;
in
with stdenv.lib;
stdenv.mkDerivation rec {
  name = "pinentry-0.9.6";

  src = fetchurl {
    url = "mirror://gnupg/pinentry/${name}.tar.bz2";
    sha256 = "0rhyw1vk28kgasjp22myf7m2q8kycw82d65pr9kgh93z17lj849a";
  };

  buildInputs = [ libgpgerror libassuan libcap gtk2 ncurses qt4 ];

  prePatch = ''
    substituteInPlace pinentry/pinentry-curses.c --replace ncursesw ncurses
  '';

  # configure cannot find moc on its own
  preConfigure = stdenv.lib.optionalString (qt4 != null) ''
    export QTDIR="${qt4}"
    export MOC="${qt4}/bin/moc"
  '';

  configureFlags = [
    (mkWith   (libcap != null)  "libcap"          null)
    (mkWith   (hasX)            "x"               null)
    (mkEnable (ncurses != null) "pinentry-curses" null)
    (mkEnable true              "pinentry-tty"    null)
    (mkEnable (gtk2 != null)    "pinentry-gtk2"   null)
    (mkEnable (qt4 != null)     "pinentry-qt4"    null)
  ];

  nativeBuildInputs = [ pkgconfig ];

  meta = {
    homepage = "http://gnupg.org/aegypten2/";
    description = "GnuPG's interface to passphrase input";
    license = stdenv.lib.licenses.gpl2Plus;
    platforms = stdenv.lib.platforms.all;
    longDescription = ''
      Pinentry provides a console and (optional) GTK+ and Qt GUIs allowing users
      to enter a passphrase when `gpg' or `gpg2' is run and needs it.
    '';
    maintainers = [ stdenv.lib.maintainers.ttuegel ];
  };
}
