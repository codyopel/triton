{ stdenv, fetchurl
, asciidoc
, docbook_xml_dtd_45
, docbook_xsl
, libxslt
, pkgconfig
, xmlto

, acl
, attr
, e2fsprogs
, libuuid
, lzo
, zlib
}:

stdenv.mkDerivation rec {
  name = "btrfs-progs-${version}";
  version = "4.3.1";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/people/kdave/btrfs-progs/" +
          "btrfs-progs-v${version}.tar.xz";
    sha256 = "0fpxi9pd297lrrynnsyggdwdcb4xvjvn2gvzlzsws0gdvqazzd8c";
  };

  # gcc bug with -O1 on ARM with gcc 4.8
  # This should be fine on all platforms so apply universally
  postPatch = "sed -i s/-O1/-O2/ configure";

  nativeBuildInputs = [
    asciidoc
    docbook_xml_dtd_45
    docbook_xsl
    libxslt
    pkgconfig
    xmlto
  ];

  buildInputs = [
    acl
    attr
    e2fsprogs
    libuuid
    lzo
    zlib
  ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "Utilities for the btrfs filesystem";
    homepage = https://btrfs.wiki.kernel.org/;
    license = licenses.gpl2;
    maintainers = with maintainers; [ wkennington ];
    platforms = platforms.linux;
  };
}
