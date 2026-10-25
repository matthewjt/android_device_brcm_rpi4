#!/vendor/bin/sh

#
# Copyright (C) 2019-2023 KonstaKANG <konstakang@gmail.com>
#
# SPDX-License-Identifier: CC-BY-NC-SA-4.0
#

# Ported from KonstaKANG's /vendor/bin (our copy installs to /system/bin, so the
# source path is adjusted). Mechanism: swap ramdisk.img <-> ramdisk-recovery.img
# on the boot FAT and toggle the vc4-kms-v3d dtoverlay for TWRP; the reboot is
# issued by the caller (settings app / shell).
#
# MOUNT DESIGN (differs from Kang, on purpose): Android's rootfs is READ-ONLY,
# so a /boot directory cannot exist and init's mount_all silently skips any fstab
# entry whose mount point is missing (Kang's own rom: 'mount -o rw,remount /boot'
# fails, script no-ops silently - his TV recovery path is broken by this too).
# We mount the FAT ON DEMAND at /dev/bootmnt (tmpfs, writable) and unmount after.
source /system/bin/rpi-utils.sh

recovery_ramdisk()
{
  if [ -f $BOOT/ramdisk-recovery.img ] && [ ! -f $BOOT/ramdisk-boot.img ]; then
    echo "Changing to recovery ramdisk..."
    mv $BOOT/ramdisk.img $BOOT/ramdisk-boot.img
    mv $BOOT/ramdisk-recovery.img $BOOT/ramdisk.img
    disable_property dtoverlay=vc4-kms-v3d $BOOT/config.txt
  fi
}

boot_ramdisk()
{
  if [ -f $BOOT/ramdisk-boot.img ] && [ ! -f $BOOT/ramdisk-recovery.img ]; then
    echo "Changing to boot ramdisk..."
    mv $BOOT/ramdisk.img $BOOT/ramdisk-recovery.img
    mv $BOOT/ramdisk-boot.img $BOOT/ramdisk.img
    enable_property dtoverlay=vc4-kms-v3d $BOOT/config.txt
  fi
}

if [ -z $1 ] || [ $1 == "recovery" ]; then
  check_root
  mount_boot
  recovery_ramdisk
  unmount_boot
  finish
elif [ $1 == "boot" ]; then
  check_root
  mount_boot
  boot_ramdisk
  unmount_boot
  finish
else
  echo "Usage: $0 [recovery|boot]"
fi
