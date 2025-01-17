# gvfs backends

{ config, lib, pkgs, ... }:

with lib;

{

  ###### interface

  options = {

    services.gnome3.gvfs = {

      enable = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Whether to enable gvfs backends, userspace virtual filesystem used
          by GNOME components via D-Bus.
        '';
      };

    };

  };


  ###### implementation

  config = mkIf config.services.gnome3.gvfs.enable {

    environment.systemPackages = [ pkgs.gvfs ];

    services.dbus.packages = [ pkgs.gvfs ];

    services.udev.packages = [ pkgs.libmtp ];

  };

}
