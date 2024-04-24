{ config, lib, ... }:

let
  inherit (lib) mkOption mkIf types optionalString;
  cfg = config.my.services.media.mpd;
in
{
  options.my.services.media.mpd = {
    enable = mkOption {
      type = types.bool;
      default = config.my.services.media.enable;
      description = "Whether to enable mpd";
    };
    musicDirectory = mkOption {
      type = types.str;
      default = "${config.xdg.userDirs.music}";
      description = "The directory where mpd will look for music";
    };
    playlistDirectory = mkOption {
      type = types.str;
      default = "${config.xdg.userDirs.music}/Playlists";
      description = "The directory where mpd will look for playlists";
    };
    extraConfig = mkOption {
      type = types.lines;
      default = "";
      description = "Extra configuration for mpd";
    };
  };

  config = mkIf cfg.enable {
    services.mpd = {
      enable = true;
      musicDirectory = "${cfg.musicDirectory}";
      playlistDirectory = "${cfg.playlistDirectory}";
      network.startWhenNeeded = true;
      extraConfig = ''
        log_level           "warning"

        # Put MPD into pause mode instead of starting playback after startup
        restore_paused      "yes"

        # Auto update the music database when files are changed in music_directory
        auto_update         "yes"
      '' + optionalString config.services.pipewire.enable ''
        audio_output {
            type    "pipewire"
            name    "PipeWire Sound Server"
        }
      '' + cfg.extraConfig;
    };
  };
}
