{ pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];

  networking.hostName = "nixos";

  # Définition de l'utilisateur
  users.users.cleyh = {
    isNormalUser = true;
    description = "Cleyhan";
    extraGroups = [ "networkmanager" "wheel" "libvirtd" "video" ];
  };

  # Déblocage des paquets non libres
  nixpkgs.config.allowUnfree = true;

  # Ne jamais modifier sans migration manuelle
  system.stateVersion = "26.05";
}
