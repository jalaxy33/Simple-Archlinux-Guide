#!/usr/bin/env bash

# ~/.config/niri/scripts/shorin-sync.sh
#
# 同步 shorin 配置，同时保留用户本地更改

PWD=$(pwd)
SHORIN_DIR="$HOME/.local/share/shorin-arch-setup"
SYNC_SCRIPT="$HOME/.config/niri/scripts/sync-modify.sh"

cd $SHORIN_DIR
source $SYNC_SCRIPT
cd $PWD

# 使用方法：
# 1. 首先 clone `shorin-arch-setup` 仓库到 ~/.local/share/shorin-arch-setup:
#     git clone https://github.com/SHORiN-KiWATA/shorin-arch-setup.git ~/.local/share/shorin-arch-setup
# 2. 备份用户本地更改的配置文件：
#     mv ~/.config/niri ~/.config/niri-bak
# 3. 将 Shorin 的配置链接到本地配置目录
#     ln -s  ~/.local/share/shorin-arch-setup/dms-dotfiles/.config/niri ~/.config/niri
# 4. 复制同一目录下的 `sync-modify.sh` 到 ~/.config/niri/scripts/sync-modify.sh
# 5. 赋予此脚本执行权限：
#     chmod +x ~/.config/niri/scripts/shorin-sync.sh
# 6. 将此脚本链接到 ~/.local/bin/shorin-sync
#     ln -s ~/.config/niri/scripts/shorin-sync.sh ~/.local/bin/shorin-sync
#
# 之后每次 shorin-arch-setup 仓库有更新时，运行 `shorin-sync` 即可同步配置，同时保留用户本地更改。

