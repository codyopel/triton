# This jobset defines the main NixOS channels (such as nixos-unstable
# and nixos-14.04). The channel is updated every time the ‘tested’ job
# succeeds, and all other jobs have finished (they may fail).

{ nixpkgs ? { outPath = ./..; revCount = 56789; shortRev = "gfedcba"; }
, stableBranch ? false
, supportedSystems ? [ "x86_64-linux" "i686-linux" ]
}:

let

  nixpkgsSrc = nixpkgs; # urgh

  pkgs = import ./.. {};

  removeMaintainers = set: if builtins.isAttrs set
    then if (set.type or "") == "derivation"
      then set // { meta = builtins.removeAttrs (set.meta or {}) [ "maintainers" ]; }
      else pkgs.lib.mapAttrs (n: v: removeMaintainers v) set
    else set;

in rec {

  nixos = removeMaintainers (import ./release.nix {
    inherit stableBranch supportedSystems;
    nixpkgs = nixpkgsSrc;
  });

  nixpkgs = builtins.removeAttrs (removeMaintainers (import ../pkgs/top-level/release.nix {
    inherit supportedSystems;
    nixpkgs = nixpkgsSrc;
  })) [ "unstable" ];

  tested = pkgs.lib.hydraJob (pkgs.releaseTools.aggregate {
    name = "nixos-${nixos.channel.version}";
    meta = {
      description = "Release-critical builds for the NixOS channel";
      maintainers = [ pkgs.lib.maintainers.eelco ];
    };
    constituents =
      let all = x: map (system: x.${system}) supportedSystems; in
      [ nixos.channel
        (all nixos.dummy)
        (all nixos.manual)

        (all nixos.iso_minimal)
        (all nixos.iso_graphical)
        (all nixos.ova)

        #(all nixos.tests.containers)
        (all nixos.tests.chromium)
        (all nixos.tests.firefox)
        (all nixos.tests.firewall)
        (all nixos.tests.gnome3)
        (all nixos.tests.installer.lvm)
        (all nixos.tests.installer.luksroot)
        (all nixos.tests.installer.separateBoot)
        (all nixos.tests.installer.separateBootFat)
        (all nixos.tests.installer.simple)
        (all nixos.tests.installer.simpleLabels)
        (all nixos.tests.installer.simpleProvided)
        (all nixos.tests.installer.swraid)
        (all nixos.tests.installer.btrfsSimple)
        (all nixos.tests.installer.btrfsSubvols)
        (all nixos.tests.installer.btrfsSubvolDefault)
        (all nixos.tests.bootBiosCdrom)
        (all nixos.tests.ipv6)
        (all nixos.tests.kde4)
        #(all nixos.tests.lightdm)
        (all nixos.tests.login)
        (all nixos.tests.misc)
        (all nixos.tests.nat.firewall)
        (all nixos.tests.nat.standalone)
        (all nixos.tests.networking.scripted.static)
        (all nixos.tests.networking.scripted.dhcpSimple)
        (all nixos.tests.networking.scripted.dhcpOneIf)
        (all nixos.tests.networking.scripted.bond)
        (all nixos.tests.networking.scripted.bridge)
        (all nixos.tests.networking.scripted.macvlan)
        (all nixos.tests.networking.scripted.sit)
        (all nixos.tests.networking.scripted.vlan)
        (all nixos.tests.nfs3)
        (all nixos.tests.openssh)
        (all nixos.tests.printing)
        (all nixos.tests.proxy)
        (all nixos.tests.simple)
        (all nixos.tests.udisks2)

        nixpkgs.tarball
        (all nixpkgs.emacs)
        (all nixpkgs.jdk)
      ];
  });

}
