{ stdenv, fetchurl
, makeWrapper

, bzip2
, cairo
, glib
, gtk2
, openssl
, pango
, xorg
}:

let
  inherit (stdenv)
    system
    is64bit;
  inherit (stdenv.lib)
    makeLibraryPath
    optionalString;
  version = "3083";
  libPath = makeLibraryPath [
    cairo
    glib
    gtk2
    pango
    xorg.libX11
  ];
in

let
  sublime-text-bin = stdenv.mkDerivation {
    name = "sublime-text-bin-${version}";

    src = fetchurl {
      url =
        "http://c758482.r82.cf2.rackcdn.com/sublime_text_3_build_${version}" +
        "${if system == "x86_64-linux" then
            "_x64"
          else
            null
          }.tar.bz2";
      sha256 =
        if system == "i686-linux" then
          "0r9irk2gdwdx0dk7lgssr4krfvf3lf71pzaz5hyjc704zaxf5s49"
        else if system == "x86_64-linux" then
          "1vhlrqz7xscmjnxpz60mdpvflanl26d7673ml7psd75n0zvcfra5"
        else
          throw "Sublime Text is not supported on the `${system}` platform";
    };

    nativeBuildInputs = [ makeWrapper ];

    patchPhase = ''
      # Fix desktop entry executable path
      sed \
        -e 's,/opt/sublime_text/sublime_text,sublime_text,' \
        -i sublime_text.desktop
    '';

    buildPhase = ''
      for i in sublime_text plugin_host crash_reporter ; do
        patchelf \
          --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
          --set-rpath ${libPath}:${stdenv.cc.cc}/lib${optionalString is64bit "64"} \
          $i
      done
    '';

    installPhase = ''
      mkdir -p $out/
      cp -prvd * $out/

      # Without this, plugin_host crashes, even though it has the rpath
      wrapProgram \
        $out/plugin_host \
        --prefix LD_PRELOAD : ${stdenv.cc.cc}/lib${optionalString is64bit "64"}/libgcc_s.so.1:${openssl}/lib/libssl.so:${bzip2}/lib/libbz2.so
    '';

    dontStrip = true;
    dontPatchELF = true;
  };
in

stdenv.mkDerivation rec {
  name = "sublime-text-${version}";

  phases = [ "installPhase" ];

  installPhase = ''
    mkdir -p $out/bin
    ln -s ${sublime-text-bin}/sublime_text $out/bin/sublime_text
    ln -s ${sublime-text-bin}/sublime_text $out/bin/subl

    mkdir -p $out/share
    ln -s ${sublime-text-bin}/sublime_text.desktop $out/share/applications
    ln -s ${sublime-text-bin}/Icon/256x256/sublime_text.png $out/share/icons
  '';

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "Sophisticated text editor for code, markup and prose";
    homepage = https://www.sublimetext.com/;
    maintainers = with maintainers; [ codyopel ];
    license = licenses.unfreeRedistributable;
    platforms = [
      "i686-linux"
      "x86_64-linux"
    ];
  };
}