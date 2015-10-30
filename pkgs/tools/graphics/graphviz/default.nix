{ stdenv, fetchurl
, flex
, libtool
, pkgconfig

, libpng
, libjpeg
, expat
, libXaw
, yacc
, fontconfig
, pango
, gd
, xorg
, gts
, libdevil
, cairo
}:

stdenv.mkDerivation rec {
  version = "2.38.0";
  name = "graphviz-${version}";

  src = fetchurl {
    url = "http://www.graphviz.org/pub/graphviz/ARCHIVE/${name}.tar.gz";
    sha256 = "17l5czpvv5ilmg17frg0w4qwf89jzh2aglm9fgx0l0aakn6j7al1";
  };

  patches = [
    ./0001-vimdot-lookup-vim-in-PATH.patch
    # NOTE: Once this patch is removed, flex can probably be removed from
    # buildInputs.
    ./cve-2014-9157.patch
  ];

  configureFlags = [
    "--with-pngincludedir=${libpng}/include"
    "--with-pnglibdir=${libpng}/lib"
    "--with-jpegincludedir=${libjpeg}/include"
    "--with-jpeglibdir=${libjpeg}/lib"
    "--with-expatincludedir=${expat}/include"
    "--with-expatlibdir=${expat}/lib"
  ] ++ stdenv.lib.optional (xorg == null) "--without-x";

  buildInputs = [
    pkgconfig
    libpng
    libjpeg
    expat
    yacc
    libtool
    fontconfig
    gd
    gts
    libdevil
    flex
  ] ++ stdenv.lib.optionals (xorg != null) [
    xorg.xlibsWrapper
    xorg.libXrender
    pango
    libXaw
  ];

  preBuild = ''
    sed -e 's@am__append_5 *=.*@am_append_5 =@' -i lib/gvc/Makefile
  '';

  # "command -v" is POSIX, "which" is not
  postInstall = stdenv.lib.optionalString (xorg != null) ''
    sed -i 's|`which lefty`|"'$out'/bin/lefty"|' $out/bin/dotty
    #sed -i 's|which|command -v|' $out/bin/vimdot
  '';

  meta = {
    homepage = "http://www.graphviz.org/";
    description = "Open source graph visualization software";
    hydraPlatforms = stdenv.lib.platforms.linux;
    maintainers = with stdenv.lib.maintainers; [ ];
  };
}
