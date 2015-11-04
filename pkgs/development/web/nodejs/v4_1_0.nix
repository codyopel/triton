{ stdenv, fetchurl
, openssl
, python
, zlib
, libuv
, v8
, utillinux
, http-parser
, pkgconfig
, runCommand
, which
}:

with {
    inherit (stdenv.lib)
      concatMap
      optional
      optionals
      maintainers
      licenses
      platforms;
};

let
  version = "4.1.0";

  deps = {
    inherit openssl zlib libuv http-parser;

    # disabled system v8 because v8 3.14 no longer receives security fixes
    # we fall back to nodejs' internal v8 copy which receives backports for now
    # inherit v8
  };
in

stdenv.mkDerivation {
  name = "nodejs-${version}";

  src = fetchurl {
    url = "http://nodejs.org/dist/v${version}/node-v${version}.tar.gz";
    sha256 = "025lqmhvl7xpx1ip97jwkz21a97sw9zb4zi3y7fgfag59vv0ac25";
  };

  setupHook = ./setup-hook.sh;

  postPatch = ''
    patchShebangs .
  '';

  configureFlags = map (name: "--shared-${name}") (builtins.attrNames deps) ++ [
    "--without-dtrace"
  ];

  buildInputs = [ python which ] ++ (builtins.attrValues deps)
    ++ optional stdenv.isLinux utillinux;

  dontDisableStatic = true;
  enableParallelBuilding = true;

  passthru.interpreterName = "nodejs";

  meta = {
    description = "Event-driven I/O framework for the V8 JavaScript engine";
    homepage = http://nodejs.org;
    license = licenses.mit;
    maintainers = [ ];
    platforms = platforms.linux ;
  };
}
