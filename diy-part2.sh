#!/bin/bash

# 1. 基础网络设置 (IP 与 主机名)
sed -i 's/192.168.1.1/172.28.10.1/g' package/base-files/files/bin/config_generate
sed -i 's/ImmortalWrt/F-wrt/g' package/base-files/files/bin/config_generate

# 2. 补全配置
cat >> .config <<EOF
# ==================== 核心：指定编译目标架构 ====================
CONFIG_TARGET_x86=y
CONFIG_TARGET_x86_64=y
CONFIG_TARGET_x86_64_DEVICE_generic=y
CONFIG_TARGET_KERNEL_PARTSIZE=128
CONFIG_TARGET_ROOTFS_PARTSIZE=1024

# LuCI 基础框架与 Web 服务器 (必选)
CONFIG_PACKAGE_luci=y
CONFIG_PACKAGE_luci-base=y
CONFIG_PACKAGE_luci-mod-admin-full=y
CONFIG_PACKAGE_uhttpd=y
CONFIG_PACKAGE_uhttpd-mod-ubus=y
CONFIG_PACKAGE_rpcd=y

# Lucky 及其功能组件
CONFIG_PACKAGE_luci-app-lucky=y
CONFIG_PACKAGE_lucky=y

# 特定插件
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

# 常用加速与工具
CONFIG_PACKAGE_luci-app-turboacc=y
CONFIG_PACKAGE_luci-app-turboacc_INCLUDE_BBR_CCA=y
CONFIG_PACKAGE_luci-app-turboacc_INCLUDE_OFFLOADING=y
CONFIG_PACKAGE_luci-app-turboacc_INCLUDE_SHORTCUT_FE=y
CONFIG_PACKAGE_luci-app-diskman=y
CONFIG_PACKAGE_luci-app-samba4=y
CONFIG_PACKAGE_luci-app-vlmcsd=y

# 虚拟机与 8125 网卡驱动
CONFIG_PACKAGE_kmod-r8125=y
CONFIG_PACKAGE_kmod-virtio-net=y
CONFIG_PACKAGE_kmod-virtio-blk=y
CONFIG_PACKAGE_kmod-virtio-balloon=y
CONFIG_PACKAGE_kmod-virtio-console=y

# IPv6 拨号上网优化 (主路由模式)
CONFIG_PACKAGE_ipv6helper=y
CONFIG_PACKAGE_dnsmasq-full=y
CONFIG_PACKAGE_odhcp6c=y
CONFIG_PACKAGE_odhcpd-hybrid=y
CONFIG_PACKAGE_luci-proto-ipv6=y
EOF

# 3. 密码设置 (jojo8888) - 已修正冒号缺失问题
sed -i 's/^root:.*$/root:$1$vI6f7.oW$8X7Q1t7T6k1fR0T0e1\/:18888:0:99999:7:::/g' package/base-files/files/etc/shadow

# 4. 初始化脚本 (BBR + Web服务自启) - 已优化逻辑
mkdir -p package/base-files/files/etc/uci-defaults
cat > package/base-files/files/etc/uci-defaults/99-f-wrt-init <<EOF
#!/bin/sh
# 开启 BBR
echo "net.core.default_qdisc=fq" >> /etc/sysctl.conf
echo "net.ipv4.tcp_congestion_control=bbr" >> /etc/sysctl.conf
sysctl -p

# 强制开启 Web 服务
/etc/init.d/uhttpd enable
/etc/init.d/uhttpd start
exit 0
EOF
chmod +x package/base-files/files/etc/uci-defaults/99-f-wrt-init
