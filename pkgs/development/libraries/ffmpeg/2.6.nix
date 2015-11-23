{ callPackage, ... } @ args:

callPackage ./generic.nix (args // rec {
  version = "${branch}.5";
  branch = "2.6";
  sha256 = "1qmkc4xji61j3jm85zvwvzg8jhvyg9fak938yhsvjwckigwk1b35";
})
