{
  lib,
  config,
  pkgs,
  ...
}:
let
  userName = "william";
  userDescription = "William Tran";
in
{
  options = {
  };
  config = {
    users.users.${userName} = {
      isNormalUser = true;
      description = userDescription;
      shell = pkgs.zsh;
      extraGroups = [
        "wheel"
        "docker"
        "docker-instructure"
        "wireshark"
        "libvirtd"
        "kvm"
      ];
    };
    programs.zsh.enable = true;
  };
}
