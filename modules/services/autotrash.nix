{ config, lib, pkgs, ... }:

let
  inherit (lib) mkEnableOption mkOption mkIf types optionalString;
  cfg = config.my.services.autotrash;
in
{
  options.my.services.autotrash = {
    enable = mkEnableOption "Whether to enable automatically emptying the trash";
    frequency = mkOption {
      type = types.str;
      default = "daily";
      description = ''
        How often or when to empty the trash.

        The format is described in
          {manpage}`systemd.time(7)`.
      '';
    };
    settings = {
      days = mkOption {
        type = types.nullOr types.int;
        default = 30;
        description = "Delete files older than this many days";
      };

      delete = mkOption {
        type = types.nullOr types.int;
        default = null;
        description = "Delete at least this many megabytes";
      };

      limit = mkOption {
        type = types.nullOr types.int;
        default = null;
        description = "Make sure no more than this many megabytes of space are used by the trash";
      };

      maxFree = mkOption {
        type = types.nullOr types.int;
        default = null;
        description = "Only run if less than this many megabytes of free space is left";
      };

      minFree = mkOption {
        type = types.nullOr types.int;
        default = 100000;
        description = "Make sure at least this many megabytes are available";
      };

      deleteFirst = mkOption {
        type = types.nullOr types.str;
        default = null;
        description = "Push files matching this regular expression to the top of the deletion queue";
      };

      trashMounts = mkOption {
        type = types.bool;
        default = false;
        description = "Process all user trash directories instead of just the one in the home directory";
      };
    };
  };

  config = mkIf cfg.enable {
    assertions = [
      {
        assertion = cfg.settings.days != null || cfg.settings.delete != null
          || cfg.settings.minFree != null;
        message =
          "At least one of settings.days, settings.delete, or settings.minFree must be set";
      }
      {
        assertion = cfg.settings.limit != null
          -> (cfg.settings.minFree == null && cfg.settings.delete == null);
        message =
          "Combining settings.limit with settings.minFree or settings.delete is unsupported";
      }
    ];

    systemd.user.services.autotrash = {
      Unit = {
        Description = "Empty trash";
        Documentation = "https://github.com/bneijt/autotrash";
      };

      Service = {
        Type = "oneshot";
        ExecStart = "${pkgs.my.autotrash}/bin/autotrash"
          + optionalString (cfg.settings.days != null)
          " --days=${toString cfg.settings.days}"

          + optionalString (cfg.settings.delete != null)
          " --delete=${toString cfg.settings.delete}"

          + optionalString (cfg.settings.limit != null)
          " --trash_limit=${toString cfg.settings.limit}"

          + optionalString (cfg.settings.maxFree != null)
          " --max-free=${toString cfg.settings.maxFree}"

          + optionalString (cfg.settings.minFree != null)
          " --min-free=${toString cfg.settings.minFree}"

          + optionalString (cfg.settings.deleteFirst != null)
          " --delete-first=${cfg.settings.deleteFirst}"

          + optionalString cfg.settings.trashMounts " --trash-mounts";
      };
    };

    systemd.user.timers.autotrash = {
      Unit.Description = "Empty trash";
      Timer = {
        OnCalendar = cfg.frequency;
        Persistent = true;
      };
      Install.WantedBy = [ "timers.target" ];
    };
  };
}
