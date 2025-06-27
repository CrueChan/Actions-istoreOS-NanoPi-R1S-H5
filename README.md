# Actions-iStoreOS-NanoPi-R1S-H5

[![LICENSE](https://img.shields.io/github/license/mashape/apistatus.svg?style=flat-square&label=LICENSE)](https://github.com/CrueChan/Actions-istoreOS-NanoPi-R1S-H5/blob/main/LICENSE)
![GitHub Stars](https://img.shields.io/github/stars/CrueChan/Actions-istoreOS-NanoPi-R1S-H5.svg?style=flat-square&label=Stars&logo=github)
![GitHub Forks](https://img.shields.io/github/forks/CrueChan/Actions-istoreOS-NanoPi-R1S-H5.svg?style=flat-square&label=Forks&logo=github)

专为 NanoPi R1S H5 设备定制的 iStoreOS 固件自动构建项目，基于 GitHub Actions 实现自动化构建和版本管理。

## ✨ 功能特性

- 🔄 **自动版本检测**: 定时检查 iStoreOS 上游仓库新版本
- 🚀 **自动构建触发**: 发现新版本时自动开始构建流程
- 📦 **Release 管理**: 自动发布固件到 GitHub Releases
- 🎯 **设备专用**: 专门针对 NanoPi R1S H5 设备优化
- ⚙️ **手动触发**: 支持手动指定分支进行构建

## 🏗️ 工作流说明

### 构建工作流 (build-istoreos.yml)
基于 [P3TERX/Actions-OpenWrt](https://github.com/P3TERX/Actions-OpenWrt) 修改，专门用于 iStoreOS 固件编译：
- 支持手动触发和自动触发
- 自动提取设备信息和生成文件名
- 上传固件到 Artifacts 和 Releases
- 自动清理旧版本 Release

### 版本检查工作流 (check-upstream-istoreos.yml)
完全原创的自动化工作流，实现：
- 每日定时检查上游 iStoreOS 新版本
- 智能版本比较算法
- 自动触发构建流程
- 版本状态管理

## 🚀 使用方法

### 1. Fork 本仓库
点击右上角的 Fork 按钮创建你自己的副本。

### 2. 配置构建文件（可选）
- 添加 `.config` 文件到仓库根目录
- 添加 `feeds.conf.default` 自定义源（可选）
- 添加 `diy-part1.sh` 和 `diy-part2.sh` 自定义脚本（可选）

### 3. 触发构建

#### 自动构建
工作流会每天自动检查 iStoreOS 上游更新，发现新版本时自动构建。

#### 手动构建
1. 进入 Actions 页面
2. 选择 "iStoreOS Builder" 工作流
3. 点击 "Run workflow" 按钮
4. 选择要构建的 iStoreOS 分支（可选）
5. 等待构建完成

### 4. 下载固件
构建完成后，可通过以下方式获取固件：
- **Artifacts**: Actions 页面右上角的 Artifacts 按钮
- **Releases**: 仓库主页的 Releases 页面

## 📋 设备信息

- **目标设备**: NanoPi R1S H5
- **架构**: ARM64
- **固件系统**: iStoreOS
- **支持的功能**: 
  - 软路由功能
  - Docker 容器支持
  - iStore 应用商店
  - 网络存储功能

## ⚙️ 高级配置

### 环境变量
可在工作流文件中修改以下环境变量：
```yaml
env:
  UPLOAD_FIRMWARE: true      # 是否上传固件到 Artifacts
  UPLOAD_RELEASE: true       # 是否发布到 Releases
  TZ: Asia/Shanghai          # 时区设置
```

### 自定义脚本
- `diy-part1.sh`: feeds 更新前执行的脚本
- `diy-part2.sh`: 编译前执行的脚本

## 🔧 故障排除

### 常见问题
1. **构建失败**: 检查 Actions 日志，通常是配置文件或依赖问题
2. **权限错误**: 确保仓库 Actions 权限设置正确
3. **存储空间不足**: GitHub Actions 有存储限制，定期清理旧版本

### 获取帮助
- 查看 [Issues](https://github.com/CrueChan/Actions-istoreOS-NanoPi-R1S-H5/issues) 页面
- 参考 [iStoreOS 官方文档](https://github.com/istoreos/istoreos)

## 🤝 贡献

欢迎提交 Issue 和 Pull Request 来改进这个项目！

## 📜 许可证

本项目基于 MIT 许可证开源，详见 [LICENSE](LICENSE) 文件。

## 🙏 致谢

- [P3TERX](https://github.com/P3TERX/Actions-OpenWrt) - 原始 GitHub Actions 工作流
- [iStoreOS](https://github.com/istoreos/istoreos) - 固件系统
- [GitHub Actions](https://github.com/features/actions) - CI/CD 平台
- [NanoPi](http://nanopi.io/) - 硬件平台
- [softprops/action-gh-release](https://github.com/softprops/action-gh-release) - Release 发布工具
- [Mattraks/delete-workflow-runs](https://github.com/Mattraks/delete-workflow-runs) - 工作流清理工具
- [dev-drprasad/delete-older-releases](https://github.com/dev-drprasad/delete-older-releases) - Release 清理工具

---

**免责声明**: 本项目仅供学习和研究使用，请遵守相关法律法规。