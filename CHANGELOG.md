# Changelog

All notable changes to this project will be documented in this file.

## [25.12.0] - 2026-07-10

### Major Rewrite & Platform Upgrade
- **Upstream Migration**: Upgraded the firmware build base from the legacy iStoreOS (based on older OpenWrt 21.02/22.03 branches) to **ImmortalWrt 25.12** stable branch. This brings access to the latest Linux 6.x kernel, GCC 13+ compiler toolchain, and modernized package repositories.
- **Dual Platform Support**: Expanded support to compile for two platforms in parallel:
  - **NanoPi R1S-H5** (Allwinner H5, 64-bit Cortex-A53, `sunxi/cortexa53`)
  - **NanoPi R1S-H3** (Allwinner H3, 32-bit Cortex-A7, `sunxi/cortexa7` - slim configuration without heavy Go-based proxy software due to hardware and compilation constraints)
- **Version Isolation**: Structured target configurations into `/configs/25.12/` directory to separate device-specific configs, facilitating smooth future upstream upgrades.

### CI/CD Pipeline & Workflow Enhancements
- **Parallel Matrix Build**: Configured GitHub Actions to build both R1S-H5 and R1S-H3 configurations simultaneously using build matrices.
- **Build Caching**: Implemented `actions/cache` for the package download directory (`dl/`) and build toolchain directory (`staging_dir/`) to significantly accelerate subsequent compilation runs.
- **Static Verification Assertions**: Introduced a new cloud verification job that runs immediately after compilation:
  - Extracts the generated `sysupgrade.img.gz` image.
  - Dynamically calculates the offset of the Rootfs partition.
  - Loop-mounts the Rootfs partition in the Runner.
  - Asserts existence of:
    - First-boot smart resize script at `/etc/uci-defaults/99-smart-resize`.
    - Integrated wireless drivers (checks for `kmod-rtl8189es` kernel module dependencies).
    - WAN/LAN ethernet port mapping inside `/etc/config/network`.
  - Terminates the workflow with an error if any assertion fails, preventing faulty releases.

### Storage & Expansion Strategy
- **Small-Size Firmware Distribution**: Configured Rootfs partition size to a default small size (256MB/512MB) during compilation, reducing `.img.gz` output size for quick downloading.
- **First-Boot Smart Resize**: Added a custom `99-smart-resize` script in `/etc/uci-defaults/` executed on first boot:
  - **Cards ≤ 2.2GB**: Expands the Rootfs partition to occupy 100% of the TF card.
  - **Cards > 2.2GB**: Restricts Rootfs partition to 2GB, leaving remaining capacity unallocated. This allows users to create partitions using `luci-app-diskman` for Docker, Samba, or download directories, preventing system hangs due to a full Rootfs partition.
  - **Self-Cleaning & Reboot**: The script deletes itself upon successful completion and reboots the device to apply changes.

### Hardware & Wireless Driver Support
- **Onboard Wi-Fi Integration**: Integrated RTL8189ES and RTL8723BU SDIO wireless drivers compatible with the Linux 6.x kernel using community-maintained drivers (from `sbwml/openwrt-wireless-drivers` feed).
- **VLAN & Port Mapping**: Structured network initialization to correctly map `eth0` and `eth1` interfaces to WAN/LAN roles on first boot, eliminating reversed interface issues.

### Software Stack & Pre-installed Services
- **科学上网 (Proxy Services)**: Pre-installed `luci-app-passwall` along with modern `Xray` and `sing-box` cores (H5 only).
- **UI & Custom Theme**: Set the modern, responsive `luci-theme-argon` and its config panel `luci-app-argon-config` as the default theme.
- **Disk Management**: Pre-installed `luci-app-diskman` for easy partitioning and formatting of unallocated TF card space.
- **Utility Tools**: Added `luci-app-ddns` (dynamic DNS), `luci-app-upnp` (UPnP port mapping), and `luci-app-wol` (Wake-on-LAN).
