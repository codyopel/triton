{ stdenv, fetchurl
, autoreconfHook
, gettext
, perl
, pkgconfig

, ncurses
}:

with {
  inherit (stdenv.lib)
    optionals;
};

# Note: Users should define the `ASPELL_CONF' environment variable to
# `dict-dir $HOME/.nix-profile/lib/aspell/' so that they can access
# dictionaries installed in their profile.
#
# We can't use `$out/etc/aspell.conf' for that purpose since Aspell
# doesn't expand environment variables such as `$HOME'.

stdenv.mkDerivation rec {
  name = "aspell-0.60.6.1";

  src = fetchurl {
    url = "mirror://gnu/aspell/${name}.tar.gz";
    sha256 = "1qgn5psfyhbrnap275xjfrzppf5a83fb67gpql0kfqv37al869gm";
  };

  patches = optionals stdenv.cc.isClang [
    ./aspell-0.60.6.1-clang.patch
  ];

  postPatch = ''
    # fix for automake 1.13+, gentoo bug #467602
    sed -e 's/AM_CONFIG_HEADER/AC_CONFIG_HEADERS/g' -i configure.ac
  '';

  configureFlags = [
    "--enable-curses"
    "--enable-wide-curses"
    "--enable-regex"
    "--enable-compile-in-filters"
    "--enable-filter-version-control"
    "--enable-pspell-compatibility"
    "--disable-incremented-soname"
    "--enable-nls"
    "--enable-rpath"
  ];

  preConfigure = ''
    configureFlagsArray+=(
      "--enable-pkglibdir=$out/lib/aspell"
      "--enable-pkgdatadir=$out/lib/aspell"
    )
  '';

  nativeBuildInputs = [
    autoreconfHook
    gettext
    perl
    pkgconfig
  ];

  buildInputs = [
    ncurses
  ];

  doCheck = true;
  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "Spell checker for many languages";
    homepage = http://aspell.net/;
    license = licenses.lgpl2Plus;
    maintainers = [ ];
    platforms = platforms.all;
  };
}
