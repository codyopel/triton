{ callPackage, ... } @ args:

callPackage ./generic.nix (args // rec {
  version = "${branch}.16";
  branch = "2.2";
  sha256 = "123rjx1z1d9qpmh2kcivzsgcsksza38rgshc4nrmsgyj1pkclgbv";
})
