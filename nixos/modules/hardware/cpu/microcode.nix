{ config, lib, pkgs, ... }:

with lib;

{

  options = {

    hardware.cpu.intel.updateMicrocode = mkOption {
      default = false;
      type = types.bool;
      description = ''
        Update the CPU microcode for Intel processors.
      '';
    };

    hardware.cpu.amd.updateMicrocode = mkOption {
      default = false;
      type = types.bool;
      description = ''
        Update the CPU microcode for AMD processors.
      '';
    };

  };

  config = mkMerge [
    (mkIf config.hardware.cpu.intel.updateMicrocode {
         boot.initrd.prepend = [ "${pkgs.microcodeIntel}/intel-ucode.img" ];
    })

    (mkIf config.hardware.cpu.amd.updateMicrocode {
        boot.initrd.prepend = [ "${pkgs.microcodeAmd}/amd-ucode.img" ];
    })
  ];

}
