{ config, lib, pkgs, ... }:

let
  inherit (lib) mkEnableOption mkOption mkIf types;
  cfg = config.my.cli.tmux;
in
{
  options.my.cli.tmux = {
    enable = mkEnableOption "Enable tmux";
    settings = {
      status = {
        enable = mkOption {
          type = types.bool;
          default = true;
          description = "Whether to enable the status bar";
        };
        position = mkOption {
          type = types.enum [ "top" "bottom" ];
          default = "bottom";
          description = "Where to place the status bar";
        };
      };
    };
  };

  config = mkIf cfg.enable {
    programs.tmux = {
      enable = true;
      baseIndex = 1;
      historyLimit = 50000;
      disableConfirmationPrompt = true;
      escapeTime = 1;
      keyMode = "vi";
      mouse = true;
      newSession = true;
      aggressiveResize = true;
      prefix = "C-Space";
      terminal = "screen-256color";
      plugins = with pkgs; [
        {
          plugin = tmuxPlugins.resurrect;
          extraConfig = ''
            set -g @resurrect-dir '${config.xdg.configHome}/tmux/resurrect'
            set -g @resurrect-strategy-vim "session"
            set -g @resurrect-strategy-nvim "session"
            set -g @resurrect-capture-pane-contents "on"
          '';
        }
        {
          plugin = tmuxPlugins.continuum;
          extraConfig = "set -g @continuum-restore 'on'";
        }
        {
          plugin = pkgs.my.tokyo-night-tmux;
          extraConfig = ''
            set -g @tokyo-night-tmux_window_id_style none
          '';
        }
        tmuxPlugins.vim-tmux-navigator
        tmuxPlugins.sensible
        tmuxPlugins.tmux-fzf
        # TODO: Replace with this when merged:
        # https://github.com/NixOS/nixpkgs/pull/296174
        pkgs.my.tmux-window-name
      ];
      extraConfig = ''
        set -ga terminal-overrides ",*256col*:Tc"

        bind r source-file ${config.xdg.configHome}/tmux/tmux.conf

        bind -T copy-mode-vi v send-keys -X begin-selection
        bind -T copy-mode-vi y send-keys -X copy-pipe-and-cancel "wl-copy"

        # Select pane
        bind -r ^ last-window
        bind -r k select-pane -U
        bind -r j select-pane -D
        bind -r h select-pane -L
        bind -r l select-pane -R

        # Split window
        bind | split-window -h
        bind - split-window -v
        unbind '"'
        unbind %

        # Toggle between current and previous window
        set -g renumber-windows on
        bind c new-window -c "#{pane_current_path}"
        bind Space last-window
        bind C-p previous-window
        bind C-n next-window

        bind T display-popup -E "tt"
        set-option -g detach-on-destroy off

        set -as terminal-features ",xterm-256color:RGB"

        # Allow applications like Neovim to detect focus events
        set -g focus-events on

        set -g allow-passthrough on

        set -g status-keys emacs
        set -g display-time 4000
        set -g status-interval 5

        # Disable status bar
        set -g status ${if cfg.settings.status.enable then "on" else "off"}

        # Move the status bar to the top
        set-option -g status-position ${cfg.settings.status.position}
      '';
    };

    systemd.user.services.tmux = {
      Unit = {
        Description = "tmux default session (detached)";
        Documentation = "man:tmux(1)";
      };
      Service = {
        Type = "forking";
        Envronment = "DISPLAY=:0";
        ExecStart = "${pkgs.tmux}/bin/tmux new-session -d";
        ExecStop = "${pkgs.tmux}/bin/tmux kill-server";
        RestartSec = 2;
      };
      Install.WantedBy = [ "default.target" ];
    };
  };
}
