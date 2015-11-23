{ callPackage, ... } @ args:

callPackage ./generic.nix (args // rec {
  version = "${branch}.2";
  branch = "2.8";
  sha256 = "1ci1mnippa34yfa5imnbi5xfwpdzfivs8yzirb04yxxdyx3wc3l3";
})
