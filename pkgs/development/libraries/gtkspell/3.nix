{stdenv, fetchurl
, intltool
, pkgconfig

, aspell
, enchant
, gobjectIntrospection
, gtk3
, xorg
}:

stdenv.mkDerivation rec {
  name = "gtkspell3-3.0.7";

  src = fetchurl {
    url = "mirror://sourceforge/gtkspell/${name}.tar.gz";
    sha256 = "1hiwzajf18v9ik4nai3s7frps4ccn9s20nggad1c4k2mwb9ydwhk";
  };

  configureFlags = [
    "--disable-gtk2"
    "--enable-gtk3"
    "--enable-introspection"
    "--disable-vala"
    "--enable-nls"
    "--disable-gtk-doc"
    "--disable-gtk-doc-html"
    "--disable-gtk-doc-pdf"
    "--enable-iso-codes"
  ];

  nativeBuildInputs = [
    intltool
    pkgconfig
  ];

  propagatedBuildInputs = [
    enchant
  ];

  buildInputs = [
    aspell
    enchant
    gobjectIntrospection
    gtk3
    xorg.libICE
    xorg.libSM
  ];

  meta = with stdenv.lib; {
    description = "Word-processor-style highlighting GtkTextView widget";
    homepage = http://gtkspell.sourceforge.net/;
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ ];
    platforms = platforms.unix;
  };
}
