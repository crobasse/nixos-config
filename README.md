# Configuration NixOS 

Configuration **NixOS** modulaire basée sur les **Flakes** (`nixos-unstable`).

## Structure du dépôt

```text
/etc/nixos
├── flake.nix                 # Point d'entrée Flake (inputs & assemblage des modules)
├── flake.lock                # Verrouillage des versions des dépendances
├── hosts/
│   └── laptop/
│       ├── default.nix       # Configuration de l'hôte (hostname, utilisateur, stateVersion)
│       └── hardware-configuration.nix # Configuration matérielle générée par NixOS
└── modules/
    ├── core.nix              # Système de base (systemd-boot, réseau, locales FR, GPG, outils CLI)
    ├── desktop.nix           # Environnement graphique (X11 + i3, picom, TLP, Bluetooth, correctifs touchpad ASUS)
    ├── dev.nix               # Environnement de dev (C/C++, SDL2 patché pour ASan (CRI), Python, .NET, Neovim, VS Code)
    ├── virtualization.nix    # Virtualisation & conteneurs (QEMU/KVM, Libvirt, virt-manager, Docker, Minikube)
    ├── vpn.nix               # Configuration client WireGuard (interface wg0)
    ├── zsh.nix               # Shell par défaut (Zsh, Oh My Zsh, Powerlevel10k, alias)
    └── asus-numberpad.nix    # Pilote du pavé numérique tactile ASUS (optionnel, désactivé par défaut)
```

## Détail des modules

- **[`hosts/laptop`](hosts/laptop/default.nix)** : Définit la machine `nixos`, l'utilisateur principal `cleyh` et autorise les paquets non libres (`allowUnfree`).
- **[`modules/core.nix`](modules/core.nix)** : Bootloader EFI (`systemd-boot`), `NetworkManager`, fuseau horaire `Europe/Paris`, agent GPG et utilitaires système essentiels (`git`, `vim`, `htop`, `curl`...).
- **[`modules/desktop.nix`](modules/desktop.nix)** : Serveur d'affichage **X11** avec le gestionnaire de fenêtres **i3**, compositeur **Picom** (GLX + VSync), gestion d'énergie **TLP**, et règles `udev`/`libinput`/noyau spécifiques pour stabiliser le pavé tactile et l'affichage de l'ASUS ZenBook UX325EA.
- **[`modules/dev.nix`](modules/dev.nix)** : Outils de compilation C/C++ (`gcc`, `clang-tools`, `gnumake`, `pkg-config`, `criterion`), bibliothèques `SDL2` (avec un overlay local corrigeant `dlopen` sous AddressSanitizer), Python, .NET SDK, et exposition globale des en-têtes/bibliothèques dans `/run/current-system/sw`.
- **[`modules/virtualization.nix`](modules/virtualization.nix)** : Pile de virtualisation complète avec `libvirtd` / `qemu` (TPM virtuel + redirection USB SPICE), `virt-manager`, ainsi que `docker` et `minikube`.
- **[`modules/vpn.nix`](modules/vpn.nix)** : Tunnel VPN WireGuard (`wg0`) utilisant les clés stockées dans `/etc/wireguard/`.
- **[`modules/zsh.nix`](modules/zsh.nix)** : Configuration de **Zsh** avec autocomplétion, coloration syntaxique, **Oh My Zsh** et le thème **Powerlevel10k**.

## Commandes utiles

### Appliquer la configuration

```bash
sudo nixos-rebuild switch --flake /etc/nixos#nixos
```

### Mettre à jour les dépendances du Flake (`flake.lock`)

```bash
nix flake update
```
