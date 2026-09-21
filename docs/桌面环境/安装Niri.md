# Niri安装配置

> 如果是在虚拟机中安装 niri，有一些[额外设置](#kvm-niri)，不然无法启动 niri 桌面。

## 1. 安装

### 安装基础软件包

```sh
sudo pacman -S --needed niri xwayland-satellite xdg-desktop-portal-gtk
sudo pacman -S --needed xdg-desktop-portal-gnome --assume-installed nautilus
```

<details><summary>软件包说明</summary><br>

- `niri` 本体
- `xwayland-satellite` 提供在 wayland 上运行 x11 应用的兼容环境
- `xdg-desktop-portal-gtk` 提供文件选择功能
- `xdg-desktop-portal-gnome` 提供提供屏幕共享功能，用 `--assume-installed` 忽略该包提供的 nautilus 文件管理器

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

### 安装其他必备软件

```sh
sudo pacman -S --needed kitty fuzzel satty wl-clipboard
paru -S ttf-jetbrains-maple-mono-nf-xx-xx
```

<details><summary>软件包说明</summary><br>

- `kitty` 终端模拟器，我更习惯用这个，也可以用 niri 默认的 alacrity
- `fuzzel` 是 niri 默认的程序启动器
- `satty` 截图编辑软件
- `wl-clipboard` 提供更丰富的剪贴板功能
- `ttf-jetbrains-maple-mono-nf-xx-xx` 等宽字体

</details>

可以再安装自己喜欢的浏览器，如 `firefox` 等，我习惯用 `brave`。

<details><summary>brave 浏览器安装方式</summary><br>

推荐去 AI 功能版，用 AUR 安装：
```sh
paru -S brave-origin-bin
```

网络环境不好的也可以安装原版
```sh
# 原版
sudo pacman -S --needed brave-bin
```

</details>

## 2. 安装预设配置（desktop shell）

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

👉 可以参考我的 [niri 配置](https://github.com/jalaxy33/niri-dotfiles)

### 启动 niri 桌面

在 tty 界面执行以下命令启动 niri 桌面：

```sh
niri-session
```

默认情况下，按 `Win+Shift+/` 弹出按键提示。

### 配置文件管理器

niri 默认的文件管理器是 GNOME 的 `nautilus`，但是我更喜欢 XFCE 的 `thunar`。功能强大，高度可自定义，且内存占用极低。

#### thunar

- 管理侧边栏书签
  - 添加书签：将目录图标拖到侧边栏相应位置
  - 移除书签：侧边栏空白处右键清理

- 设置总是显示缩略图

  左上角`编辑`菜单 > `首选项` > 将 `显示缩略图` 设为「总是」

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

### 可选：配置登录管理器

如果不想每次都输入 `niri-session` 才进入桌面，可以安装一个[登录管理器](https://wiki.archlinuxcn.org/wiki/显示管理器)。常用的有 `greetd` 和 `ly`，我用的是 ly。

#### ly 管理器

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

## 附录

### 在虚拟机中安装 Niri

<a name="kvm-niri"></a>

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
