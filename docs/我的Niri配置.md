# 我的Niri配置

我的 Niri 桌面是用 shorin 的[一键配置脚本](https://github.com/SHORiN-KiWATA/Shorin-ArchLinux-Guide/wiki/一键配置桌面环境)安装和配置的，选的是 Niri+[DMS](https://danklinux.com/) 方案，功能齐全且简约美观。

一些介绍：

- [Niri](https://github.com/niri-wm/niri)：Niri 是一个可滚动的平铺式 Wayland 合成器，资源占用低，但是需要大量的手动配置。
- [DMS](https://danklinux.com/)：一个集成了完整桌面功能的 Desktop Shell，提供了类似于 GNOME 的桌面体验，开箱即用，且资源占用比其他主流 QuickShell 配置低很多。完美适配Niri。

可以看看这个视频的介绍：[【Arch零门槛】绝美Linux桌面，一键安装Niri+DMS](https://www.bilibili.com/video/BV1CHZaBrEF6/)

## 安装过程

1. 首先安装 Archlinux，安装快照工具，安装必要的命令行工具之后，创建一个快照作为存档点。详情见：[ArchLinux安装配置指南](./ArchLinux安装配置指南.md)。

2. （可选）配置网络代理，确保安装过程中可以顺利下载所需的软件包，参见[透明代理](https://github.com/SHORiN-KiWATA/Shorin-ArchLinux-Guide/wiki/代理)。

   个人觉得最方便的是 [daed](https://github.com/daeuniverse/daed)，用 `pacman` 安装，启动服务之后，用处于同一局域网的设备访问 `http://<IP_ADDRESS>:2023`，填入订阅链接，然后就可以开启代理了。详情请看[这个教程](https://github.com/SHORiN-KiWATA/Shorin-ArchLinux-Guide/wiki/代理#daed)。

3. 检查时区为 'Asia/Shanghai'
  
    ```sh
    timedatectl
    ```

    如果不是则需要设置一下：

    ```sh
    sudo timedatectl set-timezone Asia/Shanghai
    hwclock --systohc
    ```

4. 运行 shorin 的[一键配置脚本](https://github.com/SHORiN-KiWATA/Shorin-ArchLinux-Guide/wiki/一键配置桌面环境)，选择 Niri+DMS 方案，根据提示完成安装。

    如果需要资源占用更低的配置，可以选择 Shorin's Niri 方案，这个方案基于 [Waybar](https://waybar.org/)，由 [shorin](https://github.com/SHORiN-KiWATA/Shorin-ArchLinux-Guide/wiki/一键配置桌面环境#shorins-niri-功能介绍) 亲自维护。

## 我的配置

👉 配置前强烈建议先看看使用说明：`~/必看-Shorin-DMS-Niri使用方法.txt`。

### 更换浏览器

- 我比较喜欢 brave，这里是安装命令：

  ```sh
  sudo pacman -S brave-bin
  ```

  同时卸载 firefox：

  ```sh
  sudo pacman -Rns firefox
  ```

- 然后修改浏览器相关的快捷键（DMS-Niri的默认设置在 `~/.config/niri/dms/binds.kdl` 里）：

  ```kdl
  //打开浏览器
  Mod+B hotkey-overlay-title="浏览器 Browser" { spawn "brave"; }
  ```

### 卸载预装软件

根据[预装软件列表](httpsz://github.com/SHORiN-KiWATA/Shorin-ArchLinux-Guide/wiki/一键配置桌面环境#软件列表)，按自己的需要卸载预装软件

- 日文输入法：

  ```sh
  sudo pacman -Rns fcitx5-mozc
  ```

- 通讯软件，个人不是很需要

  ```sh
  # QQ、微信
  sudo pacman -Rns linuxqq-appimage wechat-appimage
  ```

- 代理软件，我用的是 daed，可以把预装的 flclash 卸载掉：

  ```sh
  sudo pacman -Rns flclash-bin
  ```

### 修改输入法预设

- 修改输入法切换按键

    默认是 `Super+空格`，我更习惯 `Ctrl+空格`

    修改方法：`Super+z`打开应用启动器 > 搜索 `Fcitx 5 配置` > 全局选项 > 设置快捷键

- 添加输入法方案

    切换至中文输入法后，按 F4 呼出方案选择菜单，选择需要的输入法。如果里面没有，参考[这篇文档](https://github.com/SHORiN-KiWATA/Shorin-ArchLinux-Guide/wiki/中文输入法#fcitx5)，添加自己要的输入法方案。

    大致过程：

    1. 用 `ls /usr/share/rime-data/*.schema.yaml` 看当前所有可用方案，去掉文件名的`.schema.yaml`就是方案名字
    2. 编辑输入法配置文件

        ```sh
        vim /home/dai/.local/share/fcitx5/rime/default.custom.yaml
        ```

        例如：

        ```yaml
          patch:
            schema_list:
              - schema: luna_pinyin_simp
              - schema: rime_ice
              - schema: double_pinyin_flypy
              - schema: wubi86
              # 添加方案，如自然码双拼
              - schema: double_pinyin
        ```

### 修改Niri配置

Niri 的配置文件在 `~/.config/niri/` 目录下，入口文件是 `config.kdl`，还有一些配置文件在 `~/.config/niri/dms/` 目录下。

我的习惯是在 `~/.config/niri/` 下创建一个 `my-config.kdl` 文件，专门用来放一些自定义的配置，然后在 `config.kdl` 里最后引入这个文件以覆盖默认配置：

```kdl
// ~/.config/niri/config.kdl

// 在最底下引入自定义配置
include "my-config.kdl"
```

我的配置：

```kdl
// ~/.config/niri/my-config.kdl

//-- 环境变量
environment {
    // GTK软件使用的渲染器，可以解决n卡双显卡导致的GTK应用启动缓慢问题，AMD或Intel单显卡不需要这行设置可以注释掉
    GSK_RENDERER "gl"
    // 默认文本编辑器
    EDITOR "nvim"
}


//-- 窗口规则
// 默认窗口浮动
window-rule {
    // 浏览器画中画插件
    match title="- PIP"
    open-floating true
}


//-- 快捷键
binds {
    //打开浏览器
    Mod+B hotkey-overlay-title="浏览器 Browser" { spawn "brave"; }
    // 切换总览
    Mod+Escape repeat=false { toggle-overview; }
}
```

### 可选：使用自己的starship配置

默认情况下，matugen会自动修改终端的 starship 颜色配置，会覆盖starship配置文件（`~/.config/starship.toml`）。如果希望使用自己的starship配置，需要编辑 matugen 的配置：

```sh
vim ~/.config/matugen/config.toml
```

用 `#` 注释以下内容：

```toml
[templates.starship]
input_path = '~/.config/matugen/templates/starship-colors.toml'
output_path = '~/.config/starship.toml'
```

### 可选：与Shorin的配置同步

> **注：目前不再推荐**

如果希望与 Shorin 的配置保持同步，同时希望保留自己的自定义配置。可以按下面的步骤来：

1. 克隆 Shorin 的配置仓库到本地，放在 `~/.local/share/` 目录下：

   ```sh
   git clone https://github.com/SHORiN-KiWATA/shorin-arch-setup.git ~/.local/share/shorin-arch-setup
   ```

2. 备份自己的配置文件和相关目录：

   ```sh
   mv ~/.config/niri ~/.config/niri-bak
   ```

3. 创建符号链接，将 Shorin 的配置链接到本地配置目录：

   ```sh
   # 链接 Niri 的配置
   ln -s  ~/.local/share/shorin-arch-setup/dms-dotfiles/.config/niri ~/.config/niri
   ```

4. 按需修改配置。尽量少修改已有的配置文件，推荐通过新建配置文件的方式进行修改，这样可以更方便地与远程仓库的配置同步。

5. 创建 `~/.config/niri/scripts/sync-modify.sh` 脚本，从我的仓库复制[脚本内容](../dms-niri-dotfiles/.config/niri/scripts/sync-modify.sh)。

   ```sh
   vim ~/.config/niri/scripts/sync-modify.sh
   ```

   赋予执行权限：

   ```sh
   chmod +x ~/.config/niri/scripts/sync-modify.sh
   ```

6. 然后再创建 `~/.config/niri/scripts/shorin-sync.sh` 脚本（也可以从[我的仓库](../dms-niri-dotfiles/.config/niri/scripts/shorin-sync.sh)里直接复制），内容如下：

   ```sh
   #!/usr/bin/env bash

   PWD=$(pwd)
   SHORIN_DIR="$HOME/.local/share/shorin-arch-setup"
   SYNC_SCRIPT="$HOME/.config/niri/scripts/sync-modify.sh"

   cd $SHORIN_DIR
   source $SYNC_SCRIPT
   cd $PWD
   ```

   赋予执行权限：

   ```sh
   chmod +x ~/.config/niri/scripts/shorin-sync.sh
   ```

7. 链接到 `~/.local/bin/` 目录下，去掉拓展名以方便调用：

   ```sh
   ln -s ~/.config/niri/scripts/shorin-sync.sh ~/.local/bin/shorin-sync
   ```

之后每次想要同步 Shorin 远程仓库的配置时，只需要运行 `shorin-sync` 命令即可。这个脚本会自动将 Shorin 的配置与本地的配置进行合并，保留用户的自定义修改，同时更新 Shorin 的最新配置。

> 原理：为本地的修改创建了一个 `my-custom` 分支，在每次同步时将远程的 `main` 分支合并到 `my-custom` 分支上。

## DMS设置

DMS 的设置界面在右上角，点击齿轮图标⚙️打开设置菜单。

### 设置待机行为

右上角打开DMS设置 > `电源与安全` > `电源与睡眠` > `待机` > 设置经过多久后锁屏/关闭显示器/挂起等。

### 个性化设置

- 设置时间显示格式：

    DMS设置 > `个性化` > `时间与天气` > `日期格式` > `顶栏格式` 和 `锁屏格式` 改为 `日 月份 日期`

- 设置天气显示：

    DMS设置 > `个性化` > `时间与天气` > `天气` > `自定义位置` > `位置搜索` 用英文输入城市名称搜索

### 安装插件

DMS支持使用插件来扩展功能。

#### 插件安装方式

右上角打开DMS设置 > 在左侧栏里选择`插件` > `浏览` > 选择需要的插件安装。

在插件页面也可以管理已安装的插件，如启用/禁用、卸载等。

#### 推荐插件

- `Emoji & Unicode Launcher`：在启动器里输入 `:e` 即可搜索emoji表情和unicode字符，选中后会复制到剪贴板，非常方便。

## 其他设置

其他配置，如 shell配置、应用配置、编程环境设置等，参考我的配置仓库：[jalaxy33/tools](https://github.com/jalaxy33/tools)。
