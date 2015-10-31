{ stdenv, fetchurl
, gettext
, intltool
, pkgconfig
, python

, avahi
, bluez
, boost
, eigen
, fftw
, glib
, glibmm
, gtk2
, gtkmm_2
, libjack2
, ladspaH
, librdf
, libsndfile
, lilv
, lv2
, serd
, sord
, sratom
, zita-convolver
, zita-resampler
, optimizationSupport ? false # Enable support for native CPU extensions
}:

let
  inherit (stdenv.lib) optional;
in

stdenv.mkDerivation rec {
  name = "guitarix-${version}";
  version = "0.33.0";

  src = fetchurl {
    url = "mirror://sourceforge/guitarix/guitarix2-${version}.tar.bz2";
    sha256 = "1w6dg2n0alfjsx1iy6s53783invygwxk11p1i65cc3nq3zlidcgx";
  };

  NIX_CFLAGS_COMPILE = [
    "-std=c++11"
  ];

  nativeBuildInputs = [
    gettext
    intltool
    pkgconfig
    python
  ];

  buildInputs = [
    avahi
    #bluez
    boost
    eigen
    fftw
    glib
    glibmm
    gtk2
    gtkmm_2
    libjack2
    ladspaH
    librdf
    libsndfile
    lilv
    lv2
    serd
    sord
    sratom
    zita-convolver
    zita-resampler
  ];

  configureFlags = [
    "--nocache"
    "--shared-lib"
    "--lib-dev"
    "--no-ldconfig"
    "--no-desktop-update"
    "--enable-nls"
    "--no-faust" # todo: find out why --faust doesn't work
  ] ++ optional optimizationSupport "--optimization";

  configurePhase = ''
    python waf configure --prefix=$out $configureFlags
  '';

  buildPhase = ''
    python waf build
  '';

  installPhase = ''
    python waf install
  '';

  enableParallelBuilding = true;

  meta = with stdenv.lib; { 
    description = "A virtual guitar amplifier";
    homepage = http://guitarix.sourceforge.net/;
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ ];
    platforms = platforms.linux;
  };
}
