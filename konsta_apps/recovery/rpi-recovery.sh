#!/vendor/bin/sh

#
# Copyright (C) 2019-2023 KonstaKANG <konstakang@gmail.com>
#
# SPDX-License-Identifier: CC-BY-NC-SA-4.0
#

# Ported from KonstaKANG's /vendor/bin (our copy installs to /system/bin, so the
# source path is adjusted). Mechanism: swap ramdisk.img <-> ramdisk-recovery.img
# on the /boot FAT (mounted rw via fstab.rpi4) and toggle the vc4-kms-v3d
# dtoverlay for TWRP; the reboot is issued by the caller (settings app / shell).
source /system/bin/rpi-utils.sh

recovery_ramdisk()
{
  if [ -f /boot/ramdisk-recovery.img ] && [ ! -f /boot/ramdisk-boot.img ]; then
    echo "Changing to recovery ramdisk..."
    mv /boot/ramdisk.img /boot/ramdisk-boot.img
    mv /boot/ramdisk-recovery.img /boot/ramdisk.img
    disable_property dtoverlay=vc4-kms-v3d /boot/config.txt
  fi
}

boot_ramdisk()
{
  if [ -f /boot/ramdisk-boot.img ] && [ ! -f /boot/ramdisk-recovery.img ]; then
    echo "Changing to boot ramdisk..."
    mv /boot/ramdisk.img /boot/ramdisk-recovery.img
    mv /boot/ramdisk-boot.img /boot/ramdisk.img
    enable_property dtoverlay=vc4-kms-v3d /boot/config.txt
  fi
}

if [ -z $1 ] || [ $1 == "recovery" ]; then
  check_root
  mount_rw /boot
  recovery_ramdisk
  mount_ro /boot
  finish
elif [ $1 == "boot" ]; then
  check_root
  mount_rw /boot
  boot_ramdisk
  mount_ro /boot
  finish
else
  echo "Usage: $0 [recovery|boot]"
fi
