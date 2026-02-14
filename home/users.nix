{ pkgs, ... }:

{
  users.users.listder = {
    isNormalUser = true;
    description = "listder";
    extraGroups = [
      "wheel"
      "networkmanager"
      "podman"
    ];
    openssh.authorizedKeys.keys = [
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDJYQjUG/QYQRZIn9lGSh1iwvJcBwNZZuiKG84ls5J2WWpypkSbXsEUV84ZqJSELbCpD7LtvTFeatluQjI1x2LNOEknsT+tmeoW0QOZCKUrZ2t4vkwnOQTVXtg2SBxm0JypsgTxHQel0/R9RPkZs9jEAfrIBNkwZ9mbj2CYwGMG8R6gjCKDmEzNiUFq46ioddDWel1LVTHc2isXZ3N225LMKRoydHMpo5t3idEhBNoBkK+pB+BFUkqpInC39u4QFgImJxmoW/aRzjR8PKb1t9nGlC525k7+IQHjcHhRx5KvSmEQwfMjqqOksSIqfPMYjZKlluhQfrpnyL6MvQDpYXxx listder@listder"
    ];
  };
}
