{ stdenv, fetchFromGitHub
, cmake
, gettext
, libtool
, makeWrapper
, pkgconfig

, glib
, libmsgpack
, libtermkey
, libuv
, lpeg
, lua
, luajit
, luaMessagePack
, luabitop
, ncurses
, perl
, unibilium
, vimUtils

, withPython ? true, pythonPackages, extraPythonPackages ? []
, withPython3 ? true, python3Packages, extraPython3Packages ? []
, withJemalloc ? true, jemalloc

, vimAlias ? false
, configure ? null
}:

with {
  inherit (stdenv.lib)
    optional
    optionalString;
};

let
  version = "2015-10-28";

  # Note: this is NOT the libvterm already in nixpkgs, but some NIH silliness:
  neovimLibvterm = let version = "2015-10-26"; in stdenv.mkDerivation {
    name = "neovim-libvterm-${version}";

    src = fetchFromGitHub {
      owner = "neovim";
      repo = "libvterm";
      rev = "c4317a6d86a753e4e6f3cef830eae24febcb5a0b";
      sha256 = "031ksvdpnb61a31sicvkcvlnd55cxq6pr5rvz4bdj2hgdm5ly4g4";
    };
  
    nativeBuildInputs = [
      libtool
    ];

    buildInputs = [
      perl
    ];

    makeFlags = [
      "PREFIX=$(out)"
    ];

    enableParallelBuilding = true;

    meta = with stdenv.lib; {
      description = "VT220/xterm/ECMA-48 terminal emulator library";
      homepage = http://www.leonerd.org.uk/code/libvterm/;
      license = licenses.mit;
      maintainers = with maintainers; [ ];
      platforms = platforms.unix;
    };
  };

  pythonEnv = pythonPackages.python.buildEnv.override {
    extraLibs = [ pythonPackages.neovim ] ++ extraPythonPackages;
    ignoreCollisions = true;
  };

  python3Env = python3Packages.python.buildEnv.override {
    extraLibs = [ python3Packages.neovim ] ++ extraPython3Packages;
    ignoreCollisions = true;
  };

  neovim = stdenv.mkDerivation {
    name = "neovim-${version}";

    src = fetchFromGitHub {
      owner = "neovim";
      repo = "neovim";
      rev = "dc8b0c47b10a5a7a1280a768b181f23bd990ab6e";
      sha256 = "0357286dki7gn2537n22bzsi7jyzdm7q94kgqzjmqikfn5wziz5a";
    };

    nativeBuildInputs = [
      cmake
      gettext
      makeWrapper
      pkgconfig
    ];

    buildInputs = [
      glib
      libtermkey
      libuv
      luajit
      lua
      lpeg
      luaMessagePack
      luabitop
      libmsgpack
      ncurses
      neovimLibvterm
      unibilium
    ] ++ optional withJemalloc jemalloc;

    LUA_CPATH="${lpeg}/lib/lua/${lua.luaversion}/?.so;${luabitop}/lib/lua/5.3/?.so";
    LUA_PATH="${luaMessagePack}/share/lua/5.3/?.lua";

    postInstall = optionalString withPython ''
      ln -s ${pythonEnv}/bin/python $out/bin/nvim-python
    '' + optionalString withPython3 ''
      ln -s ${python3Env}/bin/python3 $out/bin/nvim-python3
    '' + optionalString (withPython || withPython3) ''
        wrapProgram $out/bin/nvim --add-flags "${
          (optionalString withPython
            ''--cmd \"let g:python_host_prog='$out/bin/nvim-python'\" '') +
          (optionalString withPython3
            ''--cmd \"let g:python3_host_prog='$out/bin/nvim-python3'\" '')
        }"
    '';

    enableParallelBuilding = true;

    meta = with stdenv.lib; {
      description = "Vim text editor fork focused on extensibility and agility";
      homepage = http://www.neovim.io;
      license = with licenses; [ asl20 vim ];
      maintainers = with maintainers; [ ];
      platforms = platforms.unix;
    };
  };

in if (vimAlias == false && configure == null) then neovim else stdenv.mkDerivation {
  name = "neovim-${version}-configured";
  nativeBuildInputs = [ makeWrapper ];
  buildCommand = ''
    mkdir -p $out/bin
    for item in ${neovim}/bin/*; do
      ln -s $item $out/bin/
    done
  '' + optionalString vimAlias ''
    ln -s $out/bin/nvim $out/bin/vim
  '' + optionalString (configure != null) ''
    wrapProgram $out/bin/nvim --add-flags "-u ${vimUtils.vimrcFile configure}"
  '';
}
