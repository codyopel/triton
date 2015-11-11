{ stdenv, fetchurl
, gettext
, perl
, pkgconfig
, python

, attr
#, fam
, libiconv
, libintlOrEmpty
, zlib
, libffi
, pcre
, libelf

, check ? false
}:

with {
  inherit (stdenv.lib)
    enFlag;
};

let
  # Some packages don't get "Cflags" from pkgconfig correctly
  # and then fail to build when directly including like <glib/...>.
  # This is intended to be run in postInstall of any package
  # which has $out/include/ containing just some disjunct directories.
  flattenInclude = ''
    for dir in "$out"/include/* ; do
      cp -r "$dir"/* "$out/include/"
      rm -r "$dir"
      ln -s . "$dir"
    done
    ln -sr -t "$out/include/" "$out"/lib/*/include/* 2>/dev/null || true
  '';
in

assert stdenv.cc.isGNU;

stdenv.mkDerivation rec {
  name = "glib-${version}";
  versionMajor = "2.46";
  versionMinor = "2";
  version = "${versionMajor}.${versionMinor}";

  src = fetchurl {
    url = "mirror://gnome/sources/glib/${versionMajor}/${name}.tar.xz";
    sha256 = "1nrkswmqcmn16fs79q7iy72f89n3yxncqqwil30ijrq36wp74cah";
  };

  setupHook = ./setup-hook.sh;

  configureFlags = [
    "--enable-shared"
    # Static is necessary for qemu-nix to support static userspace translators
    "--enable-static"
    "--disable-selinux"
    # use fam for file system monitoring
    "--disable-fam"
    "--enable-xattr"
    (enFlag "libelf" (libelf != null) null)
    "--disable-gtk-doc"
    "--disable-gtk-doc-html"
    "--disable-gtk-doc-pdf"
    "--disable-man"
    "--disable-dtrace"
    "--disable-systemtap"
    "--disable-coverage"
    "--enable-Bsymbolic"
    "--enable-compile-warnings"
    "--with-threads=posix"
    # TODO: cite issue external pcre
    "--with-pcre=internal"
  ];

  nativeBuildInputs = [
    gettext
    perl
    pkgconfig
    python
  ];

  buildInputs = [
    attr
    #fam
    libelf
    libiconv
    libffi
    zlib
  ] ++ libintlOrEmpty;

  postInstall = "rm -rvf $out/share/gtk-doc";

  # TODO: fix or disable failing tests
  doCheck = false;
  dontDisableStatic = true;
  enableParallelBuilding = true;
  DETERMINISTIC_BUILD = 1;

  passthru = {
    gioModuleDir = "lib/gio/modules";
    inherit flattenInclude;
  };

  meta = with stdenv.lib; {
    description = "C library of programming buildings blocks";
    homepage = http://www.gtk.org/;
    license = licenses.lgpl2Plus;
    maintainers = with maintainers; [ ];
    platforms = platforms.linux;
  };
}
