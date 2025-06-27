# Actions-iStoreOS-NanoPi-R1S-H5

[![LICENSE](https://img.shields.io/github/license/mashape/apistatus.svg?style=flat-square&label=LICENSE)](https://github.com/CrueChan/Actions-istoreOS-NanoPi-R1S-H5/blob/main/LICENSE)
![GitHub Stars](https://img.shields.io/github/stars/CrueChan/Actions-istoreOS-NanoPi-R1S-H5.svg?style=flat-square&label=Stars&logo=github)
![GitHub Forks](https://img.shields.io/github/forks/CrueChan/Actions-istoreOS-NanoPi-R1S-H5.svg?style=flat-square&label=Forks&logo=github)

iStoreOS firmware automatic build project customized for NanoPi R1S H5 device, based on GitHub Actions to achieve automated build and version management.

## ✨ Features

- 🔄 **Automatic version detection**: Regularly check the new version of the iStoreOS upstream warehouse

- 🚀 **Automatic build trigger**: Automatically start the build process when a new version is found

- 📦 **Release management**: Automatically publish firmware to GitHub Releases

- 🎯 **Device-specific**: Optimized specifically for NanoPi R1S H5 devices

- ⚙️ **Manual trigger**: Supports manually specifying branches for building

## 🏗️ Workflow description

### Build workflow (build-istoreos.yml)
Based on [P3TERX/Actions-OpenWrt](https://github.com/P3TERX/Actions-OpenWrt), it is specially used for iStoreOS firmware compilation:
- Support manual triggering and automatic triggering
- Automatically extract device information and generate file names
- Upload firmware to Artifacts and Releases
- Automatically clean up old versions of Release

### Version check workflow (check-upstream-istoreos.yml)
Completely original automated workflow, implements:
- Check upstream iStoreOS new versions daily
- Intelligent version comparison algorithm
- Automatically trigger build process
- Version status management

## 🚀 How to use

### 1. Fork this repository
Click the Fork button in the upper right corner to create your own copy.

### 2. Configure build files (optional)
- Add `.config` file to the repository root directory
- Add `feeds.conf.default` custom source (optional)
- Add `diy-part1.sh` and `diy-part2.sh` custom scripts (optional)

### 3. Trigger build

#### Automatic build
The workflow will automatically check for iStoreOS upstream updates every day and automatically build when a new version is found.

#### Manual build
1. Go to the Actions page
2. Select the "iStoreOS Builder" workflow
3. Click the "Run workflow" button
4. Select the iStoreOS branch to build (optional)
5. Wait for the build to complete

### 4. Download the firmware
After the build is complete, you can get the firmware in the following ways:
- **Artifacts**: Artifacts button in the upper right corner of the Actions page
- **Releases**: Releases page on the repository homepage

## 📋 Device information

- **Target device**: NanoPi R1S H5
- **Architecture**: ARM64
- **Firmware system**: iStoreOS
- **Supported features**:
- Soft router feature
- Docker container support
- iStore App Store
- Network storage feature

## ⚙️ Advanced configuration

### Environment variables
The following environment variables can be modified in the workflow file:
```yaml
env:
UPLOAD_FIRMWARE: true # Whether to upload firmware to Artifacts
UPLOAD_RELEASE: true # Whether to publish to Releases
TZ: Asia/Shanghai # Time zone setting
```

### Custom scripts
- `diy-part1.sh`: Script executed before feeds update
- `diy-part2.sh`: Script executed before compilation

## 🔧 Troubleshooting

### Common problems
1. **Build failed**: Check the Actions log, usually configuration files or dependency issues
2. **Permission error**: Make sure the repository Actions permissions are set correctly
3. **Insufficient storage space**: GitHub Actions has storage limits, clean up old versions regularly

### Get help
- View [Issues](https://github.com/CrueChan/Actions-istoreOS-NanoPi-R1S-H5/issues) page
- Refer to [iStoreOS official documentation](https://github.com/istoreos/istoreos)

## 🤝 Contribution

Welcome to submit issues and pull requests to improve this project!

## 📜 License

This project is open source based on the MIT license, see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgements

- [P3TERX](https://github.com/P3TERX/Actions-OpenWrt) - Original GitHub Actions workflow
- [iStoreOS](https://github.com/istoreos/istoreos) - Firmware system
- [GitHub Actions](https://github.com/features/actions) - CI/CD platform
- [NanoPi](http://nanopi.io/) - Hardware platform
- [softprops/action-gh-release](https://github.com/softprops/action-gh-release) - Release release tool
- [Mattraks/delete-workflow-runs](https://github.com/Mattraks/delete-workflow-runs) - Workflow cleanup tool
- [dev-drprasad/delete-older-releases](https://github.com/dev-drprasad/delete-older-releases) - Release cleaning tool

---

**Disclaimer**: This project is for learning and research purposes only. Please comply with relevant laws and regulations.