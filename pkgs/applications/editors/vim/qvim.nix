args@{ fetchgit, stdenv, ncurses, pkgconfig, gettext
, composableDerivation, lib, config, python, perl, tcl, ruby, qt4
, libX11, libXext, libSM, libXpm, libXt, libXaw, libXau, libXmu
, libICE, ... }: with args;

let tag = "20140827";
    sha256 = "02adf2212872db3c5d133642d2c12fbfc28b506e4c0c42552e3d079756f63f65";
in

let inherit (args.composableDerivation) composableDerivation edf; in
composableDerivation {
} (fix: {

    name = "qvim-7.4." + tag;

    enableParallelBuilding = true; # test this

    src = fetchgit {
      url = https://bitbucket.org/equalsraf/vim-qt.git ;
      rev = "refs/tags/package-" + tag;
      inherit sha256;
    };

    configureFlags = [ "--with-vim-name=qvim" "--enable-gui=qt" "--with-features=${args.features}" ];

    nativeBuildInputs
      = [ ncurses pkgconfig libX11 libXext libSM libXpm libXt libXaw libXau
          libXmu libICE qt4];

    # most interpreters aren't tested yet.. (see python for example how to do it)
    flags = {
        ftNix = {
          # because we cd to src in the main patch phase, we can't just add this
          # patch to the list, we have to apply it manually
          postPatch = ''
            cd runtime
            patch -p2 < ${./ft-nix-support.patch}
            cd ..
          '';
        };
      }
      // edf { name = "xsmp"; } #Disable XSMP session management
      // edf { name = "xsmp_interact"; } #Disable XSMP interaction
      // edf { name = "mzscheme"; } #Include MzScheme interpreter.
      // edf { name = "perl"; feat = "perlinterp"; enable = { nativeBuildInputs = [perl]; };} #Include Perl interpreter.

      // edf {
        name = "python";
        feat = "pythoninterp";
        enable = {
          nativeBuildInputs = [ python ];
        };
      }

      // edf { name = "tcl"; enable = { nativeBuildInputs = [tcl]; }; } #Include Tcl interpreter.
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
    rubySupport      = config.vim.ruby or true;
    nlsSupport       = config.vim.nls or false;
    tclSupport       = config.vim.tcl or false;
    multibyteSupport = config.vim.multibyte or false;
    cscopeSupport    = config.vim.cscope or false;
    netbeansSupport  = config.netbeans or true; # eg envim is using it

    # add .nix filetype detection and minimal syntax highlighting support
    ftNixSupport     = config.vim.ftNix or true;
  };

  postInstall = stdenv.lib.optionalString stdenv.isLinux ''
    rpath=`patchelf --print-rpath $out/bin/qvim`;
    for i in $nativeBuildInputs; do
      echo adding $i/lib
      rpath=$rpath:$i/lib
    done
    echo $nativeBuildInputs
    echo $rpath
    patchelf --set-rpath $rpath $out/bin/qvim
  '';

  dontStrip = 1;

  meta = with stdenv.lib; {
    description = "The most popular clone of the VI editor (Qt GUI fork)";
    homepage    = https://bitbucket.org/equalsraf/vim-qt/wiki/Home;
    license = licenses.vim;
    maintainers = with maintainers; [ smironov ttuegel ];
    platforms   = platforms.linux;
  };
})

