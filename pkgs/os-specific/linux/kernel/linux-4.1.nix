{ stdenv, fetchurl, perl, buildLinux, ... } @ args:

import ./generic.nix (args // rec {
  version = "4.1.11";
  # Remember to update grsecurity!
  extraMeta.branch = "4.1";

  src = fetchurl {
    url = "http://cdn.kernel.org/pub/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "0xip3xj5aga4sij3rrcxv3h7b8qk47iy3x25vak66yjbdai9zbj1";
  };

  features.iwlwifi = true;
  features.efiBootStub = true;
  features.needsCifsUtils = true;
  features.canDisableNetfilterConntrackHelpers = true;
  features.netfilterRPFilter = true;
} // (args.argsOverride or {}))
