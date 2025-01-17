{ config, lib, pkgs, ... }:

with lib;

let
  quassel = pkgs.quasselDaemon_qt5;
  cfg = config.services.quassel;
  user = if cfg.user != null then cfg.user else "quassel";
in

{

  ###### interface

  options = {

    services.quassel = {

      enable = mkOption {
        default = false;
        description = ''
          Whether to run the Quassel IRC client daemon.
        '';
      };

      interface = mkOption {
        default = "127.0.0.1";
        description = ''
          The interface the Quassel daemon will be listening to.  If `127.0.0.1',
          only clients on the local host can connect to it; if `0.0.0.0', clients
          can access it from any network interface.
        '';
      };

      portNumber = mkOption {
        default = 4242;
        description = ''
          The port number the Quassel daemon will be listening to.
        '';
      };

      dataDir = mkOption {
        default = ''/home/${user}/.config/quassel-irc.org'';
        description = ''
          The directory holding configuration files, the SQlite database and the SSL Cert.
        '';
      };

      user = mkOption {
        default = null;
        description = ''
          The existing user the Quassel daemon should run as. If left empty, a default "quassel" user will be created.
        '';
      };

    };

  };


  ###### implementation

  config = mkIf cfg.enable {

    users.extraUsers = mkIf (cfg.user == null) [
      { name = "quassel";
        description = "Quassel IRC client daemon";
        group = "quassel";
        uid = config.ids.uids.quassel;
      }];

    users.extraGroups = mkIf (cfg.user == null) [
      { name = "quassel";
        gid = config.ids.gids.quassel;
      }];

    systemd.services.quassel =
      { description = "Quassel IRC client daemon";

        wantedBy = [ "multi-user.target" ];
        after = [ "network.target" ]
          ++ optional config.services.mysql.enable "mysql.service"
          ++ optional config.services.postgresql.enable "postgresql.service";

        preStart = ''
          mkdir -p ${cfg.dataDir}
          chown ${user} ${cfg.dataDir}
        '';

        serviceConfig =
        {
          ExecStart = "${quassel}/bin/quasselcore --listen=${cfg.interface} --port=${toString cfg.portNumber} --configdir=${cfg.dataDir}";
          User = user;
          PermissionsStartOnly = true;
        };
      };

  };

}
