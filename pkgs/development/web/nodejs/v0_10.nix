{ stdenv, fetchurl
, openssl
, python
, zlib
, v8
, utillinux
, http-parser
, c-ares
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
  version = "0.10.38";

  # !!! Should we also do shared libuv?
  deps = {
    inherit openssl zlib http-parser;

    # disabled system v8 because v8 3.14 no longer receives security fixes
    # we fall back to nodejs' internal v8 copy which receives backports for now
    # inherit v8
  } // ({ cares = c-ares; });

  sharedConfigureFlags = name: [
    "--shared-${name}"
    "--shared-${name}-includes=${builtins.getAttr name deps}/include"
    "--shared-${name}-libpath=${builtins.getAttr name deps}/lib"
  ];
in

stdenv.mkDerivation {
  name = "nodejs-${version}";

  src = fetchurl {
    url = "http://nodejs.org/dist/v${version}/node-v${version}.tar.gz";
    sha256 = "12xpa9jzry5g0j41908498qqs8v0q6miqkv6mggyzas8bvnshgai";
  };

  setupHook = ./setup-hook.sh;

  postPatch = ''
    patchShebangs .
  '';

  configureFlags = concatMap sharedConfigureFlags (builtins.attrNames deps);

  buildInputs = [
    pkgconfig
    python
    openssl
    which
  ] ++ optional stdenv.isLinux utillinux;

  enableParallelBuilding = true;

  passthru.interpreterName = "nodejs-0.10";

  meta = {
    description = "Event-driven I/O framework for the V8 JavaScript engine";
    homepage = http://nodejs.org;
    license = licenses.mit;
    maintainers = [ ];
    platforms = platforms.linux;
  };
}
