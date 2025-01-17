# TODO tidy up eg The patchelf code is patching gvim even if you don't build it..
# but I have gvim with python support now :) - Marc
args@{pkgs, source ? "default", fetchurl, fetchhg, stdenv, ncurses, pkgconfig, gettext
, composableDerivation, lib, config, glib, gtk, python, perl, tcl, ruby
, libX11, libXext, libSM, libXpm, libXt, libXaw, libXau, libXmu
, libICE, ... }: with args;


let inherit (args.composableDerivation) composableDerivation edf;
  nixosRuntimepath = pkgs.writeText "nixos-vimrc" ''
    set nocompatible
    syntax on

    function! NixosPluginPath()
      let seen = {}
      for p in reverse(split($NIX_PROFILES))
        for d in split(glob(p . '/share/vim-plugins/*'))
          let pluginname = substitute(d, ".*/", "", "")
          if !has_key(seen, pluginname)
            exec 'set runtimepath^='.d
            let seen[pluginname] = 1
          endif
        endfor
      endfor
    endfunction

    execute NixosPluginPath()

    if filereadable("/etc/vimrc")
      source /etc/vimrc
    elseif filereadable("/etc/vim/vimrc")
      source /etc/vim/vimrc
    endif
  '';
in
composableDerivation {
} (fix: rec {

    name = "vim_configurable-${version}";
    version = "7.4.826";

    enableParallelBuilding = true; # test this

    src =
      builtins.getAttr source {
      "default" =
        # latest release
      args.fetchhg {
            url = "http://vim.googlecode.com/hg/";
            rev = "v${version}";
            sha256 = "01m67lvnkz0ad28ifj964zcg63y5hixplbnzas5xarj8vl3pc5a0";
      };

      "vim-nox" =
          {
            # vim nox branch: client-server without X by uing sockets
            # REGION AUTO UPDATE: { name="vim-nox"; type="hg"; url="https://code.google.com/r/yukihironakadaira-vim-cmdsrv-nox/"; branch="cmdsrv-nox"; }
            src = (fetchurl { url = "http://mawercer.de/~nix/repos/vim-nox-hg-2082fc3.tar.bz2"; sha256 = "293164ca1df752b7f975fd3b44766f5a1db752de6c7385753f083499651bd13a"; });
            name = "vim-nox-hg-2082fc3";
            # END
          }.src;
      };

    prePatch = "cd src";

    configureFlags
      = [ "--enable-gui=${args.gui}" "--with-features=${args.features}" ];

    nativeBuildInputs
      = [ ncurses pkgconfig gtk libX11 libXext libSM libXpm libXt libXaw libXau
          libXmu glib libICE ];

    # most interpreters aren't tested yet.. (see python for example how to do it)
    flags = {
        ftNix = {
          # because we cd to src in the main patch phase, we can't just add this
          # patch to the list, we have to apply it manually
          postPatch = ''
            cd ../runtime
            patch -p2 < ${./ft-nix-support.patch}
            cd ..
          '';
        };
      }
      // edf { name = "xsmp"; } #Disable XSMP session management
      // edf { name = "xsmp_interact"; } #Disable XSMP interaction
      // edf { name = "mzscheme"; feat = "mzschemeinterp";} #Include MzScheme interpreter.
      // edf { name = "perl"; feat = "perlinterp"; enable = { nativeBuildInputs = [perl]; };} #Include Perl interpreter.

      // edf {
        name = "python";
        feat = "pythoninterp";
        enable = {
          nativeBuildInputs = [ python ];
        };
      }

      // edf {
        name = "python3";
        feat = "python3interp";
        enable = {
          nativeBuildInputs = [ pkgs.python3 ];
        };
      }

      // edf { name = "tcl"; feat = "tclinterp"; enable = { nativeBuildInputs = [tcl]; }; } #Include Tcl interpreter.
      // edf { name = "ruby"; feat = "rubyinterp"; enable = { nativeBuildInputs = [ruby]; };} #Include Ruby interpreter.
      // edf {
        name = "lua";
        feat = "luainterp";
        enable = {
          nativeBuildInputs = [lua];
          configureFlags = [
            "--with-lua-prefix=${args.lua}"
            "--enable-luainterp"
          ];
        };
      }
      // edf { name = "cscope"; } #Include cscope interface.
      // edf { name = "workshop"; } #Include Sun Visual Workshop support.
      // edf { name = "netbeans"; } #Disable NetBeans integration support.
      // edf { name = "sniff"; feat = "sniff" ; } #Include Sniff interface.
      // edf { name = "multibyte"; } #Include multibyte editing support.
      // edf { name = "hangulinput"; feat = "hangulinput" ;} #Include Hangul input support.
      // edf { name = "xim"; } #Include XIM input support.
      // edf { name = "fontset"; } #Include X fontset output support.
      // edf { name = "acl"; } #Don't check for ACL support.
      // edf { name = "gpm"; } #Don't use gpm (Linux mouse daemon).
      // edf { name = "nls"; enable = {nativeBuildInputs = [gettext];}; } #Don't support NLS (gettext()).
      ;

  cfg = {
    luaSupport       = config.vim.lua or true;
    pythonSupport    = config.vim.python or true;
    python3Support   = config.vim.python3 or false;
    rubySupport      = config.vim.ruby or true;
    nlsSupport       = config.vim.nls or false;
    tclSupport       = config.vim.tcl or false;
    multibyteSupport = config.vim.multibyte or false;
    cscopeSupport    = config.vim.cscope or true;
    netbeansSupport  = config.netbeans or true; # eg envim is using it

    # add .nix filetype detection and minimal syntax highlighting support
    ftNixSupport     = config.vim.ftNix or true;
  };

  #--enable-gui=OPTS     X11 GUI default=auto OPTS=auto/no/gtk/gtk2/gnome/gnome2/motif/athena/neXtaw/photon/carbon
    /*
      // edf "gtk_check" "gtk_check" { } #If auto-select GUI, check for GTK default=yes
      // edf "gtk2_check" "gtk2_check" { } #If GTK GUI, check for GTK+ 2 default=yes
      // edf "gnome_check" "gnome_check" { } #If GTK GUI, check for GNOME default=no
      // edf "motif_check" "motif_check" { } #If auto-select GUI, check for Motif default=yes
      // edf "athena_check" "athena_check" { } #If auto-select GUI, check for Athena default=yes
      // edf "nextaw_check" "nextaw_check" { } #If auto-select GUI, check for neXtaw default=yes
      // edf "carbon_check" "carbon_check" { } #If auto-select GUI, check for Carbon default=yes
      // edf "gtktest" "gtktest" { } #Do not try to compile and run a test GTK program
    */

  postInstall = stdenv.lib.optionalString stdenv.isLinux ''
    rpath=`patchelf --print-rpath $out/bin/vim`;
    for i in $nativeBuildInputs; do
      echo adding $i/lib
      rpath=$rpath:$i/lib
    done
    echo $nativeBuildInputs
    echo $rpath
    patchelf --set-rpath $rpath $out/bin/{vim,gvim}

    ln -sfn ${nixosRuntimepath} $out/share/vim/vimrc
  '';

  dontStrip = 1;

  meta = with stdenv.lib; {
    description = "The most popular clone of the VI editor";
    homepage    = http://www.vim.org;
    license = licenses.vim;
    maintainers = with maintainers; [ lovek323 ];
    platforms   = platforms.unix;
  };
})

