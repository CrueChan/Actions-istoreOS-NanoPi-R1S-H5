# Actions-OpenWrt-NanoPi-R1S-H5-H3

[![LICENSE](https://img.shields.io/github/license/mashape/apistatus.svg?style=flat-square&label=LICENSE)](https://github.com/CrueChan/Actions-istoreOS-NanoPi-R1S-H5/blob/main/LICENSE)
![GitHub Stars](https://img.shields.io/github/stars/CrueChan/Actions-istoreOS-NanoPi-R1S-H5.svg?style=flat-square&label=Stars&logo=github)
![GitHub Forks](https://img.shields.io/github/forks/CrueChan/Actions-istoreOS-NanoPi-R1S-H5.svg?style=flat-square&label=Forks&logo=github)

Automated GitHub Actions build workflow for NanoPi R1S H5 and H3 dual platforms, upgraded to **ImmortalWrt 25.12** stable branch (Linux kernel 6.x).

---

## ✨ Features

- ⚡ **Dual Platform Parallel Build**: Utilizes GitHub Actions matrix strategy to build for both NanoPi R1S-H5 (64-bit Cortex-A53) and R1S-H3 (32-bit Cortex-A7) concurrently.
- 💾 **Smart Partition Resize**: Small initial firmware size for fast downloading and flashing, with an automated smart expansion system on the first boot.
- 📶 **Onboard Wi-Fi Support**: Pre-integrated SDIO wireless drivers for RTL8189ES and RTL8723BU to ensure out-of-the-box AP/Client mode availability.
- 🛡️ **Static Verification Checks**: Incorporates a CI/CD assertion job that loop-mounts the compiled rootfs in the cloud to verify kernel modules, network port mapping, and partition expansion scripts before releasing.
- 📦 **Automated Release Publishing**: Publishes compiled system images (including sysupgrade packages) directly to GitHub Releases.
- 🚀 **Monthly Cron / Manual Compilation**: Keeps up-to-date with upstream packages, security updates, and proxy cores automatically.

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
- `kmod-rtl8189es` - RTL8189ES SDIO Wi-Fi driver
- `kmod-rtl8723bu` - RTL8723BU SDIO Wi-Fi driver
- `rtl8189es-firmware` & `rtl8723bu-firmware` - Required firmware assets
- Custom double-port mapping (VLAN configured WAN on `eth0` / LAN on `eth1` dynamically on boot)

### Applications and Services
| Package Name | Function | Description |
| :--- | :--- | :--- |
| `luci-app-passwall` | Proxy Client | Supports multiple protocols, running Xray/sing-box cores |
| `luci-theme-argon` | Modern Theme | Elegant responsive interface for desktop & mobile devices |
| `luci-app-argon-config`| Theme Configuration| Customize argon theme backgrounds, colors, and login logo |
| `luci-app-diskman` | Disk Management | Manage partitions, format, and mount unallocated TF card space |
| `luci-app-ddns` | Dynamic DNS | Automated IP sync with Cloudflare, Aliyun, DNSPod, etc. |
| `luci-app-upnp` | UPnP Mapping | Automated port mapping for gaming and P2P downloads |
| `luci-app-wol` | Wake-on-LAN | Wake up remote computers directly from the router interface |

---

## 🛠️ Compilation and Scheduling

### 1. Triggering a Build

- **Monthly Automated Build (Cron)**: The workflow runs automatically at **02:00 AM on the 1st of every month** (`0 2 1 * *`). This keeps proxy cores (Xray, sing-box) and ImmortalWrt system packages up to date.
- **Manual Trigger**:
  1. Navigate to the **Actions** tab on your repository.
  2. Select the **ImmortalWrt Builder** workflow.
  3. Click **Run workflow**, choose your branch (defaults to `openwrt-25.12`), and trigger.

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
- Place custom configurations under `/configs/25.12/` (e.g., `nanopi-r1s-h5.config` or `nanopi-r1s-h3.config`).
- Modify `diy-part1.sh` (executed before feeds update) and `diy-part2.sh` (executed before compilation) to inject scripts or packages.

### 3. Retrieve Firmware
Once the workflow finishes successfully, your firmware will be available in:
- **Artifacts**: Accessible from the action run summary page.
- **Releases**: Published on your repository's Releases page.

---

## 📜 License

This project is licensed under the MIT License. See [LICENSE](LICENSE) for details.

## 🙏 Acknowledgements

- [P3TERX](https://github.com/P3TERX/Actions-OpenWrt) - Original Action workflow baseline
- [ImmortalWrt](https://github.com/immortalwrt/immortalwrt) - Operating system base
- [sbwml](https://github.com/sbwml/openwrt-wireless-drivers) - OpenWrt wireless drivers repository
- [xiaorouji](https://github.com/xiaorouji/openwrt-passwall) - PassWall upstream source
- [jerrykuku](https://github.com/jerrykuku/luci-theme-argon) - Argon theme