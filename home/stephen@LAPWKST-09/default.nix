{ config, pkgs, ... }:
{
  my = {
    cli = {
      bat.enable = true;
      btop.enable = true;
      extraPackages = with pkgs; [
        ansible
        fd
        jq
        ripgrep
        sad
        trash-cli
        tree
        unzip
        wget
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
      keyring.enable = true;
    };
    wsl.enable = true;
  };
}
