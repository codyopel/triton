{ stdenv, fetchurl
, makeWrapper
}:

let
  version = "3.0.11.4";
  arch =
    if stdenv.isx86_64 then
      "amd64"
    else
      "x86";
  libDir =
    if stdenv.isx86_64 then
      "lib64"
    else
      "lib";
in

stdenv.mkDerivation {
  name = "teamspeak-server-${version}";

  src = fetchurl {
    urls = [
       "http://dl.4players.de/ts/releases/${version}/teamspeak3-server_linux-${arch}-${version}.tar.gz"
      "http://teamspeak.gameserver.gamed.de/ts3/releases/${version}/teamspeak3-server_linux-${arch}-${version}.tar.gz"
    ];
    sha256 =
      if stdenv.isx86_64 then
        "9606dd5c0c3677881b1aab833cb99f4f12ba08cc77ef4a97e9e282d9e10b0702"
      else
        "8b8921e0df04bf74068a51ae06d744f25d759a8c267864ceaf7633eb3f81dbe5";
  };

  buildInputs = [
    makeWrapper
  ];

  buildPhase = ''
    mv ts3server_linux_${arch} ts3server
    echo "patching ts3server"
    patchelf \
      --interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
      --set-rpath $(cat $NIX_CC/nix-support/orig-cc)/${libDir} \
      --force-rpath \
      ts3server
  '';

  installPhase = ''
    # Delete unecessary libraries - these are provided by nixos.
    #rm *.so*

    # Install files.
    mkdir -p $out/lib/teamspeak
    mv * $out/lib/teamspeak/

    # Make a symlink to the binary from bin.
    mkdir -p $out/bin/
    ln -s $out/lib/teamspeak/ts3server $out/bin/ts3server

    wrapProgram $out/lib/teamspeak/ts3server \
      --prefix LD_LIBRARY_PATH : $out/lib/teamspeak
  '';

  dontStrip = true;
  dontPatchELF = true;
  
  meta = with stdenv.lib; { 
    description = "TeamSpeak voice communication server";
    homepage = http://teamspeak.com/;
    license = licenses.unfreeRedistributable;
    maintainers = [ ];
    platforms = [
      "i686-linux"
      "x86_64-linux"
    ];
  };
}
