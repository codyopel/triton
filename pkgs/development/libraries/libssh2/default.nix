{ stdenv, fetchurl

# Optional Dependencies
, zlib ? null

# Crypto Dependencies
, openssl ? null, libgcrypt ? null
}:

with stdenv;
let
  # Prefer openssl
  cryptoStr =
    if shouldUsePkg openssl != null then
      "openssl"
    else if shouldUsePkg libgcrypt != null then
      "libgcrypt"
    else
      "none";
  crypto = {
    openssl = openssl;
    libgcrypt = libgcrypt;
    none = null;
  }.${cryptoStr};

  optZlib = shouldUsePkg zlib;
in

assert crypto != null;

with stdenv.lib;
stdenv.mkDerivation rec {
  name = "libssh2-1.6.0";

  src = fetchurl {
    url = "${meta.homepage}/download/${name}.tar.gz";
    sha256 = "05c2is69c50lyikkh29nk6zhghjk4i7hjx0zqfhq47aald1jj82s";
  };

  buildInputs = [ crypto optZlib ];

  configureFlags = [
    (mkWith   (cryptoStr == "openssl")   "openssl"        null)
    (mkWith   (cryptoStr == "libgcrypt") "libgcrypt"      null)
    (mkWith   false                      "wincng"         null)
    (mkWith   optZlib                    "libz"           null)
    (mkEnable false                      "crypt-none"     null)
    (mkEnable false                      "mac-none"       null)
    (mkEnable true                       "gex-new"        null)
    #(mkEnable true                       "clear-memory"   null) Use autodetection
    (mkEnable false                      "debug"          null)
    (mkEnable false                      "examples-build" null)
  ];

  postInstall = ''
    sed -i \
  '' + optionalString (optZlib != null) ''
      -e 's,\(-lz\),-L${optZlib}/lib \1,' \
  '' + optionalString (cryptoStr == "openssl") ''
      -e 's,\(-lssl\|-lcrypto\),-L${openssl}/lib \1,' \
  '' + optionalString (cryptoStr == "libgcrypt") ''
      -e 's,\(-lgcrypt\),-L${libgcrypt}/lib \1,' \
  '' + ''
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
