# incusui-nix
Incus UI for Nix.

## What is this?
Incus is available on nixos, but the Web UI is not. We can use the files here to build the Web UI.

## How to use it

1. Place the contents of the incus-ui folder on this repository somewhere. We'll use /etc/nixos/incus-ui for an example.
2. In your configuration.nix file, add something the following at the top where you have your definitions.
```
let
incus-ui = (import /etc/nixos/incus-ui { inherit pkgs; });
```

For example, the beginning of my configuration.nix might look like this:
```
# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, modulesPath, ... }:

let
  incus-ui = (import /etc/nixos/incus-ui { inherit pkgs; });
  unstable = import <nixpkgs-unstable> { config = { allowUnfree = true; }; };
in
{
  imports =
    [
...
```
3. In your configuration.nix file, you need to add an environment variable to the incus systemd service to enable the UI. Do so like this:
```
 systemd.services = {
    incus = {
      serviceConfig = {
        Environment = "INCUS_UI=${incus-ui}/opt/incus/ui";
      };
    };
  };
```
4. Add incus-ui to your environment.systemPackages like the below example.
```
  # Environment Settings
  environment.systemPackages = with pkgs; [
    vim
    git
    incus-ui
  ];
``` 
5. If you enabled accessing incus over the network when you ran incus admin init, after rebuilding your system, the UI should work. Navigate to https://{YOUR-IP}:8443 to get to it.
