{ stdenv, fetchurl
, bison
, pkgconfig

, glib
, gettext
, perl
, libgdiplus
, libX11
, callPackage
, ncurses
, zlib
, withLLVM ? false
, cacert
}:

let
  llvm     = callPackage ./llvm.nix { };
  llvmOpts = stdenv.lib.optionals withLLVM [
    "--enable-llvm"
    "--enable-llvmloaded"
    "--with-llvm=${llvm}"
  ];
in

stdenv.mkDerivation rec {
  name = "mono-${version}";
  version = "4.0.5.1";
  src = fetchurl {
    url = "http://download.mono-project.com/sources/mono/${name}.tar.bz2";
    sha256 = "0af2bfa6xi8g6p1dr831ldq115gij2cyg44z8k39ccgdvm22kx62";
  };

  # We want pkg-config to take priority over the dlls in the Mono framework and the GAC
  # because we control pkg-config
  patches = [
    ./pkgconfig-before-gac.patch
  ];

  # In fact I think this line does not help at all to what I
  # wanted to achieve: have mono to find libgdiplus automatically
  configureFlags = [
    "--x-includes=${libX11}/include"
    "--x-libraries=${libX11}/lib"
    "--with-libgdiplus=${libgdiplus}/lib/libgdiplus.so"
    "${llvmOpts}"
  ];

  NIX_LDFLAGS = "-lgcc_s" ;

  propagatedBuildInputs = [
    glib
  ];

  buildInputs = [
    bison
    pkgconfig
    glib
    gettext
    perl
    libgdiplus
    libX11
    ncurses
    zlib
  ];

  # Patch all the necessary scripts. Also, if we're using LLVM, we fix the default
  # LLVM path to point into the Mono LLVM build, since it's private anyway.
  preBuild = ''
    makeFlagsArray=("INSTALL=$(type -tp install)")

    patchShebangs ./

    substituteInPlace mcs/class/corlib/System/Environment.cs \
      --replace /usr/share "$out/share"
  '' + stdenv.lib.optionalString withLLVM ''
    substituteInPlace mono/mini/aot-compiler.c \
      --replace "llvm_path = g_strdup (\"\")" "llvm_path = g_strdup (\"${llvm}/bin/\")"
  '';

  # Fix mono DLLMap so it can find libX11 and gdiplus to run winforms apps
  # Other items in the DLLMap may need to be pointed to their store locations, I don't think this is exhaustive
  # http://www.mono-project.com/Config_DllMap
  postBuild = ''
    find . -name 'config' -type f | while read i; do
        sed -i "s@libX11.so.6@${libX11}/lib/libX11.so.6@g" $i
        sed -i "s@/.*libgdiplus.so@${libgdiplus}/lib/libgdiplus.so@g" $i
    done
  '';

  # Without this, any Mono application attempting to open an SSL connection will throw with 
  # The authentication or decryption has failed.
  # ---> Mono.Security.Protocol.Tls.TlsException: Invalid certificate received from server.
  postInstall = ''
    echo "Updating Mono key store"
    $out/bin/cert-sync ${cacert}/etc/ssl/certs/ca-bundle.crt
  '';

  # To overcome the bug https://bugzilla.novell.com/show_bug.cgi?id=644723
  dontDisableStatic = true;
  # Attempt to fix this error when running "mcs --version":
  # The file /nix/store/xxx-mono-2.4.2.1/lib/mscorlib.dll is an invalid CIL image
  dontStrip = true;
  # Parallel building doesn't work, as shows http://hydra.nixos.org/build/2983601
  enableParallelBuilding = false;

  meta = with stdenv.lib; {
    description = "Cross platform, open source .NET development framework";
    homepage = http://mono-project.com/;
    license = licenses.free;
    maintainers = with maintainers; [ ];
    platforms = [
      "i686-linux"
      "x86_64-linux"
    ];
  };
}
