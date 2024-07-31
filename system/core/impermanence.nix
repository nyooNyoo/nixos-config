{
  inputs,
  lib,
  ...
}:

{
  imports = [inputs.impermanence.nixosModule];
  fileSystems."/" = {
    device = "/dev/disk/by-label/fsroot";
    fsType = "btrfs";
    options = [ "subvol=root" ];
  };

  boot.initrd.postDeviceCommands = lib.mkAfter ''
    mkdir /btrfs_tmp
    mount /dev/disk/by-label/fsroot /btrfs_tmp
    if [[ -e /btrfs_tmp/root ]]; then
        mkdir -p /btrfs_tmp/old_roots
        timestamp=$(date --date="@$(stat -c %Y /btrfs_tmp/root)" "+%Y-%m-%-d_%H:%M:%S")
        mv /btrfs_tmp/root "/btrfs_tmp/old_roots/$timestamp"
    fi

    delete_subvolume_recursively() {
        IFS=$'\n'
        for i in $(btrfs subvolume list -o "$1" | cut -f 9- -d ' '); do
            delete_subvolume_recursively "/btrfs_tmp/$i"
        done
        btrfs subvolume delete "$1"
    }

    for i in $(find /btrfs_tmp/old_roots/ -maxdepth 1 -mtime +30); do
        delete_subvolume_recursively "$i"
    done

    btrfs subvolume create /btrfs_tmp/root
    umount /btrfs_tmp
  '';

  fileSystems."/persist" = {
    device = "/dev/disk/by-label/fsroot";
    neededForBoot = true;
    fsType = "btrfs";
    options = [ "subvol=persist" ];
  };

  fileSystems."/nix" = {
    device = "/dev/disk/by-label/fsroot";
    fsType = "btrfs";
    options = [ "subvol=nix" ];
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-label/uefi";
    fsType = "vfat";
  };

  environment.persistence."/persist" = {
    enable = true;
    hideMounts = true;
    directories = [ "/tmp" "/var/log" "/var/db/sudo" ]
    ++ lib.forEach [ "nixos" "NetworkManager" "nix" "ssh" "secureboot" ] (x: "/etc/${x}")
    ++ lib.forEach [ "bluetooth" "nixos" "pipewire" "libvirt" "fail2ban" "fprint" ] (x: "/var/lib/${x}");
    files = [ "/etc/machine-id" ];
    users.nyoo = {
      directories = [ "projects" "nixos-config" ];
    };
  };

  # prob not needed idk
  systemd.tmpfiles.rules = [
    "L /var/lib/NetworkManager/secret_key - - - - /persist/var/lib/NetworkManager/secret_key"
    "L /var/lib/NetworkManager/seen-bssids - - - - /persist/var/lib/NetworkManager/seen-bssids"
    "L /var/lib/NetworkManager/timestamps - - - - /persist/var/lib/NetworkManager/timestamps"
  ];
}
