# Nix configs for Nix on WSL and NixOS

## Steps on WSL

### Install Nix
```
# Install of Nix package manager
curl -L https://nixos.org/nix/install | sh
# Adding the unstable package as well
nix-env -f '<nixpkgs>' -iA nixUnstable
```
### Enable flakes feature

Add to `~/.config/nix/nix.conf`
```
experimental-features = nix-command flakes
```

### Link the right config
```
ln -snf home-wsl.nix home.nix
```

### Create HM config and activate it
```
nix build .#homeManagerConfigurations.linux.activationPackage && ./result/activate
```

## Steps on NixOS

### Enable flakes feature

1. Add to `configuration.nix`

```Nix
{ pkgs, ... }: {
  nix = {
    package = pkgs.nixUnstable;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
   };
}
  ```
2. Rebuild Nix

### Link the right config
```
ln -snf home-nixos.nix home.nix
```

### Enter the devshell und activate the configuration
```
nix develop
up
```
