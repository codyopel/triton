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

# nodejs 0.12 can't be built on armv5tel. Armv6 with FPU, minimum I think.
# Related post: http://zo0ok.com/techfindings/archives/1820
assert stdenv.system != "armv5tel-linux";

let
  version = "4.1.0";

  deps = {
    inherit openssl zlib libuv;

    # disabled system v8 because v8 3.14 no longer receives security fixes
    # we fall back to nodejs' internal v8 copy which receives backports for now
    # inherit v8
    inherit http-parser;
  };

  sharedConfigureFlags = name: [
    "--shared-${name}"
    "--shared-${name}-includes=${builtins.getAttr name deps}/include"
    "--shared-${name}-libpath=${builtins.getAttr name deps}/lib"
  ];

  inherit (stdenv.lib) concatMap optional optionals maintainers licenses platforms;
in stdenv.mkDerivation {
  name = "nodejs-${version}";

  src = fetchurl {
    url = "http://nodejs.org/dist/v${version}/node-v${version}.tar.gz";
    sha256 = "453005f64ee529f7dcf1237eb27ee2fa2415c49f5c9e7463e8b71fba61c5b408";
  };

  configureFlags = concatMap sharedConfigureFlags (builtins.attrNames deps) ++ [
    "--without-dtrace" ];
  dontDisableStatic = true;
  prePatch = ''
    patchShebangs .
  '';

  buildInputs = [ python which http-parser zlib libuv openssl python ]
    ++ (optional stdenv.isLinux utillinux);
  setupHook = ./setup-hook.sh;

  enableParallelBuilding = true;

  passthru.interpreterName = "nodejs";

  meta = {
    description = "Event-driven I/O framework for the V8 JavaScript engine";
    homepage = http://nodejs.org;
    license = licenses.mit;
    maintainers = [ ];
    platforms = platforms.linux;
  };
}
