#!/bin/bash

# What CI Script
# Copyright (C) 2019 Raphiel Rollerscaperers (raphielscape)
# Copyright (C) 2019 Rama Bondan Prakoso (rama982) 
# Copyright (C) 2019-2023 Keternal (KeternalGithub@163.com)
# Copyright (C) 2020 StarLight5234
# Copyright (C) 2021-22 GhostMaster69-dev
# SPDX-License-Identifier: GPL-3.0-or-later

# Build Enviroment

# Build Time Setup
export DATE=`date`
export BUILD_START=$(date "+%s")

# Customize Build Host and User
export KBUILD_BUILD_USER="Kernel Nsan"
export KBUILD_BUILD_HOST="NO more"

# Defind Kernel Binary
export IMG=${PWD}/out/arch/arm64/boot/Image.gz-dtb

# Clone Toolchain
git clone -b release/15.x --depth=1 https://gitlab.com/GhostMaster69-dev/cosmic-clang.git ${PWD}/Toolchain
export PATH="${PWD}/Toolchain/bin:$PATH"

# Customize Compiler Name
export KBUILD_COMPILER_STRING=$(${PWD}/Toolchain/bin/clang -v 2>&1 | grep ' version ' | sed 's/([^)]*)[[:space:]]//' | sed 's/([^)]*)//')

# Compile Kernel
make O=out LLVM=1 LLVM_IAS=1 defconfig -j$(grep -c '^processor' /proc/cpuinfo) || finerr
make O=out LLVM=1 LLVM_IAS=1 -j$(grep -c '^processor' /proc/cpuinfo) || finerr

# Calc Build Used Time
export BUILD_END=$(date "+%s")
export DIFF=$(($BUILD_END - $BUILD_START))
export BUILD_POINT=$(git log --pretty=format:'%h' -1)

# Packing
cp $IMG Flasher/
cd Flasher/
zip -r9 -9 "NSAN-$ZIP_VERSION-$BUILD_TYPE-$BUILD_POINT.zip" .
md5sum Nsan-$ZIP_VERSION-$BUILD_TYPE-$BUILD_POINT.zip >> "md5sum_$(git log --pretty=format:'%h' -1).md5sum"

# Push
push_package
push_md5sum
cd ..
# push_dtb
fin
