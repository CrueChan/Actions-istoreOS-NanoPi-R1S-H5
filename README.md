# Actions-OpenWrt-NanoPi-R1S-H5-H3

[![LICENSE](https://img.shields.io/github/license/mashape/apistatus.svg?style=flat-square&label=LICENSE)](https://github.com/CrueChan/Actions-istoreOS-NanoPi-R1S-H5/blob/main/LICENSE)
![GitHub Stars](https://img.shields.io/github/stars/CrueChan/Actions-istoreOS-NanoPi-R1S-H5.svg?style=flat-square&label=Stars&logo=github)
![GitHub Forks](https://img.shields.io/github/forks/CrueChan/Actions-istoreOS-NanoPi-R1S-H5.svg?style=flat-square&label=Forks&logo=github)

Automated GitHub Actions build workflow for **NanoPi R1S-H5** (64-bit Cortex-A53), pinned to **ImmortalWrt 23.05.7** stable release (Linux kernel 5.15) to achieve 100% stable LAN/WAN throughput and avoid Realtek SDIO Wi-Fi driver crashes in early boot.

---

## ✨ Features

- ⚡ **Lightweight Image Builder Integration**: Transitioned to the official ImmortalWrt Image Builder. Condenses compilation time from 2.5 hours down to 4 minutes while retaining extreme stability.
- 💾 **Smart Partition Resize**: Small initial firmware size for fast downloading and flashing, with an automated smart expansion system on the first boot (supports up to 2GB safe partition limit on TF cards > 2.2GB).
- 📶 **Onboard Wi-Fi Safe Mode**: Onboard SDIO wireless driver `kmod-rtl8189es` is pre-integrated but safely disabled by default on boot to prevent kernel panics. The WPA/AP authentication suite `wpad-basic-openssl` is installed, allowing plug-and-play support for stable external USB Wi-Fi dongles.
- 🛍️ **iStoreOS Interface & App Store**: Integrates the clean iStoreOS **QuickStart** dashboard, **NetworkGuide** setup wizard, and the official **iStore App Store** for easy GUI-based plugin installation.
- 🧹 **VUM Advanced Uninstall**: Pre-integrates the VUM "高级卸载" (luci-app-uninstall) plugin to cleanly purge files and residual configs when deleting packages.
- 🇨🇳 **USTC High-Speed Mirror**: Automatically switches default package feeds to the fast and reliable University of Science and Technology of China (USTC) mirror on first boot.
- 🌐 **Multi-Language Support**: Supports English, Simplified Chinese, Traditional Chinese, Japanese, Korean, German, Spanish, French, Italian, and Russian.
- 🛠️ **Static Verification Checks**: Incorporates a CI/CD assertion job that loop-mounts the compiled rootfs in the cloud to verify kernel modules, network port mapping, and partition expansion scripts before releasing.
- 📦 **Automated Release Publishing**: Publishes compiled system images directly to GitHub Releases.

---

## 💾 First-Boot Smart Resize Behavior

To optimize download sizes and protect the lifespan of your TF card, this project utilizes a custom first-boot resize script (`/etc/uci-defaults/99-smart-resize`):

1. **Initial Flashed Size**: The compiled firmware has a compact rootfs partition (256MB or 512MB).
2. **First Boot Assessment**: The script queries the physical sector count of the storage card:
   - **TF Card Capacity ≤ 2.2 GB**: The second partition (rootfs) is automatically expanded to consume **100%** of the storage card.
   - **TF Card Capacity > 2.2 GB**: The rootfs partition is expanded to exactly **2 GB**. The remaining space is left unallocated.
3. **Using Unallocated Space**: Users can use the pre-installed **Diskman** (`luci-app-diskman`) utility in the Web UI to format the remaining unallocated space (e.g., as `ext4` or `f2fs`) and mount it for Docker directories, Samba shares, or download tasks. This prevents the rootfs partition from filling up and freezing the system.
4. **Cleanup & Reboot**: Once partitions are expanded and the ext4 file system is resized via `resize2fs`, the script deletes itself and reboots the device.

---

## 📋 Pre-installed Drivers & Software

### Onboard Hardware Drivers
- `kmod-rtl8189es` - RTL8189ES SDIO Wi-Fi driver (supports both RTL8189ES and compatible RTL8189FTV/FS onboard chips).
- Custom double-port mapping (VLAN configured WAN on `eth0` / LAN on `eth1` dynamically on boot).

### Applications and Services
| Package Name | Function | Description |
| :--- | :--- | :--- |
| `luci-app-store` | iStore App Store | Graphical interface to search, install, and manage plugins with one click |
| `luci-app-quickstart` | QuickStart Dashboard | Elegant flat web dashboard and step-by-step Network Guide wizard |
| `luci-app-uninstall` | VUM Advanced Uninstall | Cleanly purges third-party plugin residuals and config files |
| `luci-app-passwall` | Proxy Client | Supports multiple protocols, running Xray/sing-box cores (H5 only) |
| `luci-theme-argon` | Modern Theme | Elegant responsive interface for desktop & mobile devices |
| `luci-app-argon-config`| Theme Configuration| Customize argon theme backgrounds, colors, and login logo |
| `luci-app-diskman` | Disk Management | Manage partitions, format, and mount unallocated TF card space |
| `luci-app-ddns` | Dynamic DNS | Automated IP sync with Cloudflare, Aliyun, DNSPod, etc. |
| `luci-app-upnp` | UPnP Mapping | Automated port mapping for gaming and P2P downloads |
| `luci-app-wol` | Wake-on-LAN | Wake up remote computers directly from the router interface |

> [!NOTE]
> **Upstream H3 Platform Support Status:**
> The NanoPi R1S-H3 (32-bit Cortex-A7) platform is currently excluded from the default Image Builder matrix due to a lack of official stable target profiles in upstream ImmortalWrt 23.05 release branches. R1S-H5 configuration compiles and delivers the full set of applications out-of-the-box.

---

## 🛠️ Compilation and Scheduling

### 1. Triggering a Build

- **Monthly Automated Build (Cron)**: The workflow runs automatically at **02:00 AM on the 1st of every month** (`0 2 1 * *`). This keeps proxy cores (Xray, sing-box) and ImmortalWrt system packages up to date.
- **Manual Trigger**:
  1. Navigate to the **Actions** tab on your repository.
  2. Select the **ImmortalWrt Builder** workflow.
  3. Click **Run workflow**, choose your branch (defaults to `openwrt-24.10`), and trigger.

### 2. GITHUB_TOKEN Permissions Configuration

For the workflow to successfully write environment variables, release tags, and upload firmware artifacts, write permissions must be enabled:

1. In your GitHub repository, click on **Settings** in the top navigation bar.
2. In the left-hand sidebar under **Actions**, click **General**.
3. Scroll down to the **Workflow permissions** section.
4. Select **Read and write permissions**.
5. (Recommended) Check **Allow GitHub Actions to create and approve pull requests**.
6. Click **Save**.

---

## 🚀 Quick Start / How to Use

### 1. Fork this Repository
Click the **Fork** button in the upper right corner to create a copy of this repository under your GitHub account.

### 2. Configure Settings (Optional)
- Place custom configurations under `/configs/24.10/` (e.g., `nanopi-r1s-h5.config` or `nanopi-r1s-h3.config`).
- Modify `diy-part1.sh` (executed before feeds update) and `diy-part2.sh` (executed before compilation) to inject scripts or packages.

### 3. Flash & Upgrade Guide (For Release Users)

For users downloading pre-compiled system images directly from the **Releases** page:

#### ⚡ Option A: Fresh Installation / First-time Flash (Required when migrating from other firmwares)
Since migrating to ImmortalWrt 23.05 involves kernel change and partition table structure variance, **do not attempt Web upgrade from legacy iStoreOS**. A clean flashing is required:
1. Download `*-squashfs-sdcard.img.gz` (recommended for recovery reset) or `*-ext4-sdcard.img.gz` from the latest Release.
2. Uncompress the `.gz` file locally to retrieve the raw `.img` firmware file.
3. Insert your TF (SD) card into your computer.
4. Use **Rufus** (Windows) or **BalenaEtcher** (Cross-platform) to burn the `.img` directly to the card.
5. Plug the card back into your NanoPi R1S-H5 and power it on.

#### 🔄 Option B: Daily Web Upgrades (For subsequent upgrades)
Once you are already running this project's ImmortalWrt 23.05 system:
1. Download the latest `*-sdcard.img.gz` file from the Release (Do **not** uncompress it).
2. Navigate to your router Web GUI under **System** ➜ **Backup/Flash Firmware**.
3. In the **Flash new firmware image** section, upload the `*-sdcard.img.gz` file directly.
4. Keep **Keep settings** checked if you want to retain your configurations, and click **Flash image** to execute a painless Web hot upgrade without unplugging the SD card!

---

### 4. Customizing and Building (For Developers)
If you wish to compile your own custom images using this repository:
1. Click the **Fork** button in the upper right corner to create a copy under your account.
2. Place custom configs under `/configs/24.10/` (e.g., `nanopi-r1s-h5.config`).
3. Modify `diy-part1.sh` (executed before feeds update) and `diy-part2.sh` (executed before packaging) to inject packages.
4. Once the workflow finishes successfully, your custom firmware will be available in **Artifacts** and **Releases** on your repository.

---

## 📜 License

This project is licensed under the MIT License. See [LICENSE](LICENSE) for details.

## 🙏 Acknowledgements

- [P3TERX](https://github.com/P3TERX/Actions-OpenWrt) - Original Action workflow baseline
- [ImmortalWrt](https://github.com/immortalwrt/immortalwrt) - Operating system base
- [sbwml](https://github.com/sbwml/openwrt-wireless-drivers) - OpenWrt wireless drivers repository
- [Openwrt-Passwall](https://github.com/Openwrt-Passwall/openwrt-passwall) - PassWall upstream source
- [jerrykuku](https://github.com/jerrykuku/luci-theme-argon) - Argon theme