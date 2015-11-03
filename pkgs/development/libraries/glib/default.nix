{ stdenv, fetchurl
, gettext
, perl
, pkgconfig
, python

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
    enFlag
    wtFlag;
};

# TODO:
# * Add gio-module-fam
#     Problem: cyclic dependency on gamin
#     Possible solution: build as a standalone module, set env. vars
# * Make it build without python
#     Problem: an example (test?) program needs it.
#     Possible solution: disable compilation of this example somehow
#     Reminder: add 'sed -e 's@python2\.[0-9]@python@' -i
#       $out/bin/gtester-report' to postInstall if this is solved
# * Use --enable-installed-tests for GNOME-related packages,
#     and use them as a separately installed tests run by Hydra
#     (they should test an already installed package)
#     https://wiki.gnome.org/GnomeGoals/InstalledTests
# * Support org.freedesktop.Application, including D-Bus activation from desktop files

let
  # Some packages don't get "Cflags" from pkgconfig correctly
  # and then fail to build when directly including like <glib/...>.
  # This is intended to be run in postInstall of any package
  # which has $out/include/ containing just some disjunct directories.
  flattenInclude = ''
    for dir in "$out"/include/*; do
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
  versionMinor = "1";
  version = "${versionMajor}.${versionMinor}";

  src = fetchurl {
    url = "mirror://gnome/sources/glib/${versionMajor}/${name}.tar.xz";
    sha256 = "1yzxr1ip3l0m9ydk5nq32piq70c9f17p5f0jyvlsghzbaawh67ss";
  };

  setupHook = ./setup-hook.sh;

  configureFlags = [
    "--disable-gc-friendly"
    "--enable-mem-pools"
    "--enable-rebuilds"
    "--disable-installed-tests"
    "--disable-always-build-tests"
    "--enable-large-file"
    # TODO: selinux support
    #(enFlag "selinux" (selinux != null) null)
    "--disable-selinux"
    # use fam for file system monitoring
    "--enable-fam"
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
    #znodelete
    #compile-warnings
    (wtFlag "python" (python != null) "${python.interpreter}")
    "--with-threads=posix"
    (wtFlag "pcre" (pcre != null) "system")
  ];

  nativeBuildInputs = [
    gettext
    perl
    pkgconfig
    python
  ];

  buildInputs = [
    libelf
    libffi
    libiconv
    pcre
    zlib
  ] ++ libintlOrEmpty;

  postInstall = ''
    rm -rvf $out/share/gtk-doc
  '';

  # TODO: fix or disable failing tests
  doCheck = false;
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
