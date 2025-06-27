#!/bin/bash
#
# iStoreOS NanoPi R1S H5 构建脚本 - Part 1
# 基于 P3TERX/Actions-OpenWrt 修改，专用于 iStoreOS 固件构建
#
# 执行时机: feeds 更新前
# 主要功能: 添加自定义 feeds 源，配置 iStoreOS 特定组件
#
# 原项目: https://github.com/P3TERX/Actions-OpenWrt  
# 原作者: Copyright (c) 2019-2024 P3TERX <https://p3terx.com>
# 适配修改: CrueChan - 专门针对 iStoreOS 和 NanoPi R1S H5
#
# Licensed under the MIT License.
#

# Uncomment a feed source
#sed -i 's/^#\(.*helloworld\)/\1/' feeds.conf.default

# Add a feed source
#echo 'src-git helloworld https://github.com/fw876/helloworld' >>feeds.conf.default
echo 'src-git passwall https://github.com/xiaorouji/openwrt-passwall' >>feeds.conf.default
