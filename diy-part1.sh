#!/bin/bash
#
# iStoreOS NanoPi R1S H5 build script - Part 1
# Based on P3TERX/Actions-OpenWrt, specially used for iStoreOS firmware build
#
# Execution time: before feeds update
# Main function: add custom feeds source, configure iStoreOS specific components
#
# Original project: https://github.com/P3TERX/Actions-OpenWrt
# Original author: Copyright (c) 2019-2024 P3TERX <https://p3terx.com>
# Adaptation modification: CrueChan - specially for iStoreOS and NanoPi R1S H5
#
# Licensed under the MIT License.
#

# Uncomment a feed source
#sed -i 's/^#\(.*helloworld\)/\1/' feeds.conf.default

# Add a feed source
#echo 'src-git helloworld https://github.com/fw876/helloworld' >>feeds.conf.default
echo 'src-git passwall https://github.com/xiaorouji/openwrt-passwall' >>feeds.conf.default
