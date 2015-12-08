{ stdenv, fetchurl
, perl
, withCryptodev ? false
  , cryptodevHeaders
}:

with {
  inherit (stdenv.lib)
    optional
    optionals;
};

let
  opensslCrossSystem = attrByPath [ "openssl" "system" ]
    (throw "openssl needs its platform name cross building" null)
    stdenv.cross;
in

stdenv.mkDerivation rec {
  name = "openssl-1.0.2e";

  src = fetchurl {
    urls = [
      "http://www.openssl.org/source/${name}.tar.gz"
      "http://openssl.linux-mirror.org/source/${name}.tar.gz"
    ];
    sha256 = "e23ccafdb75cfcde782da0151731aa2185195ac745eea3846133f2e05c0e0bff";
  };

  outputs = [ "out" "man" ];

  postPatch = ''
    sed -e 's,`cd ./util; ./pod2mantest $(PERL)`,pod2man,g' -i Makefile.org
  '';

  configureScript = "./config";

  configureFlags = [
    "shared"
    "--libdir=lib"
    "--openssldir=etc/ssl"
  ] ++ optionals withCryptodev [
    "-DHAVE_CRYPTODEV"
    "-DUSE_CRYPTODEV_DIGESTS"
  ];

  makeFlags = [
    "MANDIR=$(out)/share/man"
  ];

  nativeBuildInputs = [
    perl
  ];

  buildInputs = optional withCryptodev cryptodevHeaders;

  postInstall = ''
    # If we're building dynamic libraries, then don't install static
    # libraries.
    if [ -n "$(echo $out/lib/*.so $out/lib/*.dylib $out/lib/*.dll)" ]; then
        rm "$out/lib/"*.a
    fi

    # remove dependency on Perl at runtime
    rm -r $out/etc/ssl/misc $out/bin/c_rehash
  '';

  postFixup = ''
    # Check to make sure we don't depend on perl
    if grep -r '${perl}' $out; then
      echo "Found an erroneous dependency on perl ^^^" >&2
      exit 1
    fi
  '';

  crossAttrs = {
    preConfigure=''
      # It's configure does not like --build or --host
      export configureFlags="${concatStringsSep " " (configureFlags ++ [ opensslCrossSystem ])}"
    '';
    configureScript = "./Configure";
  };

  enableParallelBuilding = false;

  meta = {
    homepage = http://www.openssl.org/;
    description = "A cryptographic library that implements the SSL and TLS protocols";
    platforms = stdenv.lib.platforms.all;
    maintainers = [ stdenv.lib.maintainers.simons ];
    priority = 10; # resolves collision with ‘man-pages’
  };
}
