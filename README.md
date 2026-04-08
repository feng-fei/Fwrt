# Fwrt - OpenWrt / ImmortalWrt 自编译固件

这是一个用于快速定制与编译 OpenWrt / ImmortalWrt 固件的自编译项目。仓库通过预置的 .config ���入、启动初始化脚本和定制化包/驱动列表，方便在本地或 CI 中生成符合个人需求的固件镜像。

## 主要功能（基于仓库脚本）

本 README 已根据仓库中的脚本（主要为 `diy-part2.sh`）整理，内容会随着脚本变动而同步更新：

- 修改默认网络与主机名：将默认 IP 修改为 `172.28.10.1`，主机名修改为 `F-WRT`。
- 注入编译配置到 `.config`：设置目标为 x86_64 通用设备并开启若干包与内核/根分区参数（详见配置清单）。
- 默认 root 密码注入：脚本会替换 `package/base-files/files/etc/shadow` 中的 root 密码（示例密码为 `jojo8888`，请务必更改）。
- 启动初始化脚本：在 `package/base-files/files/etc/uci-defaults/` 下添加 `99-f-wrt-init`，用于开启 BBR、设置 LuCI 默认语言为中文等启动时配置。

## 从代码提取的配置摘要（来自 diy-part2.sh）

> 注：这些配置由 `diy-part2.sh` 通过追加写入 `.config` 实现，编译时会由 `make defconfig` 自动展开依赖。

- 目标平台与设备：
  - CONFIG_TARGET_x86=y
  - CONFIG_TARGET_x86_64=y
  - CONFIG_TARGET_x86_64_DEVICE_generic=y
- 分区大小：
  - CONFIG_TARGET_KERNEL_PARTSIZE=128
  - CONFIG_TARGET_ROOTFS_PARTSIZE=512
- 本地化与 LuCI：
  - CONFIG_LUCI_LANG_zh_Hans=y
  - CONFIG_PACKAGE_luci=y
- 指定集成包（示例）：
  - CONFIG_PACKAGE_luci-app-lucky=y
  - CONFIG_PACKAGE_luci-app-aurora-config=y
  - CONFIG_PACKAGE_luci-app-homeproxy=y
  - CONFIG_PACKAGE_luci-app-openclash=y
  - CONFIG_PACKAGE_luci-theme-aurora=y
- 硬件驱动（示例）：
  - CONFIG_PACKAGE_kmod-r8125=y
  - CONFIG_PACKAGE_kmod-virtio-net=y
  - CONFIG_PACKAGE_kmod-virtio-blk=y

## 启动时注入的初始化脚本（来自 diy-part2.sh）

脚本路径：`package/base-files/files/etc/uci-defaults/99-f-wrt-init`，主要行为：

- 开启 BBR：将以下行追加到 `/etc/sysctl.conf`：
  - net.core.default_qdisc=fq
  - net.ipv4.tcp_congestion_control=bbr
- 强制 LuCI 使用中文界面：
  - uci set luci.main.lang=zh_cn
  - uci commit luci

## 使用方法（快速指南）

1. Fork 或 Clone 本项目：
   git clone https://github.com/feng-fei/Fwrt.git
2. 根据需要修改 `diy-part1.sh`（插件源与额外准备）和 `diy-part2.sh`（.config 注入、默认密码替换、uci-defaults 创建）。
3. 将本仓库内的文件与 OpenWrt/ImmortalWrt 源码树整合（作为 overlay 或拷贝到源码目录）。
4. 在 OpenWrt 源码根目录下执行：
   make defconfig
   make -j$(nproc) V=s
5. 编译完成后，固件镜像在 bin/targets/ 下生成（按目标平台目录区分）。

## 注意事项与安全提示

- 仓库中的 `diy-part2.sh` 包含对 root 密码的直接替换（示例密码 `jojo8888`）。请在生产环境或公开发布前务必更改为安全密码或移除此步骤。
- 在追加写入 `.config` 前，建议先在本地用 menuconfig 或手动检查需要的包与配置，避免不必要的依赖增加编译时间和体积。
- 在使用本仓库作为 overlay 时，确保路径与目标源码树一致（package/base-files/... 等路径需要保留）。

## 项目文件说明（简要）

- diy-part1.sh：用于在编译前期添加或调整插件源、额外准备工作（当前以注释示例为主）。
- diy-part2.sh：主要用于注入 .config、修改默认 IP/主机名、替换 root 密码、并创建 uci-defaults 启动脚本。

## 技术栈

- Shell Script（主要脚本为 `diy-part1.sh` 与 `diy-part2.sh`）
- OpenWrt / ImmortalWrt 编译体系

## 许可

本项目遵循 MIT 许可证，详见 LICENSE 文件。

-- 文件自动更新：该 README 根据仓库中的脚本内容进行同步整理，建议在脚本变动后一并更新 README。
