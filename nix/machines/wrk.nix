{ config, pkgs, ... }:
let
  keys = import ../keys.nix;
in {
  imports = [
    ./common.nix
  ];

  networking.hostName = "wrk";

  networking.localCommands = ''
    ip=$(ip addr show eth0 | grep -oP '(?<=inet\s)\d+(\.\d+){3}')
    subnet=$(ip route | grep -Po '^\d+(.\d+){3}/\d+(?= dev eth0)')
    gateway=$(ip route | grep -Po '(?<=default via )[.\d]+')
    ip rule delete from $ip table 128 || true
    ip rule add from $ip table 128 || true
    ip route add table 128 to $subnet dev eth0 || true
    ip route add table 128 default via $gateway || true
  '';

  networking.nameservers = [ "10.254.0.3" ];
  networking.search = [ "internal.digitalocean.com" "consul" ];

  users.users = {
    nzhong = {
      isNormalUser = true;
      home = "/home/nzhong";
      description = "Nan Zhong";
      extraGroups = [ "wheel" "docker" ];
      shell = pkgs.fish;
      openssh.authorizedKeys.keys = keys.sshPub;
    };
  };
}
