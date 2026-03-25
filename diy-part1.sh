#!/bin/bash
# 添加额外插件源
# sed -i '$a src-git custom https://github.com/xiaorouji/openwrt-passwall' feeds.conf.default
# 添加 Lucky 插件源
git clone https://github.com/gdy666/luci-app-lucky.git package/luci-app-lucky
