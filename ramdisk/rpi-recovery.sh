#!/system/bin/sh
# Request TWRP recovery on the next boot.
#
# The Pi firmware picks the initramfs from the GPIO21 pin state at power-on
# (see boot/config.txt: gpio=21=ip,pu + the [gpio21=0] initramfs branch).
# GPIO21 is physical pin 40; GND is pin 39. Driving the pad low here, then
# rebooting, is the software equivalent of shorting pin 40 to pin 39.
#
# Triggered by init: on property:sys.rpi.recovery=1 (the property the
# "Raspberry Pi settings" app writes), or manually:
#   adb shell setprop sys.rpi.recovery 1

GPIO=/sys/class/gpio/gpio21

if [ ! -d "$GPIO" ]; then
    echo 21 > /sys/class/gpio/export 2>/dev/null
fi

if [ -d "$GPIO" ]; then
    echo out > "$GPIO/direction" 2>/dev/null
    echo 0 > "$GPIO/value" 2>/dev/null
    echo "rpi-recovery: GPIO21 driven low, rebooting to recovery"
else
    # GPIO sysfs unavailable: reboot anyway and tell the operator the fallback.
    echo "rpi-recovery: GPIO21 not available via sysfs; use the pin40->GND jumper"
fi

sync
reboot
