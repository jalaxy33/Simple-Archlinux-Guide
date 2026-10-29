# 中文输入法

> 参考教程：[中文输入法 - Shorin-ArchLinux-Guide](https://github.com/SHORiN-KiWATA/Shorin-ArchLinux-Guide/blob/main/wiki/archlinux/中文输入法.md)

## fcitx5+rime

### 安装配置

1. 安装输入法框架

   ```sh
   sudo pacman -S fcitx5-im
   ```

2. 选择中文输入法方案，推荐「rime 引擎 + 雾凇拼音」的方案

   ```sh
   sudo pacman -S fcitx5-rime rime-ice-git
   ```

    <details>
    <summary>软件包说明</summary>

   - `fcitx5-rime` 是输入法引擎
   - `rime-ice-git` 是雾凇拼音输入法方案，需要 archlinuxcn 源。

     其他方案：`fcitx5-mozc` 日语输入法，`rime-wubi` 五笔输入法。

    </details>

   现在打开 `fcitx5-configtool` 就可以添加 `rime（中州韵）` 到输入法列表中了，添加后重启输入法，`ctrl+空格` 切换到 rime 后会自动初始化。

   > 默认的输入方案是繁体的 `明月拼音`，按下 F4 可以打开菜单调整为简体输入法。

3. 编辑输入法配置

    ```sh
    mkdir -p ~/.local/share/fcitx5/rime
    vim ~/.local/share/fcitx5/rime/default.custom.yaml
    ```

   添加设置

    ```yaml
    patch:
      ascii_composer:
        good_old_caps_lock: true
      schema_list:
        - schema: rime_ice
        - schema: luna_pinyin_simp
        - schema: double_pinyin
        - schema: double_pinyin_flypy
        - schema: wubi86
        - schema: bopomofo
      "menu/page_size": 6
    ```

4. 可选：配置输入法模型

   推荐给雾凇拼音接入万象的语法模型，可以提高长句联想效果。

    - 可以从 AUR 或者 archlinuxcn 安装

        ```sh
        sudo pacman -S rime-wanxiang-gram-zh-hans
        ```

      > 或者从 GitHub 手动下载：[点击此处下载模型](https://github.com/amzxyz/RIME-LMDG/releases/download/LTS/wanxiang-lts-zh-hans.gram)，下载完成后把模型放在 `~/.local/share/fcitx5/rime/`。

    - 然后编辑雾凇拼音的配置文件

        ```sh
        vim ~/.local/share/fcitx5/rime/rime_ice.custom.yaml
        ```

      写入：

        ```yaml
        patch:
          "grammar/language": wanxiang-lts-zh-hans
        ```

    - 重启输入法生效

### 配置输入法环境变量

- 通用场景

  ```sh
  mkdir -p ~/.config/environment.d/
  vim ~/.config/environment.d/ime.conf
  ```

  ```conf
  # 支持 XIM 协议的 XWayland 应用走 XIM
  XMODIFIERS=@im=fcitx
  
  # QT6.7 及以后的应用能走Wayland走Wayland，走不了 Wayland 走 Qt 的输入法模块
  QT_IM_MODULES="wayland;fcitx"
  
  # 其他 Qt 应用走 Qt 的输入法模块
  QT_IM_MODULE=fcitx
  
  # 在合成器不提供 v3 时生效，让 SDL 改用 D-Bus 和输入法通信。
  SDL_IM_MODULE=fcitx
  ```

  > 除了这里，如果使用 niri 或 hyprland，可以在配置文件中写入环境变量。

- Electron 和 GTK2.0 应用

  > 原理：编辑 gtk2.0 的配置文件，让 XWayland 运行的 GTK2.0 应用走 GTK 的输入法模块

  ```sh
  vim ~/.gtkrc-2.0
  ```

  ```text
  gtk-im-module="fcitx"
  ```

- GTK3.0

  ```sh
  mkdir -p ~/.config/gtk-3.0
  vim ~/.config/gtk-3.0/settings.ini
  ```

  ```ini
  [Settings]
  gtk-im-module=fcitx
  ```

- GTK4.0

  ```sh
  mkdir -p ~/.config/gtk-4.0
  vim ~/.config/gtk-4.0/settings.ini
  ```

  ```ini
  [Settings]
  gtk-im-module=fcitx
  ```
