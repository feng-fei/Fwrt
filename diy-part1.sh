#!/bin/bash
# 添加额外插件源
# sed -i '$a src-git custom https://github.com/xiaorouji/openwrt-passwall' feeds.conf.default
# 添加 Lucky 插件源
git clone https://github.com/gdy666/luci-app-lucky.git package/luci-app-lucky
# 添加 Vantage 主题源（含 luci-theme-vantage 与 luci-app-vantage）
git clone https://github.com/anothaDev/luci-theme-vantage.git package/luci-theme-vantage
# 添加 honk 插件源（含 honk 内核包与 luci-app-honk 界面）
git clone https://github.com/QiuSimons/luci-app-honk.git package/luci-app-honk
# honk-core 直接用上游预编译二进制（Makefile 的 HONK_SRC_VERSION=88d470c 正是 v0.1.0-beta.5 的 commit；有 bin 且无 .stamp 时构建脚本跳过 Rust 编译）
HONK_CORE_VER=v0.1.0-beta.5
mkdir -p package/luci-app-honk/honk/files
curl -fL --retry 3 -o /tmp/honk-core.tar.gz \
  "https://github.com/daeuniverse/honk/releases/download/${HONK_CORE_VER}/honk-core-${HONK_CORE_VER}-x86_64-unknown-linux-musl-full.tar.gz"
tar -xzf /tmp/honk-core.tar.gz -C /tmp
# QiuSimons 的 init 脚本没挂 bpffs，honk 启动前必须有 /sys/fs/bpf
sed -i '/^start_service() {/a\
    mkdir -p /sys/fs/bpf\
    mount -t bpf bpf /sys/fs/bpf 2>/dev/null || true' package/luci-app-honk/honk/files/honk.init
install -m 0755 "/tmp/honk-core-${HONK_CORE_VER}-x86_64-unknown-linux-musl-full/honk-core" \
  package/luci-app-honk/honk/files/honk-core.bin
#luci-app-aurora 增加
git clone https://github.com/eamonxg/luci-theme-aurora.git package/luci-theme-aurora
git clone https://github.com/eamonxg/luci-app-aurora-config.git package/luci-app-aurora-config
