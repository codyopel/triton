{ stdenv, fetchurl
, acl
}:

with {
  inherit (stdenv.lib)
    optionalString;
};

stdenv.mkDerivation rec {
  name = "gnutar-${version}";
  version = "1.28";

  src = fetchurl {
    url = "mirror://gnu/tar/tar-${version}.tar.bz2";
    sha256 = "0qkm2k9w8z91hwj8rffpjj9v1vhpiriwz4cdj36k9vrgc3hbzr30";
  };

  configureFlags = [
    "--enable-largefile"
    "--enable-acl"
    "--disable-gcc-warnings"
    "--enable-rpath"
    "--enable-nls"
    "--disable-backup-scripts"
    "--with-posic-acls"
    "--with-included-regex"
    "--without-selinux"
    "--with-xattrs"
  ];

  # May have some issues with root compilation because the bootstrap tool
  # cannot be used as a login shell for now.
  FORCE_UNSAFE_CONFIGURE =
    optionalString (stdenv.system == "armv7l-linux" || stdenv.isSunOS) "1";

  buildInputs = [
    acl
  ];

  doCheck = true;
  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "GNU implementation of the `tar' archiver";
    homepage = http://www.gnu.org/software/tar/;
    license = licenses.gpl3Plus;
    maintainers = [ ];
    platforms = platforms.all;
  };
}
