{ stdenv, fetchurl
, pkgconfig

, glib
, libsigcxx
}:

stdenv.mkDerivation rec {
  name = "glibmm-${version}";
  versionMajor = "2.46";
  versionMinor = "2";
  version = "${versionMajor}.${versionMinor}";

  src = fetchurl {
    url = "mirror://gnome/sources/glibmm/${versionMajor}/${name}.tar.xz";
    sha256 = "1j530gcv1qq49m411yc88yx6s91lwsznxjwlp4mww74cfqda08bj";
  };

  configureFlags = [
    "--enable-schemas-compile"
    "--disable-documentation"
    # Compile errors if deprecated api is not enabled
    "--enable-deprecated-api"
    "--without-libstdc-doc"
    "--without-libsigc-doc"
  ];

  NIX_CFLAGS_COMPILE = [
    "-std=c++11"
  ];

  nativeBuildInputs = [
    pkgconfig
  ];

  propagatedBuildInputs = [
    glib
    libsigcxx
  ];

  postInstall = ''
    # glibmm use C++11 features in headers, programs linking against glibmm
    # will also need C++11 enabled.
    sed -e 's,Cflags:,Cflags: -std=c++11,' -i $out/lib/pkgconfig/*.pc
  '';

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "C++ interface to the GLib library";
    homepage = http://gtkmm.org/;
    license = licenses.lgpl2Plus;
    maintainers = with maintainers; [ ];
    platforms = platforms.unix;
  };
}
