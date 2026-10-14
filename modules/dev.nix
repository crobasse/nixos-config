{ pkgs, ... }:

{
  documentation.dev.enable = true;

  environment.systemPackages = with pkgs; [
    # C / C++ / Build
    clang-tools
    criterion
    gcc
    gnumake
    pkg-config
    SDL2.dev

    # Manpages
    man-pages
    man-pages-posix

    # Python & Dotnet
    python3
    python3Packages.pip
    dotnet-sdk

    # Éditeurs & Schémas
    neovim
    vscode
    graphviz
    kicad
  ];
}
