{ stdenv, fetchurl
, cmake
, coreutils

, cups
, xorg

, qt5

, channel ? "5.5"
, developerBuild ? false
}:

with {
  inherit (builtins.getAttr "qtbase" (import (../.. + "/sources-${channel}.nix")))
    versionMicro
    sha256;
  inherit (stdenv.lib)
    cmFlag
    optionalString;
};

stdenv.mkDerivation rec {
  name = "qtbase-${channel}.${versionMicro}";

  src = fetchurl {
    url = "https://download.qt.io/archive/qt/${channel}/" +
          "${channel}.${versionMicro}/submodules/" +
          "qtbase-opensource-src-${channel}.${versionMicro}.tar.xz";
    inherit sha256;
  };

  patches = [
    #./0001-dlopen-gtkstyle.patch
    #./0002-dlopen-resolv.patch
    #./0003-dlopen-gl.patch
    #./0004-tzdir.patch
    #./0005-dlopen-libXcursor.patch
    #./0006-dlopen-openssl.patch
    #./0007-dlopen-dbus.patch
    #./0008-xdg-config-dirs.patch
    #./0009-decrypt-ssl-traffic.patch
    #./0014-mkspecs-libgl.patch
  ];

  postPatch = ''
    substituteInPlace configure \
      --replace /bin/pwd pwd
    #substituteInPlace qtbase/configure \
    #  --replace /bin/pwd pwd
    #substituteInPlace qtbase/src/corelib/global/global.pri \
    #  --replace /bin/ls ${coreutils}/bin/ls
    #substituteInPlace qtbase/src/plugins/platforminputcontexts/compose/generator/qtablegenerator.cpp \
    #    --replace /usr/share/X11/locale ${xorg.libX11}/share/X11/locale \
    #    --replace /usr/lib/X11/locale ${xorg.libX11}/share/X11/locale
    sed -e 's@/\(usr\|opt\)/@/var/empty/@g' \
        -i config.tests/*/*.test \
        -i qtbase/mkspecs/*/*.conf
  '';

  configureFlags = [
    "-verbose"
    "-confirm-license"
    "-opensource"

    "-release"
    "-shared"
    "-c++11"
    "${optionalString developerBuild "-developer-build"}"
    "-largefile"
    "-accessibility"
    "-rpath"
    "-optimized-qmake"
    "-strip"
    "-reduce-relocations"
    "-system-proxies"
    "-pkg-config"

    "-gui"
    "-widgets"
    "-opengl desktop"
    "-qml-debug"
    "-nis"
    "-iconv"
    "-icu"
    "-pch"
    "-glib"
    "-xcb"
    "-qpa xcb"
    "-${optionalString (cups == null) "no-"}cups"
    #"-${optionalString (!gtkStyle) "no-"}gtkstyle"

    "-no-eglfs"
    "-no-directfb"
    "-no-linuxfb"
    "-no-kms"

    #"${optionalString (!system-x86_64) "-no-sse2"}"
    "-no-sse3"
    "-no-ssse3"
    "-no-sse4.1"
    "-no-sse4.2"
    "-no-avx"
    "-no-avx2"
    "-no-mips_dsp"
    "-no-mips_dspr2"

    "-system-zlib"
    "-system-libpng"
    "-system-libjpeg"
    "-system-xcb"
    "-system-xkbcommon"
    "-openssl-linked"
    "-dbus-linked"

    "-system-sqlite"
    #"-${if mysql != null then "plugin" else "no"}-sql-mysql"
    #"-${if postgresql != null then "plugin" else "no"}-sql-psql"

    "-make libs"
    "-make tools"
    #"-${optionalString (buildExamples == false) "no"}make examples"
    #"-${optionalString (buildTests == false) "no"}make tests"
  ];

  nativeBuildInputs = [
    #cmake
  ];

  buildInputs = [
  ];

  meta = with stdenv.lib; {
    description = "Provides functionality for near-realtime simulation systems";
    homepage = "http://www.qt.io/";
    license = licenses.gpl3;
    maintainers = with maintainers; [ ];
    platforms = [
      "i686-linux"
      "x86_64-linux"
    ];
  };
}
