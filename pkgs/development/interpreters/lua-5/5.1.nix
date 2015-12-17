{ stdenv, fetchurl, fetchpatch, readline }:

let
  dsoPatch = fetchurl {
    url = "https://projects.archlinux.org/svntogit/packages.git/plain/trunk/lua-arch.patch?h=packages/lua51";
    sha256 = "11fcyb4q55p4p7kdb8yp85xlw8imy14kzamp2khvcyxss4vw8ipw";
    name = "lua-arch.patch";
  };
in
stdenv.mkDerivation rec {
  name = "lua-5.1.5";
  luaversion = "5.1";

  src = fetchurl {
    url = "http://www.lua.org/ftp/${name}.tar.gz";
    sha256 = "2640fc56a795f29d28ef15e13c34a47e223960b0240e8cb0a82d9b0738695333";
  };

  buildInputs = [ readline ];

  patches = [
    (fetchpatch {
      name = "CVE-2014-5461.patch";
      url = "http://anonscm.debian.org/cgit/pkg-lua/lua5.1.git/plain/debian/patches/"
        + "0004-Fix-stack-overflow-in-vararg-functions.patch?id=b75a2014db2ad65683521f7bb295bfa37b48b389";
      sha256 = "05i5vh53d9i6dy11ibg9i9qpwz5hdm0s8bkx1d9cfcvy80cm4c7f";
    })
    dsoPatch
  ];

  configurePhase = ''
    makeFlagsArray=( INSTALL_TOP=$out INSTALL_MAN=$out/share/man/man1 PLAT=linux CFLAGS="-DLUA_USE_LINUX -O2 -fPIC" LDFLAGS="-fPIC" )
    installFlagsArray=( TO_BIN="lua luac" TO_LIB="liblua.a liblua.so liblua.so.5.1 liblua.so.5.1.5" INSTALL_DATA='cp -d' )
  '';

  postInstall = ''
    mkdir -p "$out/share/doc/lua" "$out/lib/pkgconfig"
    sed <"etc/lua.pc" >"$out/lib/pkgconfig/lua.pc" -e "s|^prefix=.*|prefix=$out|"
    mv "doc/"*.{gif,png,css,html} "$out/share/doc/lua/"
    rmdir $out/{share,lib}/lua/5.1 $out/{share,lib}/lua
  '';

  meta = {
    description = "Powerful, fast, lightweight, embeddable scripting language";
    homepage = "http://www.lua.org";
    license = stdenv.lib.licenses.mit;
    maintainers = [ stdenv.lib.maintainers.simons ];
    hydraPlatforms = stdenv.lib.platforms.linux;
  };
}
