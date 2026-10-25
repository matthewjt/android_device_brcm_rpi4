#!/vendor/bin/sh

#
# Copyright (C) 2019-2023 KonstaKANG <konstakang@gmail.com>
#
# SPDX-License-Identifier: CC-BY-NC-SA-4.0
#

enable_property()
{
  sed -i "s/^#$1$/$1/" $2
}

enable_property_startswith()
{
  sed -i "s/^#$1/$1/" $2
}

disable_property()
{
  sed -i "s/^$1$/#$1/" $2
}

disable_property_startswith()
{
  sed -i "s/^$1/#$1/" $2
}

switch_property()
{
  sed -i "s/^$1=$2/$1=$3/" $4
}

mount_rw()
{
  echo "Mounting $1 writable..."
  mount -o rw,remount $1
}

mount_ro()
{
  echo "Mounting $1 read only..."
  mount -o ro,remount $1
}

check_root()
{
  if [ $(id -u) != 0 ]; then
    echo "Must be root to run script!"
    exit 1
  fi
}

finish()
{
  echo "Done, reboot device!"
  exit 0
}
