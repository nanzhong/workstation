{ config, pkgs, ... }: {
  imports = [
    /etc/nixos/hardware-configuration.nix
    /etc/nixos/networking.nix # generated at runtime by nixos-infect

    <home-manager/nixos>

    ./common.nix
  ];

  networking.hostName = "wrk";

  networking.localCommands = ''
    ip=$(ip addr show eth0 | grep -oP '(?<=inet\s)\d+(\.\d+){3}')
    subnet=$(ip route | grep -Po '^\d+(.\d+){3}/\d+(?= dev eth0)')
    gateway=$(ip route | grep -Po '(?<=default via )[.\d]+')
    ip rule add from $ip table 128
    ip route add table 128 to $subnet dev eth0
    ip route add table 128 default via $gateway
  '';

  users.users = {
    nzhong = {
      isNormalUser = true;
      home = "/home/nzhong";
      description = "Nan Zhong";
      extraGroups = [ "wheel" "docker" ];
      shell = pkgs.fish;
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPRVyHqcSWD8nhiniAfDlV3UIua0/mkINp1XbmcwGHVc nan@ipad" 
      ];
    };
  };

  home-manager.users.nzhong = import ../home.nix;
}
