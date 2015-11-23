{ stdenv, fetchurl
, cmake
, makeWrapper
, perl
, pkgconfig

, glib
, gnome3
, gtk3
, librsvg
}:

stdenv.mkDerivation rec {
  name = "sakura-${version}";
  version = "3.3.0";

  src = fetchurl {
    url = "http://launchpad.net/sakura/trunk/${version}/+download/${name}.tar.bz2";
    sha256 = "0rzjnlzwlsi309plqp63r2bb6kxr0lam1v0s73c74zwms8gik3a1";
  };

  nativeBuildInputs = [
    cmake
    makeWrapper
    perl
    pkgconfig
  ];

  buildInputs = [
    glib
    gnome3.vte
    gtk3
    # librsvg is only needed to set GDK_PIXBUF_MODULE_FILE
    librsvg
  ];

  preFixup = ''
    wrapProgram $out/bin/sakura \
      --set GDK_PIXBUF_MODULE_FILE "$GDK_PIXBUF_MODULE_FILE"
  '';

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "A terminal emulator based on GTK and VTE";
    homepage = http://www.pleyades.net/david/projects/sakura;
    license = licenses.gpl2;
    maintainers = with maintainers; [ codyopel ];
    platforms = platforms.linux;
  };
}
