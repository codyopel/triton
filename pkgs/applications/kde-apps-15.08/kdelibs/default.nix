{ kdeApp, attica, attr, automoc4, avahi, bison, cmake
, docbook_xml_dtd_42, docbook_xsl, flex, giflib, herqq, ilmbase
, libdbusmenu_qt, libjpeg, libxml2, libxslt, perl, phonon, pkgconfig
, polkit_qt4, qca2, qt4, shared_desktop_ontologies, shared_mime_info
, soprano, strigi, udev, xz, pcre
, lib
}:

kdeApp {
  name = "kdelibs";

  buildInputs = [
    attica attr avahi giflib herqq libdbusmenu_qt libjpeg libxml2
    polkit_qt4 qca2 shared_desktop_ontologies udev xz pcre
  ];
  propagatedBuildInputs = [ qt4 soprano phonon strigi ];
  nativeBuildInputs = [
    automoc4 bison cmake flex libxslt perl pkgconfig shared_mime_info
  ];

  patches = [
    ./0001-old-kde4-cmake-policies.patch
    ./0002-polkit-install-path.patch
  ];

  # cmake does not detect path to `ilmbase`
  NIX_CFLAGS_COMPILE = "-I${ilmbase}/include/OpenEXR";

  cmakeFlags = [
    "-DDOCBOOKXML_CURRENTDTD_DIR=${docbook_xml_dtd_42}/xml/dtd/docbook"
    "-DDOCBOOKXSL_DIR=${docbook_xsl}/xml/xsl/docbook"
    "-DHUPNP_ENABLED=ON"
    "-DWITH_SOLID_UDISKS2=ON"
    "-DKDE_DEFAULT_HOME=.kde"
  ];

  setupHook = ./setup-hook.sh;

  meta = {
    licenses = with lib.licenses; [ gpl2 fdl12 lgpl21 ];
    maintainers = [ lib.maintainers.ttuegel ];
  };
}
