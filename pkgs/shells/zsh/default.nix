{ stdenv, fetchurl
, perl

, coreutils
, gdbm
, libcap
, libiconv
, ncurses
, pcre

, debugging ? false 
}:

with {
  inherit (stdenv.lib)
    enFlag;
};

let
  version = "5.1.1";
  documentation = fetchurl {
    url = "mirror://sourceforge/zsh/zsh-${version}-doc.tar.gz";
    sha256 = "0p99dr7kck0a6im1w9qiiz2ai78mgy53gbbn87bam9ya2885gf05";
  };
in

stdenv.mkDerivation {
  name = "zsh-${version}";

  src = fetchurl {
    url = "mirror://sourceforge/zsh/zsh-${version}.tar.gz";
    sha256 = "11shllzhq53fg8ngy3bgbmpf09fn2czifg7hsb41nxi3410mpvcl";
  };

  patchPhase = ''
    patchShebangs ./Misc/
    patchShebangs ./Util/

    # Test fails on filesystems with noatime
    rm -f ./Test/C02cond.ztst
  '';

  patches = [
    ./zsh-5.1.0-gcc-5.patch
  ];

  configureFlags = [
    "--enable-dynamic"
    "--enable-dynamic-nss"
    "--disable-ansi2knr"
    # Internal malloc is broken
    "--disable-zsh-mem"
    "--enable-stack-allocation"

    "--enable-pcre"
    "--enable-cap"
    "--enable-maildir-support"
    "--enable-gdbm"
    "--with-tcsetpgrp"
    "--enable-function-subdirs"
    "--with-term-lib=ncursesw"
    "--enable-readnullcmd=pager"
    "--enable-locale"
    "--enable-multibyte"

    #"--enable-zshenv="
    "--enable-zprofile=$(out)/etc/zprofile"
    #"--enable-zlogin="
    #"--enable-zlogout="

    # Debug
    (enFlag "zsh-debug" debugging null)
    (enFlag "zsh-mem-debug" debugging null)
    (enFlag "zsh-mem-warning" debugging null)
    (enFlag "zsh-secure-free" debugging null)
    (enFlag "zsh-hash-debug" debugging null)
  ];

  nativeBuildInputs = [
    perl
  ];

  buildInputs = [
    coreutils
    ncurses
    pcre
  ];

  postInstall = ''
    mkdir -p $out/share/
    tar xf ${documentation} -C $out/share

    # TODO: convert this to install a static file
    mkdir -p $out/etc/
    cat > $out/etc/zprofile <<EOF
    if test -e /etc/NIXOS; then
      if test -r /etc/zprofile; then
        . /etc/zprofile
      else
        emulate bash
        alias shopt=false
        . /etc/profile
        unalias shopt
        emulate zsh
      fi
      if test -r /etc/zprofile.local; then
        . /etc/zprofile.local
      fi
    else
      # on non-nixos we just source the global /etc/zprofile as if we did
      # not use the configure flag
      if test -r /etc/zprofile; then
        . /etc/zprofile
      fi
    fi
    EOF

    $out/bin/zsh -c "zcompile $out/etc/zprofile"
    mv $out/etc/zprofile $out/etc/zprofile_zwc_is_used
  '';

  enableParallelBuilding = true;

  # Disabled Test/C02cond.ztst, requires filesystem timestamps
  doCheck = true;

  meta = with stdenv.lib; {
    description = "The Z command shell";
    homepage = "http://www.zsh.org/";
    license = licenses.mit;
    maintainers = with maintainers; [ codyopel ];
    platforms = platforms.unix;
  };
}
