{ tmuxPlugins, fetchFromGitHub }:
tmuxPlugins.mkTmuxPlugin rec {
  pluginName = "tokyo-night-tmux";
  version = "6fe88ac87d353be211c7427997f58164c3a7cfa1";
  rtpFilePath = "tokyo-night.tmux";
  src = fetchFromGitHub {
    owner = "janoamaral";
    repo = "tokyo-night-tmux";
    rev = version;
    sha256 = "sha256-yho2irPSwdRkNNwU7HZzN5dvspjDHWl75NlpS3uwz8M=";
  };
}
