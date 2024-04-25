{ config, pkgs, ... }: {
  my = {
    cli = {
      bat.enable = true;
      extraPackages = with pkgs; [
        ripgrep
        sad
        fd
        jq
        wget
        tree
        unzip
        trash-cli
        my.t
        my.tt
      ];
      fish.enable = true;
      fzf.enable = true;
      gh.enable = true;
      git = {
        userName = "Stephen Reynolds";
        userEmail = "mail@stephenreynolds.dev";
        editor = "nvim";
        aliases.enable = true;
        signing = {
          key = "${config.home.homeDirectory}/.ssh/id_ed25519";
          gpg.format = "ssh";
          signByDefault = true;
        };
      };
      lazygit.enable = true;
      lf = {
        enable = true;
        enableIcons = true;
      };
      lsd.enable = true;
      neovim.enable = true;
      nix-index = {
        enable = true;
        comma.enable = true;
      };
      starship.enable = true;
      tmux.enable = true;
      zoxide.enable = true;
    };
    services = {
      autotrash.enable = true;
      keyring.enable = true;
    };
    wsl.enable = true;
  };
}
