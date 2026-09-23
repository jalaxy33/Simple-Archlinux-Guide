# Niri安装配置

## 0. 准备工作

本文假定读者已经按照[系统安装教程](../系统安装/手动安装ArchLinux.md)完成了 ArchLinux 基础系统的安装。在安装 Niri 桌面以前，有一些额外的准备工作：

- 如果是在虚拟机中安装 niri，有一些[额外设置](#vm-niri)，不然无法启动 niri 桌面。
- 如果你在国内，在安装 AUR 软件时可能遇到网络问题，参考[网络代理](../软件工具/proxy网络代理.md)文档。

## 1. 安装

### 安装基础软件包

```sh
sudo pacman -S --needed niri xwayland-satellite xdg-desktop-portal-gtk xfce4-settings nwg-look adw-gtk-theme
sudo pacman -S --needed xdg-desktop-portal-gnome --assume-installed nautilus
```

<details><summary>软件包说明</summary><br>

- `niri` 本体
- `xwayland-satellite` 提供在 wayland 上运行 x11 应用的兼容环境
- `xdg-desktop-portal-gtk` 提供文件选择功能
- `xdg-desktop-portal-gnome` 提供提供屏幕共享功能，用 `--assume-installed` 忽略该包提供的 nautilus 文件管理器
- `xfce4-settings` xfce桌面相关设置，可以用来设置默认应用程序
- `nwg-look` 用来管理 gtk 主题
- `adw-gtk-theme` gtk主题

</details>

### 安装文件管理器

niri 默认的文件管理器是 GNOME 的 `nautilus`，我更习惯用 XFCE 的 `thunar`。

安装 thunar 和其他有用的软件：

```sh
sudo pacman -S --needed thunar
sudo pacman -S --needed file-roller thunar-archive-plugin thunar-volman
sudo pacman -S --needed gvfs-smb gvfs-mtp gvfs-gphoto2
sudo pacman -S --needed tumbler ffmpegthumbnailer poppler-glib webp-pixbuf-loader icoextract python-pillow
```

<details><summary>软件包说明</summary><br>

基础功能：

- `thunar` 文件管理器本体
- `file-roller` 压缩解压
- `thunar-archive-plugin` 提供右键的压缩解压选项
- `thunar-volman` 自动管理移动硬盘等设备

文件系统拓展：

- `gvfs-smb` 检查可挂载的外部设备，访问 smb 分享等功能。
- `gvfs-mtp` 连接手机
- `gvfs-gphoto2` 连相机

缩略图：

- `tumbler` 图片预览
- `ffmpegthumbnailer` 视频预览
- `poppler-glib` PDF 预览
- `webp-pixbuf-loader` webp 缩略图
- `icoextract` `python-pillow` exe 缩略图

</details>

### 安装必备工具

```sh
sudo pacman -S --needed fish kitty fuzzel mpv imv satty wl-clipboard gnome-font-viewer
paru -S ttf-jetbrains-maple-mono-nf-xx-xx
```

<details><summary>软件包说明</summary><br>

- `fish` 用户友好的交互式 shell
- `kitty` 终端模拟器，我更习惯用这个，也可以用 niri 默认的 alacrity
- `fuzzel` 是 niri 默认的程序启动器
- `mpv` 视频播放器
- `imv` 图片查看器
- `satty` 截图编辑
- `wl-clipboard` 提供更丰富的剪贴板功能，配合实现截图编辑
- `gnome-font-viewer` 字体管理
- `ttf-jetbrains-maple-mono-nf-xx-xx` 等宽字体，用于 kitty 的字体配置

</details>

### 其他好用的软件

👉 查看以下文档：

- [CLI命令行工具推荐](../软件工具/CLI命令行工具推荐.md)
- [GUI软件推荐](../软件工具/GUI软件推荐.md)，如浏览器等

## 2. 安装桌面shell

Niri 默认状态相当简陋，可以安装 desktop shell 来获得开箱即用的配置，常用的有 [DMS](https://danklinux.com/) 和 [noctalia](https://noctalia.dev/) 等。

下面提供几种常用桌面shell的安装配置方法，我用的是 DMS。

### Dank Material Shell

[DMS](https://danklinux.com/) 是 niri 官方推荐的 desktop shell，基于 quickshell，设计美观，功能齐全，且资源占用很低，

安装 dms：

```sh
sudo pacman -S --needed dms-shell-niri
```

安装可选依赖：

```sh
sudo pacman -S --needed cava dgop matugen qt6-multimedia cups-pk-helper kimageformats
paru -S dankcalendar-bin dsearch-bin
```

<details><summary>软件包说明</summary><br>

- `cava` 音频可视化控件
- `dgop` 系统资源监控
- `matugen` 自动配色
- `qt6-multimedia` 系统声音支持
- `cups-pk-helper` 打印机服务
- `kimageformats` 图像格式拓展
- `dankcalendar-bin` 日历
- `dsearch-bin` 文件搜索服务

</details>

## 3. 配置Niri

### 编辑 niri 配置

niri 的配置文件在 `~/.config/niri/config.kdl`：

```sh
vim ~/.config/niri/config.kdl
```

### 可选：使用我的配置

如果想用我的配置

1. 安装 chezmoi：

   ```sh
   sudo pacman -S --needed chezmoi
   ```

2. 我的[命令行配置](https://github.com/jalaxy33/dotfiles)：

   初次加载

   ```sh
   chezmoi init --apply jalaxy33
   ```

   > <details><summary>如果你在国内</summary>
   >
   > ```sh
   > chezmoi init --apply https://gh-proxy.org/https://github.com/jalaxy33/dotfiles
   > ```
   >
   > </details>

   同步配置：

   ```sh
   chezmoi update
   ```

3. 我的 [niri 配置](https://github.com/jalaxy33/niri-dotfiles/)

   初次加载

   ```sh
   chezmoi init -S ~/.local/share/chezmoi-niri/ --apply https://github.com/jalaxy33/niri-dotfiles
   ```

   > <details><summary>如果你在国内</summary>
   >
   > ```sh
   > chezmoi init -S ~/.local/share/chezmoi-niri/ --apply https://gh-proxy.org/https://github.com/jalaxy33/niri-dotfiles
   > ```
   >
   > </details>

   同步配置：

   ```sh
   chezmoi update -S ~/.local/share/chezmoi-niri/
   ```

### 启动 niri 桌面

在 tty 界面执行以下命令启动 niri 桌面：

```sh
niri-session
```

默认情况下，按 `Super+Shift+/` 弹出按键提示。

## 4. 其他必要配置

### 配置桌面shell

<details>
<summary><strong>DMS 设置</strong></summary><br>

DMS 的设置界面在右上角，点击齿轮图标⚙️打开设置菜单。或者通过 `super+F2` 唤出。

- **状态栏设置**

  - 显示应用 Dock：

    `状态栏` > `部件` > `左侧区域` 添加「应用Dock」部件

- **设置锁屏和待机行为**

  - 设置待机时间：

    `电源与安全` > `电源与睡眠` > `待机设置` 设置经过多久后锁屏/关闭显示器/挂起等。

- **个性化设置**

  - 设置壁纸：

    `个性化` > `壁纸` 最上方方框

    推荐两个壁纸下载网址：[wallhaven.cc](https://wallhaven.cc/)、[哲风壁纸](https://haowallpaper.com/)

  - 取消模糊壁纸层

    `个性化` > `模糊壁纸层` > 关闭「带模糊效果的壁纸副本」

  - 设置天气显示：

    `个性化` > `时间与天气` > `天气` > `自定义位置` > `位置搜索` 用英文输入城市名称搜索

- 解决快捷键冲突

  dms启动器的默认快捷键 `Mod+Space` 可能与其他应用快捷键冲突（如 fcitx5）

  - `Dock和启动器` > `默认启动器` > `默认启动器快捷键` > 从底部 `快捷方式` 列表中删除 `Mod+Space` 的快捷键
  - 设置一个其他快捷键，我的习惯是 `Mod+Z`

- **安装插件**

  插件安装方式：`插件` > `浏览` > 选择 `显示第三方` > 选择需要的插件安装，安装后记得启用

  推荐插件：

  - `Emoji & Unicode Launcher`：在启动器里输入 `:e` 即可搜索emoji表情和unicode字符，选中后会复制到剪贴板，非常方便。
  - `Quick Capture`：方便的截图录屏部件，调用 dms 的截图功能，启用后在状态栏右侧区域添加一个「Quick Capture」部件
  - `Calculator`：为启动器添加计算器功能

</details>

### 配置文件管理器

<details>
<summary><strong>thunar 配置</strong></summary><br>

niri 默认的文件管理器是 GNOME 的 `nautilus`，但是我更喜欢 XFCE 的 `thunar`。功能强大，高度可自定义，且内存占用极低。

- 管理侧边栏书签
  - 添加书签：将目录图标拖到侧边栏相应位置
  - 移除书签：侧边栏空白处右键清理

- 设置总是显示缩略图

  左上角`编辑`菜单 > `首选项` > 将 `显示缩略图` 设为「总是」

- 隐藏菜单栏

  `视图` > 取消 `菜单栏`

- 右键从此处打开终端

  Thunar 提供了强大的自定义右键功能。点击左上角 `编辑` > `配置自定义动作` > 选中 `open in terminal here` > 点击小齿轮 > 命令改成 `kitty --single-instance`。

- 配置使用 Thunar 进行文件选取

  Niri 默认使用 GNOME 的桌面门户进行文件选取，需要调整为 GTK 配合 Thunar 使用：

  ```sh
  mkdir -p ~/.config/xdg-desktop-portal/
  vim ~/.config/xdg-desktop-portal/niri-portals.conf
  ```

  ```conf
  [preferred]
  default=gnome;gtk;
  org.freedesktop.impl.portal.Access=gtk;
  org.freedesktop.impl.portal.Notification=gtk;
  org.freedesktop.impl.portal.FileChooser=gtk;
  org.freedesktop.impl.portal.Secret=gnome-keyring;
  org.freedesktop.impl.portal.ScreenCast=gnome;
  org.freedesktop.impl.portal.Screenshot=gnome;
  ```

</details>

### 设置默认图片查看器

<details>
<summary><strong>将 imv 设为默认图片查看器</strong></summary><br>

imv 是轻量的图片查看器，下面介绍将 imv 设置为默认图片查看器的方法，其他看图软件同理。

`imv` 默认每次只打开一张图片，建议用 `imv-dir`，可以查看当前目录下的所有图片。

一条命令修改默认图片查看器为 `imv-dir`：

```sh
xdg-mime default imv-dir.desktop $(grep "^image/" /usr/share/mime/types)
```

另外，imv-dir 的默认排序不是自然排序，有时候可能会有问题。编辑 `/usr/bin/imv-dir`（不推荐）或者创建一个 `~/.local/bin/imv-dir` 并用 `chmod +x` 赋予执行权限，内容如下：

- 创建脚本

  ```sh
  mkdir -p ~/.local/bin
  vim ~/.local/bin/imv-dir
  ```

  ```sh
  #!/bin/sh -efu
  if [ $# -gw 2 ]; then
    exec imv "$@"
  else
    exec imv -n "$1" $(ls "$(dirname "$1")" | sort -n)
  fi
  ```

- 赋予执行权限：
  ```sh
  chmod +x ~/.local/bin/imv-dir
  ```

</details>

### 可选：设置暗色主题

- 安装管理软件和 GTK 主题：

  ```sh
  sudo pacman -S --needed nwg-look adw-gtk-theme
  ```

- 启动管理软件：

  ```sh
  nwg-look
  ```

  或者启动器搜索 `GTK Settings`

- 选择主题，推荐 `adw-gtk3-dark`

### 可选：配置登录管理器

如果不想每次都输入 `niri-session` 才进入桌面，可以安装一个[登录管理器](https://wiki.archlinuxcn.org/wiki/显示管理器)。

<details>

<summary><strong>ly 配置</strong></summary><br>

[Ly](https://codeberg.org/fairyglade/ly) 是一个轻量级的 TUI 登录管理器。

安装：

```sh
sudo pacman -S --needed ly
```

设置自启动（不要加 `--now` 参数否则会卡死）：

```sh
sudo systemctl enable ly@tty1
```

> 可能需要同时禁用 getty，新安装的系统通常不需要：
>
> ```sh
> sudo systemctl disable getty@tty1
> ```

</details>

## 附录

### 获取窗口信息

编辑 `window-rule` 窗口规则前，可以用以下命令获得指定窗口的信息：

```sh
niri msg pick-window
```

执行命令后，鼠标会变成十字，点击想查看的窗口显示 `app-id` 和 `title` 等信息。

### 设置默认应用程序

总的来说是两类方式：

<details>
<summary><strong>方式一：通过命令行设置</strong></summary><br>

最通用，无需 GUI 界面

- 查询当前默认查看器，例如查看 png 格式当前默认程序

  ```sh
  xdg-mime query default image/png
  ```

- 设置新的默认打开方式：

  ```sh
  xdg-mime default <应用.desktop> <MIME类型>
  ```

  例如，将 `imv-dir` 设为默认图片查看器：

  ```sh
  xdg-mime default imv-dir.desktop image/png image/jpeg image/gif image/bmp image/tiff

  # 更彻底的方法
  xdg-mime default imv-dir.desktop $(grep "^image/" /usr/share/mime/types)
  ```

</details>

<details>
<summary><strong>方式二：通过 GUI 设置</strong></summary><br>

通过安装 GNOME、KDE 或 Xfce 等桌面的「桌面设置」软件来设置默认应用程序。

既然安装了 xfce 的文件管理器，那就用它的设置程序好了：

```sh
sudo pacman -S --needed xfce4-settings
```

启动：

```sh
xfce4-settings-manager
```

找到「**默认应用程序**」，在「**其他**」选项卡从列表中选择应用并设为默认

</details>

### 在虚拟机中安装 Niri<a name="vm-niri"></a>

用虚拟机安装 niri 需要开启显卡的 3d 加速功能。KVM 有额外设置。

<details>
<summary><strong>在 KVM 中安装 Niri</strong></summary><br>

1. 首先确认核显编号：

```sh
spci -Dnnk | grep -A3 -iE "vga|3d|display controller"
```

命令输出类似于：

```sh
0000:00:02.0 Display controller [0380]: Intel Corporation Alder Lake-S GT1 [UHD Graphics 770] [8086:4680] (rev 0c)
  Subsystem: Dell Device [1028:0a9f]
  Kernel driver in use: i915
  Kernel modules: i915, xe
--
0000:01:00.0 VGA compatible controller [0300]: NVIDIA Corporation GA102 [GeForce RTX 3080 Lite Hash Rate] [10de:2216] (rev a1)
  Subsystem: Micro-Star International Co., Ltd. [MSI] Device [1462:3896]
  Kernel driver in use: nvidia
  Kernel modules: nouveau, nvidia_drm, nvidia
```

找到核显开头的编号，这里是 `0000:00:02.0`

2. 调整 virt-manager 的虚拟机设置：
   - 「显示协议 Spice」保持默认设置：「监听类型」为地址，不启用 OpenGL 选项
   - 「显卡 virtio」开启 3D 加速功能
   - 右下角选择「添加硬件」，点击「图形」，切换到 XML 编辑界面，手动编辑：

     ```xml
     <graphics type="egl-headless">
       <gl rendernode="/dev/dri/by-path/pci-0000:00:02.0-render"/>
     </graphics>
     ```

     记得改成自己的核显编号，保存后重启虚拟机。

</details>
