{ lib, ... }:

{
  users.groups.slm = {};
  users.users.tyllm.extraGroups = lib.mkAfter [ "slm" ];

  services.udev.extraRules = ''
    SUBSYSTEM=="block", ENV{DEVTYPE}=="disk", ATTRS{idVendor}=="0661", ATTRS{idProduct}=="5101", GROUP="slm", MODE="0660", SYMLINK+="hamamatsu-slm"
    SUBSYSTEM=="scsi_generic", ATTRS{idVendor}=="0661", ATTRS{idProduct}=="5101", GROUP="slm", MODE="0660", SYMLINK+="hamamatsu-slm-sg"
  '';
}
