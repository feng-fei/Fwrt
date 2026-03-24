# Fwrt - OpenWrt 自编译固件

这是一个 OpenWrt 自编译项目，用于快速定制和编译适合个人需求的 OpenWrt 固件。

## 项目描述

Fwrt 提供了一套完整的 OpenWrt 编译配置和自定义脚本，包括：
- 网络配置修改（IP 地址、主机名等）
- 默认密码设置
- 固件插件和驱动集成
- 硬件驱动适配

## 项目文件说明

### diy-part1.sh
用于在编译前期进行额外的插件源配置和准备工作。当前包含注释示例：
- 添加自定义插件源（如 openwrt-passwall）

### diy-part2.sh
编译前期的主要定制脚本，包含以下功能：

1. **基础网络设置**
   - 修改默认 IP 地址：172.28.10.1
   - 修改默认主机名：F-wrt

2. **默认密码设置**
   - 密码：jojo8888

3. **固件配置**
   - 目标平台：x86_64 通用设备
   - 专属插件包：
     - luci-app-aurora-config
     - luci-app-autoreboot
     - luci-app-firewall
     - luci-app-homeproxy
     - luci-app-openclash
     - luci-app-package-manager
     - luci-app-partexp
     - luci-app-ttyd
     - luci-app-upnp
     - luci-app-wolplus
     - luci-theme-aurora

   - 常用功能包：
     - luci-app-turboacc（网络加速）
     - luci-app-diskman（磁盘管理）
     - luci-app-samba4（文件共享）
     - luci-app-vlmcsd（KMS 服务）

   - 硬件驱动：
     - kmod-r8125（8125 网卡驱动）
     - kmod-virtio-net（虚拟网卡驱动）
     - kmod-virtio-blk（虚拟块设备驱动）

## 使用方法

1. Fork 或 Clone 本项目
2. 根据需要修改 `diy-part1.sh` 和 `diy-part2.sh` 中的配置
3. 将文件集成到 OpenWrt 编译流程中
4. 执行编译命令生成定制固件

## 自定义配置

编辑 `diy-part2.sh` 可以：
- 修改默认 IP 地址和主机名
- 添加或移除插件
- 调整硬件驱动支持
- 配置其他系统选项

## 技术栈

- Shell Script 100%
- OpenWrt 固件系统

## 许可证

本项目遵循 MIT 许可证 - 详见 [LICENSE](LICENSE) 文件