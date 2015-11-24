{ stdenv, fetchurl }:

let
  pname = "icu4c";
  version = "55.1";
in
stdenv.mkDerivation {
  name = "icu4c-" + version;

  src = fetchurl {
    url = "http://download.icu-project.org/files/icu4c/${version}/icu4c-"
      + (stdenv.lib.replaceChars ["."] ["_"] version) + "-src.tgz";
    sha256 = "0ys5f5spizg45qlaa31j2lhgry0jka2gfha527n4ndfxxz5j4sz1";
  };

  postUnpack = ''
    sourceRoot=$sourceRoot/source
  '';

  configureFlags = [
    "--disable-debug"
    "--enable-release"
    #"--enable-strict"
    "--enable-draft"
    "--enable-rpath"
    "--enable-extras"
    "--enable-icuio"
    "--disable-layout"
    "--disable-layoutex"
    "--enable-tools"
    "--enable-tests"
    "--disable-samples"
  ];

  preConfigure = ''
    patchShebangs configure
  '';

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "Unicode and globalization support library";
    homepage = http://site.icu-project.org/;
    maintainers = with maintainers; [ ];
    platforms = platforms.all;
  };
}
