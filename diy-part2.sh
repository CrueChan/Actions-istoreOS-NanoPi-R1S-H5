#!/bin/bash
#
# iStoreOS NanoPi R1S H5 构建脚本 - Part 2
# 基于 P3TERX/Actions-OpenWrt 修改，专用于 iStoreOS 固件构建
#
# 执行时机: Download package 前
# 主要功能: 添加自定义 feeds 源，配置 iStoreOS 特定组件
#
# 原项目: https://github.com/P3TERX/Actions-OpenWrt  
# 原作者: Copyright (c) 2019-2024 P3TERX <https://p3terx.com>
# 适配修改: CrueChan - 专门针对 iStoreOS 和 NanoPi R1S H5
#
# Licensed under the MIT License.
#

# Modify default IP
#sed -i 's/192.168.1.1/192.168.50.5/g' package/base-files/files/bin/config_generate

# Modify default theme
sed -i 's/luci-theme-bootstrap/luci-theme-argon/g' feeds/luci/collections/luci/Makefile

# Modify hostname
sed -i 's/OpenWrt/R1S-H5/g' package/base-files/files/bin/config_generate
