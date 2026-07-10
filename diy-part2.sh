#!/bin/bash
#
# iStoreOS NanoPi R1S H5 build script - Part 2
# Based on P3TERX/Actions-OpenWrt, specially used for iStoreOS firmware building
#
# Execution time: before downloading package
# Main function: add custom feeds source, configure iStoreOS specific components
#
# Original project: https://github.com/P3TERX/Actions-OpenWrt
# Original author: Copyright (c) 2019-2024 P3TERX <https://p3terx.com>
# Adaptation modification: CrueChan - specially for iStoreOS and NanoPi R1S H5
#
# Licensed under the MIT License.
#

# Modify default IP
#sed -i 's/192.168.1.1/192.168.50.5/g' package/base-files/files/bin/config_generate

# Modify default theme
sed -i 's/luci-theme-bootstrap/luci-theme-argon/g' feeds/luci/collections/luci/Makefile

# Dynamically set hostname depending on platform configuration
if grep -q 'CONFIG_TARGET_sunxi_cortexa53_DEVICE_friendlyarm_nanopi-r1s-h5=y' .config; then
    sed -i 's/OpenWrt/R1S-H5/g' package/base-files/files/bin/config_generate
    sed -i 's/iStoreOS/R1S-H5/g' package/base-files/files/bin/config_generate
    sed -i 's/ImmortalWrt/R1S-H5/g' package/base-files/files/bin/config_generate
elif grep -q 'CONFIG_TARGET_sunxi_cortexa7_DEVICE_friendlyarm_nanopi-r1s-h3=y' .config; then
    sed -i 's/OpenWrt/R1S-H3/g' package/base-files/files/bin/config_generate
    sed -i 's/iStoreOS/R1S-H3/g' package/base-files/files/bin/config_generate
    sed -i 's/ImmortalWrt/R1S-H3/g' package/base-files/files/bin/config_generate
else
    # Fallback default
    sed -i 's/OpenWrt/R1S-H5/g' package/base-files/files/bin/config_generate
    sed -i 's/iStoreOS/R1S-H5/g' package/base-files/files/bin/config_generate
    sed -i 's/ImmortalWrt/R1S-H5/g' package/base-files/files/bin/config_generate
fi

