{ config, pkgs, ... }:

{
  # Groupes nécessaires pour le fonctionnement du pilote
  users.users.cleyh = {
    extraGroups = [ "i2c" "input" "uinput" ];
  };

  # Activation et configuration du NumberPad pour X11 / i3

  hardware.asus-numberpad-driver = {
    enable = true;
    layout = "ux433fa";
    wayland = false;
  };

}
