{ callPackage, ... } @ args:

callPackage ./generic.nix (args // rec {
  version = "${branch}.4";
  branch = "2.6";
  sha256 = "0pascmqlambfz293sgd4ff1maqnkmf4pvinni8wnqhjrngk4jkqq";
})
