{stdenv, fetchurl, m4, zlib, bzip2, bison, flex, gettext}:

# TODO: Look at the hardcoded paths to kernel, modules etc.
stdenv.mkDerivation rec {
  name = "elfutils-${version}";
  version = "0.163";

  src = fetchurl {
    urls = [
      "http://fedorahosted.org/releases/e/l/elfutils/${version}/${name}.tar.bz2"
      "mirror://gentoo/${name}.tar.bz2"
      ];
    sha256 = "7c774f1eef329309f3b05e730bdac50013155d437518a2ec0e24871d312f2e23";
  };

  patches = [
    (fetchurl {
      url = "http://fedorahosted.org/releases/e/l/elfutils/${version}/elfutils-portability-${version}.patch";
      sha256 = "e4e82315dad2efaa4e4476503e7537e01b7c1b1f98a96de4ca1c7fa85f4f1045";
    }) ];

  # We need bzip2 in NativeInputs because otherwise we can't unpack the src,
  # as the host-bzip2 will be in the path.
  nativeBuildInputs = [m4 bison flex gettext bzip2];
  buildInputs = [zlib bzip2];

  configureFlags = "--disable-werror";

  crossAttrs = {

    /* Having bzip2 will harm, because anything using elfutils
       as buildInput cross-building, will not be able to run 'bzip2' */
    propagatedBuildInputs = [ zlib.crossDrv ];

    # This program does not cross-build fine. So I only cross-build some parts
    # I need for the linux perf tool.
    # On the awful cross-building:
    # http://comments.gmane.org/gmane.comp.sysutils.elfutils.devel/2005
    #
    # I wrote this testing for the nanonote.
    buildPhase = ''
      pushd libebl
      make
      popd
      pushd libelf
      make
      popd
      pushd libdwfl
      make
      popd
      pushd libdw
      make
      popd
    '';

    installPhase = ''
      pushd libelf
      make install
      popd
      pushd libdwfl
      make install
      popd
      pushd libdw
      make install
      popd
      cp version.h $out/include
    '';
  };

  dontAddDisableDepTrack = true;

  meta = {
    homepage = https://fedorahosted.org/elfutils/;
  };
}
