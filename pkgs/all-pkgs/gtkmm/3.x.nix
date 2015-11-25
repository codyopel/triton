{ stdenv, fetchurl
, pkgconfig

, atkmm
, cairomm
, epoxy
, glibmm
, gnome3
, gtk3
, pangomm
}:

stdenv.mkDerivation rec {
  name = "gtkmm-${version}";
  versionMajor = "3.18";
  versionMinor = "0";
  version = "${versionMajor}.${versionMinor}";

  src = fetchurl {
    url = "mirror://gnome/sources/gtkmm/${versionMajor}/${name}.tar.xz";
    sha256 = "0sxq700invkjpksn790gbnl8px8751kvgwn39663jx7dv89s37w2";
  };

  configureFlags = [
    "--disable-quartz-backend"
    "--enable-x11-backend=yes"
    "--enable-wayland-backend=yes"
    "--enable-brodway-backend=yes"
    "--enable-api-atkmm"
    # Requires glibmm deprecated api
    "--enable-deprecated-api"
    "--without-libstdc-doc"
    "--without-libsigc-doc"
    "--without-cairomm-doc"
    "--without-pangomm-doc"
    "--without-atkmm-doc"
  ];

  NIX_CFLAGS_COMPILE = [
    "-std=c++11"
  ];

  nativeBuildInputs = [
    pkgconfig
  ];

  propagatedBuildInputs = [
    atkmm
    cairomm
    glibmm
    gtk3
    pangomm
  ];

  buildInputs = [
    epoxy
  ];

  postInstall = ''
    # gtkmm use C++11 features in headers, programs linking against gtkmm
    # will also need C++11 enabled.
    sed -e 's,Cflags:,Cflags: -std=c++11,' -i $out/lib/pkgconfig/*.pc
  '';

  doCheck = true;
  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "C++ interface to the GTK+ graphical user interface library";
    homepage = http://gtkmm.org/;
    license = licenses.lgpl2Plus;
    maintainers = with maintainers; [ ];
    platforms = platforms.unix;
  };
}
