{ stdenv, fetchurl, zlib }:

/* Cargo binary snapshot */

let snapshotDate = "2015-06-17";
in

with ((import ./common.nix) { inherit stdenv; version = "snapshot-${snapshotDate}"; });

let snapshotHash = if stdenv.system == "i686-linux"
      then "g2h9l35123r72hqdwayd9h79kspfb4y9"
      else if stdenv.system == "x86_64-linux"
      then "fnx2rf1j8zvrplcc7xzf89czn0hf3397"
      else throw "no snapshot for platform ${stdenv.system}";
    snapshotName = "cargo-nightly-${platform}.tar.gz";
in

stdenv.mkDerivation {
  inherit name version meta;

  src = fetchurl {
    url = "https://static-rust-lang-org.s3.amazonaws.com/cargo-dist/${snapshotDate}/${snapshotName}";
    sha1 = snapshotHash;
  };

  dontStrip = true;

  installPhase = ''
    mkdir -p "$out"
    ./install.sh "--prefix=$out"

    ${postInstall}
  '' + (if stdenv.isLinux then ''
    patchelf --interpreter "${stdenv.glibc}/lib/${stdenv.cc.dynamicLinker}" \
             --set-rpath "${stdenv.cc.cc}/lib/:${stdenv.cc.cc}/lib64/:${zlib}/lib" \
             "$out/bin/cargo"
  '' else "");
}
