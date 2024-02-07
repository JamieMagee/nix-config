# Home Manager on Windows Subsystem for Linux (WSL)

This is a guide for setting up home-manager on WSL.
It assumes you have already installed WSL and have a basic understanding of how it works.
It _should_ be agnostic to which Linux distribution you are using.

```sh
# Install nix
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install

# Clone this repository
git clone https://github.com/jamiemagee/nix-config.git

# Open a nix shell
cd nix-config
nix-shell

# Make sure your user and host are set correctly and defined in flake.nix
# Then run
home-manager --flake . switch
```

References:
- [Zero to Nix install guide][zero-to-nix]
- [Home Manager standalone installation][home-manager]

[zero-to-nix]: https://zero-to-nix.com/start/install
[home-manager]: https://nix-community.github.io/home-manager/index.xhtml#sec-install-standalone