#!/bin/bash

# 1. 基础网络设置
sed -i 's/192.168.1.1/172.28.10.1/g' package/base-files/files/bin/config_generate
# 修改默认主机名为 F-wrt
sed -i 's/ImmortalWrt/F-wrt/g' package/base-files/files/bin/config_generate

# 2. 修改默认密码 (jojo8888)
sed -i 's/root:::0:99999:7:::/root:$1$vI6f7.oW$8X7Q1t7T6k1fR0T0e1\/18888:0:99999:7:::/g' package/base-files/files/etc/shadow

# 3. 注入固件配置 (插件、驱动与加速)
cat >> .config <<EOF
CONFIG_TARGET_x86=y
CONFIG_TARGET_x86_64=y
CONFIG_TARGET_x86_64_DEVICE_generic=y

# 你的专属插件包
CONFIG_PACKAGE_luci-app-aurora-config=y
CONFIG_PACKAGE_luci-app-autoreboot=y
CONFIG_PACKAGE_luci-app-firewall=y
CONFIG_PACKAGE_luci-app-homeproxy=y
CONFIG_PACKAGE_luci-app-openclash=y
CONFIG_PACKAGE_luci-app-package-manager=y
CONFIG_PACKAGE_luci-app-partexp=y
CONFIG_PACKAGE_luci-app-ttyd=y
CONFIG_PACKAGE_luci-app-upnp=y
CONFIG_PACKAGE_luci-app-wolplus=y
CONFIG_PACKAGE_luci-theme-aurora=y

# 常用全家桶
CONFIG_PACKAGE_luci-app-turboacc=y
CONFIG_PACKAGE_luci-app-diskman=y
CONFIG_PACKAGE_luci-app-samba4=y
CONFIG_PACKAGE_luci-app-vlmcsd=y

# 硬件驱动 (8125 & 虚拟机)
CONFIG_PACKAGE_kmod-r8125=y
CONFIG_PACKAGE_kmod-virtio-net=y
CONFIG_PACKAGE_kmod-virtio-blk=y
EOF

# 强迫症选项：删除报错的 onionshare-cli 文件夹
rm -rf package/feeds/packages/onionshare-cli