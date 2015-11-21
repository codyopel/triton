{ stdenv, fetchurl
, makeWrapper

, acl
, expat
, xz
}:

with {
  inherit (stdenv.lib)
    optional;
};

stdenv.mkDerivation rec {
  name = "gettext-0.19.6";

  src = fetchurl {
    url = "mirror://gnu/gettext/${name}.tar.gz";
    sha256 = "0pb9vp4ifymvdmc31ks3xxcnfqgzj8shll39czmk8c1splclqjzd";
  };

  configureFlags = [
    "--disable-csharp"
    "--with-libexpat-prefix=${expat}"
    "--with-xz"
  ];

  # On cross building, gettext supposes that the wchar.h from libc
  # does not fulfill gettext needs, so it tries to work with its
  # own wchar.h file, which does not cope well with the system's
  # wchar.h and stddef.h (gcc-4.3 - glibc-2.9)
  preConfigure = ''
    if test -n "$crossConfig" ; then
      echo 'gl_cv_func_wcwidth_works=yes' > cachefile
      configureFlagsArray+=("--cache-file=$(pwd)/cachefile")
    fi
  '';

  nativeBuildInputs = [
    makeWrapper
  ];

  buildInputs = [
    acl
    expat
    xz
  ];

  preFixup = ''
    for p in $out/bin/* ; do
      wrapProgram $p --prefix LD_LIBRARY_PATH : ${expat}/lib
    done
  '';

  outputs = [ "out" "doc" ];

  crossAttrs = {
    buildInputs = optional (stdenv ? ccCross && stdenv.ccCross.libc ? libiconv)
      stdenv.ccCross.libc.libiconv.crossDrv;
    # Gettext fails to guess the cross compiler
    configureFlags = "CXX=${stdenv.cross.config}-g++";
  };

  doCheck = false;
  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "Well integrated set of translation tools and documentation";
    homepage = http://www.gnu.org/software/gettext/;
    maintainers = [ ];
    platforms = [
      "i686-linux"
      "x86_64-linux"
    ];
  };
}
