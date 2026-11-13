#!/bin/bash
set -e
DTB=${DTB:-$HOME/out_a01/arch/arm64/boot/dts/vendor/qcom/sdm439.dtb}
python3 $HOME/mkbootimg/mkbootimg.py --header_version 2 --os_version 15.0.0 --os_patch_level 2024-11 \
  --kernel $HOME/out_a01/arch/arm64/boot/Image.gz --ramdisk $HOME/unp_los/ramdisk --dtb "$DTB" \
  --pagesize 0x800 --base 0x0 --kernel_offset 0x80008000 --ramdisk_offset 0x82000000 \
  --second_offset 0x0 --tags_offset 0x81e00000 --dtb_offset 0x181f00000 --board msm8937 \
  --cmdline 'console=null androidboot.console=ttyMSM0 androidboot.hardware=qcom user_debug=30 msm_rtb.filter=0x237 ehci-hcd.park=3 androidboot.bootdevice=7824900.sdhci lpm_levels.sleep_disabled=1 androidboot.usbconfigfs=true loop.max_part=7 printk.devkmsg=on androidboot.selinux=permissive ignore_loglevel' \
  -o $HOME/boot.img
S=$(stat -c %s $HOME/boot.img); echo "boot.img = $S bytes"
[ "$S" -gt 10000000 ] || { echo "ERROR: boot.img chico"; exit 1; }
grep -qa SEANDROIDENFORCE $HOME/boot_los.img && echo -n SEANDROIDENFORCE >> $HOME/boot.img && echo "trailer Samsung añadido"
cp $HOME/boot.img /mnt/c/adb/boot_419.img && echo "copiado a C:\adb\boot_419.img"
