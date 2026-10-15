{ pkgs, ... }:

{
  environment.systemPackages = [
    pkgs.zsh-powerlevel10k
    pkgs.colorls
  ];

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    enableAutosuggestions = true;
    syntaxHighlighting.enable = true;

    ohMyZsh = {
      enable = true;
      plugins = [ "git" "sudo" ];
      # Pas de theme ici car on charge p10k ci-dessous
    };

    shellAliases = {
      ll = "ls -l";
      rebuild = "sudo nixos-rebuild switch --flake /etc/nixos#nixos";
    };

    promptInit = ''
      source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme
      [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
    '';
  };

  # Shell par défaut
  users.users.cleyh.shell = pkgs.zsh;
}
