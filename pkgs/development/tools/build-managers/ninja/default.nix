{ stdenv, fetchurl
, asciidoc
, python
, re2c
}:

stdenv.mkDerivation rec {
  name = "ninja-${version}";
  version = "1.6.0";

  src = fetchurl {
    url = "https://github.com/martine/ninja/archive/v${version}.tar.gz";
    name = "${name}.tar.gz";
    sha256 = "1ryd1686bd31gfdjxnqm6k1ybnjmjz8v97px7lmdkr4g0vxqhgml";
  };

  postPatch = ''
    patchShebangs ./configure.py
  '';

  configureFlags = [
    "--bootstrap"
    "--verbose"
  ];

  nativeBuildInputs = [
    asciidoc
    python
    re2c
  ];

  buildPhase = ''
    ./configure.py $configureFlags
    asciidoc doc/manual.asciidoc
  '';

  installPhase = ''
    install -vD 'ninja' "$out/bin/ninja"
    install -vD 'doc/manual.asciidoc' "$out/share/doc/ninja/manual.asciidoc"
    install -vD 'doc/manual.html' "$out/share/doc/ninja/doc/manual.html"
  '';

  meta = with stdenv.lib; {
    description = "Small build system with a focus on speed";
    homepage = http://martine.github.io/ninja/;
    license = licenses.asl20;
    maintainers = with maintainers; [ codyopel ];
    platforms = platforms.unix;
  };
}
