{ pkgs, ... }:

{
  # X11 & i3
  services.xserver = {
    enable = true;
    windowManager.i3.enable = true;
    xkb = {
      layout = "us";
      variant = "";
    };
  };

  # Bluetooth
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };

  # Gestion de l'écran de veille et fermeture capot
  #services.logind = {
  #  lidSwitch = "suspend";
  #  lidSwitchExternalPower = "suspend";
  #};

  services.logind.settings.Login = {
    HandleLidSwitch = "suspend";
    HandleLidSwitchExternalPower = "suspend";
  };

  programs.xss-lock = {
    enable = true;
    lockerCommand = "${pkgs.i3lock-fancy}/bin/i3lock-fancy";
  };

  fonts.packages = [
    pkgs.nerd-fonts.jetbrains-mono
    # ou pkgs.nerd-fonts.fira-code
  ];

  # Applications bureau & utilitaires X11
  environment.systemPackages = with pkgs; [
    alacritty
    arandr
    autorandr
    blueman
    brightnessctl
    clipmenu
    discord
    dmenu
    filezilla
    firefox
    flameshot
    i3lock
    i3lock-fancy
    i3status
    pamixer
    rofi
    xclip
    #xorg.xrandr
    xrandr
    xsel
    xss-lock
  ];
}
