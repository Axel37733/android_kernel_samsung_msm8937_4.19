#!/bin/bash
export PATH=$PATH:$HOME/toolchains/proton-clang/bin
export ARCH=arm64
eval "$(grep -E '^(K=|M=)' ~/build_a01.sh)"
cd $K
grep -E "BUILD_ARM64|CONFIG_ARCH_SDM439" $O/.config
make -k $M DTC_FLAGS=-@ vendor/qcom/sdm439.dtb vendor/qcom/sdm439-qrd.dtb 2>&1 | tail -15
ls -la $O/arch/arm64/boot/dts/vendor/qcom/sdm439*.dtb
