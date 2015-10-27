{ stdenv, fetchurl
, makeWrapper
, makeDesktopItem

, zlib
, glib
, libpng
, freetype
, xorg
, fontconfig
, qt55
, xkeyboard_config
, alsaLib
, libpulseaudio ? null
, libredirect
, quazip
, less
, which
, unzip
}:

let
  arch = if stdenv.is64bit then "amd64" else "x86";
  libDir = if stdenv.is64bit then "lib64" else "lib";
  deps = [
    zlib
    glib
    libpng
    freetype
    xorg.libSM
    xorg.libICE
    xorg.libXrender
    xorg.libXrandr
    xorg.libXfixes
    xorg.libXcursor
    xorg.libXinerama
    xorg.libxcb
    fontconfig
    xorg.libXext
    xorg.libX11
    alsaLib
    qt55.qtbase
    libpulseaudio
  ];
  desktopItem = makeDesktopItem {
    name = "teamspeak";
    exec = "ts3client";
    icon = "teamspeak";
    comment = "The TeamSpeak voice communication tool";
    desktopName = "TeamSpeak";
    genericName = "TeamSpeak";
    categories = "Network";
  };
in

stdenv.mkDerivation rec {
  name = "teamspeak-client-${version}";
  version = "3.0.18.2";

  src = fetchurl {
    urls = [
      "http://dl.4players.de/ts/releases/${version}/TeamSpeak3-Client-linux_${arch}-${version}.run"
      "http://teamspeak.gameserver.gamed.de/ts3/releases/${version}/TeamSpeak3-Client-linux_${arch}-${version}.run"
    ];
    sha256 =
      if stdenv.isx86_64 then
        "1r0l0jlng1fz0cyvnfa4hqwlszfraj5kcs2lg9qnqvp03x8sqn6h"
      else
        "1pgpsv1r216l76fx0grlqmldd9gha3sj84gnm44km8y98b3hj525";
  };

  # grab the plugin sdk for the desktop icon
  pluginsdk = fetchurl {
    url = "http://dl.4players.de/ts/client/pluginsdk/pluginsdk_3.0.18.1.zip";
    sha256 = "108y52mfg44cnnhhipnmrr0cxh7ram5c2hnchxjkwvf5766vbaq4";
  };

  unpackPhase = ''
    echo -e 'q\ny' | sh -xe $src
    cd TeamSpeak*
  '';

  buildInputs = [
    makeWrapper
    less
    which
    unzip
  ];

  buildPhase = ''
    mv ts3client_linux_${arch} ts3client
    echo "patching ts3client..."
    patchelf \
      --interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
      --set-rpath ${stdenv.lib.makeLibraryPath deps}:$(cat $NIX_CC/nix-support/orig-cc)/${libDir} \
      --force-rpath \
      ts3client
  '';

  installPhase = ''
    # Delete unecessary libraries - these are provided by nixos.
    rm *.so*
    rm qt.conf

    # Install files.
    mkdir -p $out/lib/teamspeak
    mv * $out/lib/teamspeak/

    # Make a desktop item
    mkdir -p $out/share/applications/ $out/share/icons/
    unzip ${pluginsdk}
    cp pluginsdk/docs/client_html/images/logo.png $out/share/icons/teamspeak.png
    cp ${desktopItem}/share/applications/* $out/share/applications/

    # Make a symlink to the binary from bin.
    mkdir -p $out/bin/
    ln -s $out/lib/teamspeak/ts3client $out/bin/ts3client

    wrapProgram $out/bin/ts3client \
      --set LD_LIBRARY_PATH "${quazip}/lib" \
      --set LD_PRELOAD "${libredirect}/lib/libredirect.so" \
      --set QT_PLUGIN_PATH "$out/lib/teamspeak/platforms" \
      --set NIX_REDIRECTS /usr/share/X11/xkb=${xkeyboard_config}/share/X11/xkb
  '';

  dontStrip = true;
  dontPatchELF = true;
  
  meta = with stdenv.lib; { 
    description = "The TeamSpeak voice communication tool";
    homepage = http://teamspeak.com/;
    license = licenses.unfreeRedistributable;
    maintainers = [ ];
    platforms = [
      "i686-linux"
      "x86_64-linux"
    ];
  };
}
