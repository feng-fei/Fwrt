#!/bin/bash

# 1. 修改默认 IP 与 主机名
sed -i 's/192.168.1.1/172.28.10.1/g' package/base-files/files/bin/config_generate
sed -i 's/ImmortalWrt/F-WRT/g' package/base-files/files/bin/config_generate

# 2. 注入配置到 .config
# 注意：这些配置会在编译时由 make defconfig 自动扩展依赖
cat >> .config <<EOF
CONFIG_TARGET_x86=y
CONFIG_TARGET_x86_64=y
CONFIG_TARGET_x86_64_DEVICE_generic=y
CONFIG_TARGET_KERNEL_PARTSIZE=128
CONFIG_TARGET_ROOTFS_PARTSIZE=512
CONFIG_LUCI_LANG_zh_Hans=y
CONFIG_PACKAGE_luci=y
CONFIG_PACKAGE_luci-app-lucky=y
CONFIG_PACKAGE_luci-app-aurora-config=y
CONFIG_PACKAGE_luci-app-homeproxy=y
CONFIG_PACKAGE_luci-app-openclash=y
CONFIG_PACKAGE_luci-theme-aurora=y
CONFIG_PACKAGE_kmod-r8125=y
CONFIG_PACKAGE_kmod-virtio-net=y
CONFIG_PACKAGE_kmod-virtio-blk=y
EOF

# 3. 密码设置 (jojo8888)
# 使用更直接的方式替换 root 密码行
sed -i 's/^root:.*$/root:$1$vI6f7.oW$8X7Q1t7T6k1fR0T0e1\/:18888:0:99999:7:::/g' package/base-files/files/etc/shadow

# 4. 系统启动初始化
mkdir -p package/base-files/files/etc/uci-defaults
cat > package/base-files/files/etc/uci-defaults/99-f-wrt-init <<EOF
#!/bin/sh
# 开启 BBR
echo "net.core.default_qdisc=fq" >> /etc/sysctl.conf
echo "net.ipv4.tcp_congestion_control=bbr" >> /etc/sysctl.conf
# 强制中文界面
uci set luci.main.lang=zh_cn
uci commit luci
exit 0
EOF
chmod +x package/base-files/files/etc/uci-defaults/99-f-wrt-init
