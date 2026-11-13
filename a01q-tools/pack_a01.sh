#!/bin/bash
set -e
cd ~
python3 $HOME/mkbootimg/mkbootimg.py --header_version 2 \
  --kernel ~/out_a01/arch/arm64/boot/Image.gz \
  --ramdisk ~/unpacked/ramdisk --dtb ${DTB:-$HOME/unpacked/dtb} \
  --base 0x80000000 --kernel_offset 0x8000 --ramdisk_offset 0x2000000 \
  --second_offset 0x0 --tags_offset 0x1e00000 --dtb_offset 0x1f00000 \
  --pagesize 2048 --os_version 12.0.0 --os_patch_level 2023-08 --board SRPSI03D005 \
  --cmdline "console=ttyMSM0,115200,n8 androidboot.console=ttyMSM0 androidboot.hardware=qcom user_debug=30 msm_rtb.filter=0x237 ehci-hcd.park=3 androidboot.bootdevice=7824900.sdhci lpm_levels.sleep_disabled=1 earlycon=msm_hsl_uart,0x78B0000 vmalloc=300M androidboot.usbconfigfs=true loop.max_part=7 printk.devkmsg=off ignore_loglevel" \
  -o ~/boot.img
S=$(stat -c %s ~/boot.img); echo "boot.img = $S bytes"
[ "$S" -gt 10000000 ] || { echo "ERROR: boot.img demasiado chico"; exit 1; }
grep -qa SEANDROIDENFORCE ~/boot_stock.img && echo -n SEANDROIDENFORCE >> ~/boot.img && echo "trailer Samsung añadido"
rm -f ~/boot_test.tar && tar -H ustar -cvf ~/boot_test.tar boot.img
ls -la ~/boot_test.tar
