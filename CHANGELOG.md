# Changelog

All notable changes to this project will be documented in this file.

## [23.05.7-IB] - 2026-07-15

### Version Rollback & Wi-Fi Stability Optimization
- **Rollback to 23.05.7 Stable (Linux Kernel 5.15)**: Reverted firmware core from 24.10 (Linux kernel 6.6) to 23.05.7 (Linux kernel 5.15) to resolve driver/hardware incompatibilities on the Allwinner H5 platform. This provides a 100% stable networking environment, resolving WAN/LAN interface drops and boot-loop hangs.
- **Onboard Wi-Fi Default-Disabled**: Configured the onboard `rtl8189es` wireless module to remain disabled (`disabled='1'`) by default on first boot to guarantee safe startup and prevent overheating/kernel panics.
- **Dynamic Configuration Defaults**: Integrated a first-boot uci-defaults script to pre-save safe 2.4GHz parameters (SSID as `FriendlyWrt-[MAC_Suffix]`, `password`, `HT20`, `15dBm` txpower, `AU` country code). Allows users to safely enable the AP with one click in the Web UI.

### Custom Features Ingestion
- **iStoreOS Dashboard & Store**: Pre-installed `luci-app-quickstart` (flat dashboard/network wizard) and `luci-app-store` (iStore App Store) for graphic plugin management.
- **VUM Advanced Uninstall**: Integrated the VUM "高级卸载" (`luci-app-uninstall`) package into the firmware build to purge configurations cleanly.
- **USTC High-Speed Mirror**: Configured a startup script to automatically switch OPKG repositories to the University of Science and Technology of China (USTC) mirror on first boot.
- **Multi-Language Expansion**: Pre-installed language files for Traditional Chinese, Japanese, Korean, German, Spanish, French, Italian, and Russian.
- **Personalized Hostname & Branding**: Changed hostname to `R1S-H5` and dynamically injected the repository owner's signature and precise compile Beijing date/time directly into the system description and notes.

## [24.10.6-IB] - 2026-07-13

### Downgrade & Version Pinning
- **Pin to 24.10.6 Stable**: Pinned the firmware base to **ImmortalWrt 24.10.6** (Linux kernel 6.1) due to USB/LAN controller driver regressions in the 25.12.x kernel on the Allwinner H5 SoC. This restores full functionality to the USB-to-Ethernet LAN port.
- **Directory Structure Migration**: Renamed `/configs/25.12/` to `/configs/24.10/` to align with the active build target.

## [25.12.0-IB] - 2026-07-11

### Image Builder Transition & Delivery
- **Image Builder Packaging Strategy**: Migrated the entire build pipeline from resource-heavy **Source Code Compilation** (frequent GCC OOMs and timeouts) to lightweight **Official Image Builder Packaging**. Condenses CI/CD duration from 2.5 hours down to **4 minutes 38 seconds** with 100% success rate.
- **H3 Architecture Pruning**: Excluded H3 from the build matrix since upstream ImmortalWrt 25.12 officially does not compile or distribute firmware/profiles for NanoPi R1S-H3. Focused resources strictly on delivering the robust H5 target.
- **Dependency Ingestion**: Automatically pulls `luci-theme-argon`, `luci-app-passwall`, `xray-core`, and `sing-box` from the official repository feeds, guaranteeing up-to-date proxy capabilities for the H5 platform.
- **Parted Offset Parsing Fix**: Solved the parting parser defect where start sector string contained trailing 's', preventing partition offsets from evaluating correctly.

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
