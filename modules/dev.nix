{ lib, pkgs, ... }:

let
  # Make SDL and SDL2 usable with -fsanitize=address:
  # libasan interposes dlopen(), breaking sdl2-compat's RUNPATH lookup of libSDL3.so.0.
  # Patching sdl2-compat to dlopen() the full Nix store path fixes runtime loading under ASan.
  # Applied locally via pkgs.extend to avoid rebuilding all SDL2 consumers on the system.
  sdlCompatDlopenOverlay = final: prev:
    let
      dlopenFullPath = { package, file, soname, libdir }:
        package.overrideAttrs (old: {
          postPatch = (old.postPatch or "") + ''
            substituteInPlace ${file} \
              --replace-fail '"${soname}"' '"${libdir}/${soname}"'
          '';
        });

      sdl3 = (prev.lib.findFirst (drv: (drv.pname or null) == "sdl3")
        (throw "sdl2-compat does not have sdl3 in its buildInputs anymore")
        prev.sdl2-compat.buildInputs).lib;
    in
    {
      sdl2-compat = dlopenFullPath {
        package = prev.sdl2-compat;
        file = "src/sdl2_compat.c";
        soname = "libSDL3.so.0";
        libdir = "${sdl3}/lib";
      };

      SDL_compat = dlopenFullPath {
        package = prev.SDL_compat;
        file = "src/SDL12_compat.c";
        soname = "libSDL2-2.0.so.0";
        libdir = "${prev.lib.getLib final.sdl2-compat}/lib";
      };
    };

  sdlPkgs = pkgs.extend sdlCompatDlopenOverlay;
in
{
  documentation.dev.enable = true;

  # Expose headers, libraries, and pkg-config files globally in /run/current-system/sw
  environment.pathsToLink = [ "/include" "/lib" "/share/pkgconfig" ];
  environment.extraOutputsToInstall = [ "out" "lib" "bin" "dev" ];

  environment.variables = {
    NIX_CFLAGS_COMPILE_x86_64_unknown_linux_gnu = "-isystem /run/current-system/sw/include";
    NIX_CFLAGS_LINK_x86_64_unknown_linux_gnu = "-L/run/current-system/sw/lib -Wl,-rpath,/run/current-system/sw/lib";

    CMAKE_INCLUDE_PATH = "/run/current-system/sw/include";
    CMAKE_LIBRARY_PATH = "/run/current-system/sw/lib";

    PKG_CONFIG_PATH = lib.concatStringsSep ":" [
      "/run/current-system/sw/lib/pkgconfig"
      "/run/current-system/sw/share/pkgconfig"
    ];
  };

  # Ensure new terminals spawned from i3 pick up updated environment.variables without logging out
  programs.zsh.shellInit = ''
    source /etc/set-environment
  '';

  environment.systemPackages = (with pkgs; [
    # C / C++ / Build
    clang-tools
    criterion
    gcc
    gnumake
    pkg-config

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
    bat    
  ]) ++ (with sdlPkgs; [
    # SDL2 (patched for -fsanitize=address)
    SDL2
    SDL2_image
    SDL2_mixer
    SDL2_net
    SDL2_ttf
  ]);
}
