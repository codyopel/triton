{ stdenv, fetchurl, readline, compat ? false }:

let
  dsoPatch = fetchurl {
    url = "https://projects.archlinux.org/svntogit/packages.git/plain/trunk/liblua.so.patch?h=packages/lua52";
    sha256 = "1by1dy4ql61f5c6njq9ibf9kaqm3y633g2q8j54iyjr4cxvqwqz9";
    name = "lua-arch.patch";
  };
in
stdenv.mkDerivation rec {
  name = "lua-${version}";
  luaversion = "5.2";
  version = "${luaversion}.3";

  src = fetchurl {
    url = "http://www.lua.org/ftp/${name}.tar.gz";
    sha1 = "926b7907bc8d274e063d42804666b40a3f3c124c";
  };

  patches = [
    dsoPatch
  ];

  nativeBuildInputs = [ readline ];

  configurePhase = ''
    makeFlagsArray=( INSTALL_TOP=$out INSTALL_MAN=$out/share/man/man1 PLAT=linux CFLAGS="-DLUA_USE_LINUX -O2 -fPIC${if compat then " -DLUA_COMPAT_ALL" else ""}" LDFLAGS="-fPIC" V=${luaversion} R=${version} )
    installFlagsArray=( TO_BIN="lua luac" TO_LIB="liblua.a liblua.so liblua.so.${luaversion} liblua.so.${version}" INSTALL_DATA='cp -d' )
  '';

  postInstall = ''
    mkdir -p "$out/share/doc/lua" "$out/lib/pkgconfig"
    mv "doc/"*.{gif,png,css,html} "$out/share/doc/lua/"
    rmdir $out/{share,lib}/lua/${luaversion} $out/{share,lib}/lua
    mkdir -p "$out/lib/pkgconfig"
    cat >"$out/lib/pkgconfig/lua.pc" <<EOF
    prefix=$out
    libdir=$out/lib
    includedir=$out/include
    INSTALL_BIN=$out/bin
    INSTALL_INC=$out/include
    INSTALL_LIB=$out/lib
    INSTALL_MAN=$out/man/man1

    Name: Lua
    Description: An Extensible Extension Language
    Version: ${version}
    Requires:
    Libs: -L$out/lib -llua -lm
    Cflags: -I$out/include
    EOF
  '';

  crossAttrs = let
    isMingw = stdenv.cross.libc == "msvcrt";
    isDarwin = stdenv.cross.libc == "libSystem";
  in {
    configurePhase = ''
      makeFlagsArray=(
        INSTALL_TOP=$out
        INSTALL_MAN=$out/share/man/man1
        CC=${stdenv.cross.config}-gcc
        STRIP=:
        RANLIB=${stdenv.cross.config}-ranlib
        V=${luaversion}
        R=${version}
        ${if isMingw then "mingw" else ""}
      )
    '' + stdenv.lib.optionalString isMingw ''
      installFlagsArray=(
        TO_BIN="lua.exe luac.exe"
        TO_LIB="liblua.a lua52.dll"
        INSTALL_DATA="cp -d"
      )
    '';
  };

  meta = {
    description = "Powerful, fast, lightweight, embeddable scripting language";
    homepage = "http://www.lua.org";
    license = stdenv.lib.licenses.mit;
    maintainers = [ ];
    hydraPlatforms = stdenv.lib.platforms.linux;
  };
}
