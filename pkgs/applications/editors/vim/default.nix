{ stdenv, fetchFromGitHub, ncurses, gettext, pkgconfig
}:

stdenv.mkDerivation rec {
  name = "vim-${version}";
  version = "7.4.942";

  src = fetchFromGitHub {
    owner = "vim";
    repo = "vim";
    rev = "v${version}";
    sha256 = "0sssriw63s69fykf60g444340xqpz0vy99i3bbb58hsxga9nz0mh";
  };

  enableParallelBuilding = true;

  buildInputs = [ ncurses pkgconfig ];
  nativeBuildInputs = [ gettext ];

  configureFlags = [
    "--enable-multibyte"
    "--enable-nls"
  ];

  postInstall = "ln -s $out/bin/vim $out/bin/vi";

  crossAttrs = {
    configureFlags = [
      "vim_cv_toupper_broken=no"
      "--with-tlib=ncurses"
      "vim_cv_terminfo=yes"
      "vim_cv_tty_group=tty"
      "vim_cv_tty_mode=0660"
      "vim_cv_getcwd_broken=no"
      "vim_cv_stat_ignores_slash=yes"
      "ac_cv_sizeof_int=4"
      "vim_cv_memmove_handles_overlap=yes"
      "vim_cv_memmove_handles_overlap=yes"
      "STRIP=${stdenv.cross.config}-strip"
    ];
  };

  # To fix the trouble in vim73, that it cannot cross-build with this patch
  # to bypass a configure script check that cannot be done cross-building.
  # http://groups.google.com/group/vim_dev/browse_thread/thread/66c02efd1523554b?pli=1
  # patchPhase = ''
  #   sed -i -e 's/as_fn_error.*int32.*/:/' src/auto/configure
  # '';

  meta = with stdenv.lib; {
    description = "The most popular clone of the VI editor";
    homepage    = http://www.vim.org;
    license = licenses.vim;
    maintainers = with maintainers; [ lovek323 ];
    platforms   = platforms.unix;
  };
}
