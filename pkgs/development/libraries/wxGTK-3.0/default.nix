{ stdenv, fetchurl, pkgconfig, gtk, libXinerama, libSM, libXxf86vm, xf86vidmodeproto
, gstreamer, gst_plugins_base, GConf
, withMesa ? true
  , mesa ? null
, compat24 ? false
, compat26 ? true
, unicode ? true,
}:

assert withMesa -> mesa != null;

with stdenv.lib;

let
  version = "3.0.2";
in
stdenv.mkDerivation {
  name = "wxwidgets-${version}";

  src = fetchurl {
    url = "mirror://sourceforge/wxwindows/wxWidgets-${version}.tar.bz2";
    sha256 = "0paq27brw4lv8kspxh9iklpa415mxi8zc117vbbbhfjgapf7js1l";
  };

  buildInputs =
    [ gtk libXinerama libSM libXxf86vm xf86vidmodeproto gstreamer
      gst_plugins_base GConf ]
    ++ optional withMesa mesa;

  nativeBuildInputs = [ pkgconfig ];

  configureFlags =
    [ "--enable-gtk2" "--disable-precomp-headers" "--enable-mediactrl"
      (if compat24 then "--enable-compat24" else "--disable-compat24")
      (if compat26 then "--enable-compat26" else "--disable-compat26") ]
    ++ optional unicode "--enable-unicode"
    ++ optional withMesa "--with-opengl";

  SEARCH_LIB = optionalString withMesa "${mesa}/lib";

  preConfigure = ''
    substituteInPlace configure \
      --replace 'SEARCH_INCLUDE=' 'DUMMY_SEARCH_INCLUDE='
    substituteInPlace configure \
      --replace 'SEARCH_LIB=' 'DUMMY_SEARCH_LIB='
    substituteInPlace configure \
      --replace /usr /no-such-path
  '';

  postInstall = "
    (cd $out/include && ln -s wx-*/* .)
  ";

  passthru = {inherit gtk compat24 compat26 unicode;};

  enableParallelBuilding = true;
  
  meta = {
    platforms = stdenv.lib.platforms.all;
  };
}
