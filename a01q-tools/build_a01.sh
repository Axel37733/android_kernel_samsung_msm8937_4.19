#!/bin/bash
set -eo pipefail
export PATH=$PATH:$HOME/toolchains/proton-clang/bin
export ARCH=arm64
K=~/kernel_redmi7A/android_kernel_xiaomi_msm8937; O=~/out_a01
M="O=$O CC=$HOME/toolchains/proton-clang/bin/clang HOSTCC=gcc HOSTCXX=g++ LD=ld.lld AR=llvm-ar NM=llvm-nm OBJCOPY=llvm-objcopy OBJDUMP=llvm-objdump STRIP=llvm-strip CROSS_COMPILE=aarch64-linux-gnu- CROSS_COMPILE_ARM32=arm-linux-gnueabi-"
cd $K
[ -f $O/.config ] || make $M vendor/msm8937_defconfig vendor/xiaomi/msm8937/common.config vendor/xiaomi/sdm439/mi439.config
$K/scripts/kconfig/merge_config.sh -m -O $O $O/.config $HOME/a01.config >/dev/null
make $M olddefconfig </dev/null
make $M -j$(nproc) Image.gz 2>&1 | tee ~/build.log | tail -30
ls -la $O/arch/arm64/boot/Image.gz
