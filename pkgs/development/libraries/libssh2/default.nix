{ stdenv, fetchurl

# Optional Dependencies
, zlib ? null

# Crypto Dependencies
, openssl ? null
}:

with stdenv;

with stdenv.lib;
stdenv.mkDerivation rec {
  name = "libssh2-1.6.0";

  src = fetchurl {
    url = "${meta.homepage}/download/${name}.tar.gz";
    sha256 = "05c2is69c50lyikkh29nk6zhghjk4i7hjx0zqfhq47aald1jj82s";
  };

  buildInputs = [ openssl zlib ];

  configureFlags = [
    "--enable-largefile"
    "--enable-rpath"
    "--disable-crypt-none"
    "--disable-mac-none"
    "--enable-gex-new"
    "--disable-examples-build"
    "--disable-debug"
    "--with-openssl"
    "--without-libgcrypt"
    "--without-wincng"
    "--with-libz"
    "--with-libssl-prefix=${openssl}"
    "--with-libz-prefix=${zlib}"
  ];

  postInstall = ''
    sed -i \
      -e 's,\(-lz\),-L${zlib}/lib \1,' \
      -e 's,\(-lssl\|-lcrypto\),-L${openssl}/lib \1,' \
      $out/lib/libssh2.la
  '';

  meta = {
    description = "A client-side C library implementing the SSH2 protocol";
    homepage = http://www.libssh2.org;
    license = licenses.gpl2;
    maintainers = with maintainers; [ wkennington ];
    platforms = platforms.all;
  };
}
