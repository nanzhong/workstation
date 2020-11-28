{ pkgs, ... }: {
  nixpkgs.overlays = [
    (import (builtins.fetchTarball {
      url = https://github.com/nix-community/emacs-overlay/archive/master.tar.gz;
    }))
  ];

  environment.systemPackages = with pkgs; [
    direnv
    dive
    doctl
    go
    gopls
    kubectl
    kubernetes-helm
    lua
    mariadb-client
    python
    python3
    ruby
    shellcheck
    starship
    syncthing
    z-lua
  ];

  services.emacs = {
    enable = true;
    package = pkgs.emacsGit-nox;
  };
  services.syncthing = {
    enable = true;
    openDefaultPorts = true;
  };
}
