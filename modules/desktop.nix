{ pkgs, ... }:

{

  boot.kernelParams = [
    "psmouse.synaptics_intertouch=1" # Force l'utilisation exclusive du bus I2C natif
    "i915.enable_psr=0"              # Désactive le Panel Self Refresh (corrige la latence après 1-2s d'inactivité sur ZenBook UX325EA)
  ];

  boot.blacklistedKernelModules = [ "psmouse" ];

  # Règles udev :
  # - Interdire la mise en veille auto des bus I2C, PCI, i2c_designware, idma64 (DMA LPSS), HID et input
  # - Ignorer le nœud parasite "ASUE140A:00 04F3:3134 Mouse" qui entre en conflit avec le Touchpad
  services.udev.extraRules = ''
    ACTION=="add|change", SUBSYSTEM=="i2c", TEST=="power/control", ATTR{power/control}="on"
    ACTION=="add|change", SUBSYSTEM=="pci", TEST=="power/control", ATTR{power/control}="on"
    ACTION=="add|change", SUBSYSTEM=="platform", DRIVER=="i2c_designware", TEST=="power/control", ATTR{power/control}="on"
    ACTION=="add|change", SUBSYSTEM=="platform", DRIVER=="idma64", TEST=="power/control", ATTR{power/control}="on"
    ACTION=="add|change", SUBSYSTEM=="hid", TEST=="power/control", ATTR{power/control}="on"
    ACTION=="add|change", SUBSYSTEM=="input", TEST=="power/control", ATTR{power/control}="on"
    ACTION=="add|change", SUBSYSTEM=="input", ATTRS{name}=="ASUE140A:00 04F3:3134 Mouse", ENV{LIBINPUT_IGNORE_DEVICE}="1"
  '';

  # Quirk libinput pour stabiliser la détection de pression/contact sur le pavé Elan ASUE140A (04F3:3134)
  environment.etc."libinput/local-overrides.quirks".text = ''
    [ASUS ZenBook UX325EA Touchpad]
    MatchName=*ASUE140A:00 04F3:3134 Touchpad*
    MatchUdevType=touchpad
    AttrEventCode=-BTN_RIGHT
  '';

  # Sécurité supplémentaire si le comportement du noyau évolue :
  services.tlp = {
    enable = true;
    settings = {
      USB_AUTOSUSPEND = 0;
      RUNTIME_PM_ON_AC = "on";  # Maintient le bus sous tension sur secteur
      RUNTIME_PM_ON_BAT = "on"; # Maintient le bus sous tension sur batterie
    };
  };

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

  services.libinput = {
    enable = true;
    touchpad = {
      disableWhileTyping = false;
      accelProfile = "adaptive";
      accelSpeed = "0.2";
      # Options utiles complémentaires :
      tapping = true;           # Clic par tapotement
      naturalScrolling = false; # Défilement naturel
      clickMethod = "clickfinger";
    };
  };

  programs.dconf.enable = true;
xdg.portal = {
  enable = true;
  extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  config.common.default = "*";
};

services.picom = {
  enable = true;
  vSync = true;
  backend = "glx";
};

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
    dunst
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
    libinput
  ];


}
