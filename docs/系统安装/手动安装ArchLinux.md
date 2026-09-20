# 手动安装ArchLinux

本文介绍 ArchLinux 的安装流程，完成后将得到一个最基础的不带图形界面的系统。

主要参考以下教程：

- [手动安装 - Shorin-ArchLinux-Guide](https://github.com/SHORiN-KiWATA/Shorin-ArchLinux-Guide/blob/main/wiki/archlinux/安装ArchLinux.md#手动安装) | [省流版](https://github.com/SHORiN-KiWATA/Shorin-ArchLinux-Guide/blob/main/wiki/archlinux/手动安装省流版.md)
- [安装指南 - Arch Linux 中文维基](https://wiki.archlinuxcn.org/wiki/安装指南)

## 1. 准备工作

首先根据[这篇教程](https://github.com/SHORiN-KiWATA/Shorin-ArchLinux-Guide/blob/main/wiki/安装任意Linux系统的前期准备工作.md)做好前期准备。然后

重启加载 ISO 进入 livecd 环境，你会以 root 身份进入一个终端环境，默认的 shell 是 zsh。

### 确认引导模式

为了确认引导模式，需检查 UEFI 固件位数

```sh
cat /sys/firmware/efi/fw_platform_size
```

- 如果输出 `64`，说明主板是 64 位 x64 UEFI 固件
- 如果输出 `32`，说明是 32 位 UEFI，后续的引导程序只能用 systemd-boot 或 GRUB
- 如果输出 `No such file or directory`，说明是 BIOS 固件或者是未经设置的虚拟机。

  > 如果是虚拟机，推荐在虚拟机设置里调整为 UEFI

### 连接网络

- 有线网自动连接，还可以用数据线分享手机网络

- 连wifi：使用 `iwctl` 命令连接 wifi（此命令由 `iwd` 提供）

  ```sh
  iwctl
  ```

  连接：

  ```sh
  device list #列出设备

  station wlan0 scan #扫描网络

  station wlan0 get-networks #列出所有扫描的wifi

  station wlan0 connect 【此处是你的wifi名字（不能是中文）】
  ```

  退出 iwctl：

  ```sh
  exit
  ```

- 确认网络

  ```sh
  ip a #查看网络连接信息，如果出现了紫色的 ip 地址说明成功连接
  ping -c 3 bilibili.com #确认网络正常
  ```

### 设置临时远程登录（可选）

为了方便复制粘贴命令，可以在通过 ssh 在局域网其他设备登录本机的 livecd 环境。

1. 获得本机 ip 地址

   ```sh
   ip a
   ```

   有线网注意 `enp` 开头的内容，无线网注意 `wlan` 开头的内容。`inet` 字段的紫色部分即为 ip 地址

2. 设置 root 密码：

   ```sh
   passwd
   ```

3. 确认 sshd 服务开启：

   ```sh
   systemctl status sshd
   ```

   确认 `Active` 字段处显示绿色的 `active (running)`，如果不是，执行：

   ```sh
   systemctl start sshd
   ```

4. 在局域网其他设备通过以下命令登录：

   ```sh
   ssh root@设备ip地址
   ```

   第一次登录提示是否要连接未知主机，输入 yes，然后根据提示输入刚刚设置的密码

为了后续能正常登录，完成系统安装后，将局域网其他设备的 `~/.ssh/known_hosts` 中，与本机 ip 相关的记录行删除

### 确认系统时间同步

执行以下命令，确认 NTP （网络时间协议）开启：

```sh
timedatectl
```

应该看到：

```
NTP service: active
```

如果没有则需要手动开启：

```sh
timedatectl set-ntp true
```

### 自动设置镜像源

用 `reflector` 配置最快最新的软件镜像源：

```sh
reflector -p https -a 12 -c cn --v --sort rate --save /etc/pacman.d/mirrorlist
```

<details><summary>参数说明</summary>

```
# -p（protocol） https 指定 https 协议的链接
# -a（age） 12 指定最近 12 小时更新过的源
# -c（country） cn 指定国家为中国（可以增加邻国）
# --v（verbose） 过程可视化
# --sort rate 按照下载速度排序（经过前面几道筛选，镜像源通常已经足够稳定，所以这里直接按照速度排序即可）
# --save /etc/pacman.d/mirrorlist 将结果保存到 /etc/pacman.d/mirrorlist
```

</details>

然后同步软件列表数据：

```sh
pacman -Sy
```

### 创建硬盘分区

查看当前分区情况：

```sh
lsblk -pf  #查看当前分区情况
fdisk -l /dev/想要查询详细情况的硬盘  #小写字母l，查看详细分区信息
```

然后用分区工具修改分区表，推荐用 `cfdisk`，比较简单：

```sh
cfdisk /dev/要被分区的磁盘   # 如 /dev/sda, /dev/nvme0n1
```

分区说明：

1. 新硬盘会弹出选项，选 gpt

2. 创建 EFI 分区

   上下方向键选中空闲空间，左右方向键选择 NEW 创建 512MB 或 1GB 的分区，类型（type）选择 EFI System。

   <details><summary>如果类型里没有 EFI system</summary>

   说明你的硬盘不是 GPT 分区表，可以使用

   ```sh
   cfdisk -z 设备名
   ```

   以空分区表打开硬盘，然后选择 GPT。

   > ⚠️警告⚠️ 这个操作会清空硬盘上的分区。

   </details>

3. （可选）创建 swap 分区

   创建交换空间的方式有好几种，有一种就行：swap 分区、swap 文件和内存 swap（zram）。

   需要的话创建 4GB 的 Linux Swap 分区。我一般不创建。

4. 创建 root 分区

   其余空间全部分到一个分区里，类型 linux filesystem 不需要更改。

5. 保存

   选择 `write`，输入 yes 保存。`quit` 退出。

之后可以用上面的命令再次确认分区情况。

### 分区格式化和挂载

创建分区后，必须使用合适的[文件系统](https://wiki.archlinuxcn.org/wiki/文件系统)对新创建的分区进行格式化。

<details><summary>常用的文件系统格式</summary>

- [ext4](https://wiki.archlinuxcn.org/wiki/Ext4)：最常用的文件系统格式。简单、稳定、性能好。缺点是没有快照、透明压缩等好用的现代特性。
- [btrfs](https://wiki.archlinuxcn.org/wiki/Btrfs)：新一代文件系统格式。拥有快照、透明压缩等现代特性，非常契合 archlinux，缺点是稳定性和性能稍差于 ext4。

</details>

> 我的建议：日常使用更推荐 btrfs，有快照可以随时回档，不怕滚挂。如果想简单一点，不需要快照等功能，追求性能就选 ext4。

👉 各文件系统的格式化和挂载方法：

- [btrfs分区格式化与挂载](./btrfs分区格式化与挂载.md)
- [ext4分区格式化与挂载](./ext4分区格式化与挂载.md)

## 2. 开始安装系统

### 安装必需软件包

- 基本包和固件

  ```sh
  pacstrap -K /mnt base linux-firmware
  ```

- linux内核包。任选其一即可，后期可以替换：

  ```sh
  # stable内核
  pacstrap -K /mnt linux linux-headers

  # zen内核
  pacstrap -K /mnt linux-zen linux-zen-headers

  # lts内核
  pacstrap -K /mnt linux-lts linux-lts-headers
  ```

  > `linux` 是主线内核，`linux-zen` 性能更好但可能不稳定，`linux-lts` 稳定但没那么新。

  ❗需要注意的是 `linux` 和 `linux-zen` 这两个内核会相互冲突，不能同时安装。

- 内核微码。用于修复和优化 cpu，根据 cpu 选择

  ```sh
  # intel装这个
  pacstrap -K /mnt intel-ucode

  # amd装这个
  pacstrap -K /mnt amd-ucode
  ```

- 特定文件系统的管理工具。

  ```sh
  # 如果使用 btrfs
  pacstrap -K /mnt btrfs-progs
  ```

- 权限管理和网络管理工具

  ```sh
  pacstrap -K /mnt sudo networkmanager
  ```

- 文本编辑器。推荐 `gvim`

  ```sh
  # 建议安装功能更完备的 gvim，也提供了vim命令
  pacstrap -K /mnt gvim

  # 或者，原版vim
  pacstrap -K /mnt vim
  ```

  > `gvim` 提供了更多的功能，包含了 `vim` 的全部功能，两者不能同时安装。

- 可选：如果在远程使用 kitty 终端访问本机，可以安装一个 `kitty-terminfo` 消除相关报错：

  ```sh
  pacstrap -K /mnt kitty-terminfo
  ```

### 生成fstab文件

系统会根据 fstab 中的内容自动进行挂载。

```sh
genfstab -U /mnt > /mnt/etc/fstab
```

<details><summary>参数说明</summary>

```sh
# genfstab（生成文件系统表）
# -U 用 UUID 指定分区
# > 大于号代表输出结果覆盖写入到右边的文件里
# 如果是 >> 两个大于号则代表追加写入
```

</details>

检查生成的fstab文件：

```sh
cat /mnt/etc/fstab
```

## 3. 配置系统

### chroot进入新系统

```sh
arch-chroot /mnt
```

此时根目录从 Live 环境变成了 `/mnt`，可以注意到提示符的变化。

### 设置时区和时间

设置时区：

```sh
timedatectl set-timezone Asia/Shanghai
```

> <details><summary>等价命令——手动创建链接</summary>
>
> ```sh
> ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
>
> # ln 是 link 的缩写
> # -s 代表跨文件系统的软链接
> # -f 代表强制执行
> ```
>
> </details>

同步硬件时间：

```sh
hwclock --systohc
```

### 本地化设置

1. 编辑配置文件

   ```sh
   vim /etc/locale.gen
   ```

   取消 `en_US.UTF-8 UTF-8` 和 `zh_CN.UTF-8 UTF-8` 两行的注释

2. 生成本地化配置

   ```sh
   locale-gen
   ```

3. 设置系统语言为英文

   ```sh
   vim /etc/locale.conf
   ```

   ```
   LANG=en_US.UTF-8
   ```

   暂时设为英文避免文字显示的 bug

### 设置主机名

```sh
vim /etc/hostname
```

### 设置 root 密码

```sh
passwd
```

### 安装引导程序

根据 EFI 挂载点和个人需求的不同，bootloader的选择也会不同。[bootloader](https://wiki.archlinuxcn.org/wiki/Arch_的启动流程#引导加载程序) 的选择有很多，最常用的是 [GRUB](https://wiki.archlinuxcn.org/wiki/GRUB)，选择一种安装即可。

👉 常用 bootloader 的安装教程：

- [安装 GRUB 引导](./安装GRUB引导.md)
- [安装 systemd-boot 引导](./安装systemd-boot引导.md)

### 配置ZRAM（内存swap）

ZRAM 将内存的部分空间用作交换空间，如果你没有配置 Swap，请一定配置 ZRAM。

1. 安装 `zram-generator`

   ```sh
   pacman -S zram-generator
   ```

2. 编辑配置文件

   ```sh
   vim /etc/systemd/zram-generator.conf
   ```

   ```conf
   [zram0]
   zram-size = ram
   compression-algorithm = zstd
   ```

3. 禁用 zswap

   zswap 是 Swap 的缓存。需要交换的数据在存入交换空间之前会先被 zswap 压缩后暂时放进内存里。和 ZRAM 功能重复且引入了复杂性，故禁用。

   - 如果用的是 GRUB 引导

     编辑配置文件：

     ```sh
     vim /etc/default/grub
     ```

     在 `GRUB_CMDLINE_LINUX_DEFAULT=""` 里写入 `zswap.enabled=0`

     ```sh
     GRUB_CMDLINE_LINUX_DEFAULT="... zswap.enabled=0 ..."
     ```

     重新生成 GRUB 配置文件

     ```sh
     grub-mkconfig -o /boot/grub/grub.cfg
     ```

   - 如果用的是 systemd-boot 引导

     编辑系统引导文件：

     ```sh
     vim /boot/loader/entries/arch.conf
     ```

     在 `options` 选项后添加 `zswap.enabled=0`

### 启用网络服务

开启新系统的 NetworkManager 服务，注意大小写。

```sh
systemctl enable NetworkManager
```

#### 可选：将网络后端替换为 `iwd`

将 NetworkManager 的后端从默认的 `wpa_supplicant` 替换为更现代的 `iwd`。

> 注意：部分设备更换 `iwd` 后端可能无法正常联网。

1. 安装 `iwd`

   ```sh
   pacman -S iwd
   ```

   > 注：`impala` 是 `iwd` 的 TUI

2. 编辑配置文件

   ```sh
   mkdir -p /etc/NetworkManager/conf.d
   vim /etc/NetworkManager/conf.d/iwd.conf
   ```

   写入：

   ```conf
   [device]
   wifi.backend=iwd
   ```

### 可选：配置SSH服务

如果后续需要通过远程连接到本机，可以现在配置好 ssh 服务。

1. 安装 `openssh`

   ```sh
   pacman -S openssh
   ```

2. 编辑 ssh 配置文件

   ```sh
   vim /etc/ssh/sshd_config
   ```

   ```
   # 取消下面几行的注释
   AllowAgentForwarding yes
   AllowTcpForwarding yes
   TCPKeppAlive yes
   PasswordAuthentication yes

   # 取消注释，将值改为yes
   PermitRootLogin yes
   ```

3. 将 ssh 服务设为开机自启

   ```sh
   systemctl enable sshd
   ```

### 设置全局默认编辑器

通过 `EDITOR` 变量设置默认编辑器。

如果不设置的话有些程序会默认调用 `vi` 编辑器。Arch 默认是没有安装 `vi` 的，会报错。

```sh
vim /etc/environment
```

```
EDITOR=vim
```

填入自己的编辑器。如果 vim 的话就是 vim，neovim 就是 nvim

### 重启

退出 chroot：

```sh
exit
```

重启电脑：

```sh
reboot
```

如果 U 盘没拔掉的话记得拔掉。

顺利的话会在 BIOS 启动项中出现之前配置的系统启动项，选择它。

## 4. 初次重启后的配置

重启后，以 root 登录系统

### 登录后连接网络

1. 验证是否有网：

   ```sh
   ip a
   ping -c 3 bilibili.com
   ```

2. 连接 wifi：

   ```sh
   nmtui
   ```

   选择 `activate a connection` 连接 wifi，按 esc 退出

### 创建普通用户

很多软件会拒绝在 root 权限下运行，所以普通用户是必须的。

1. 新建sudo用户

   ```sh
   useradd -mG wheel 你的用户名
   ```

   > `-m` 表示为新用户创建 home 目录；`-G` 设置组。

2. 设置密码

   ```sh
   passwd 你的用户名
   ```

3. 编辑权限

   ```sh
   visudo
   ```

   搜索 `wheel`，取消注释：

   ```
   %wheel ALL=(ALL:ALL) ALL
   ```

4. 退出 root 使用普通用户登录

   ```sh
   exit
   ```

   接下来需要管理员权限运行的命令要加上 `sudo`。

### 开启32位源

运行 Windows 软件通常需要各种 32 位的依赖，想玩游戏的话 Steam 客户端也在 32 位源里，所以建议开启 32 位源。

1. 编辑 pacman 配置文件

   ```sh
   sudo vim /etc/pacman.conf
   ```

   去掉 `[multilib]` 两行的注释：

   ```conf
   [multilib]
   Include = /etc/pacman.d/mirrorlist
   ```

2. 同步数据库

   ```sh
   sudo pacman -Syu
   ```

### archlinuxcn源

archlinuxcn源包含了很多好用的软件包。

1. 编辑 pacman 配置文件

   ```sh
   sudo vim /etc/pacman.conf
   ```

   在底部写入：

   ```
   [archlinuxcn]
   Server = https://mirrors.ustc.edu.cn/archlinuxcn/$arch
   Server = https://mirrors.tuna.tsinghua.edu.cn/archlinuxcn/$arch
   ```

   这两个是国内源，如果你在海外也可以直接用官方源：

   ```
   [archlinuxcn]
   Server = https://repo.archlinuxcn.org/$arch
   ```

2. 同步数据库并安装 archlinuxcn 密钥

   ```sh
   sudo pacman -Sy archlinuxcn-keyring
   sudo pacman -Syu
   ```

### AUR助手

AUR 是 Arch 最强大的软件仓库，AUR助手用于从 AUR 安装软件。

常用的 AUR 助手有 `yay` 和 `paru`，任选其一即可：

```sh
# 安装paru
sudo pacman -S base-devel paru

# 安装 yay
sudo pacman -S base-devel yay
```

### 安装字体

安装常用字体包：

```sh
sudo pacman -S noto-fonts noto-fonts-cjk noto-fonts-emoji ttf-jetbrains-mono-nerd
```

<details><summary>说明</summary>

- `noto-fonts` 包含大部分外文字体。
- `noto-fonts-cjk` 最常用的中日韩字体。但是因为同时包含中日韩，所以不正确设置系统字体的话会出现中文以日文的字体显示之类问题
- `noto-fonts-emoji` emoji 表情
- `ttf-jetbrains-mono-nerd` 最常用的等宽字体，包含字符字体，用于终端字体显示。

</details>

#### 字体设置

> 参考：[字体设置 - Shorin-ArchLinux-Guide](https://github.com/SHORiN-KiWATA/Shorin-ArchLinux-Guide/blob/main/wiki/archlinux/附录.md#字体设置)

<details><summary>字体分类</summary>

- 非衬线字体（sans-serif）：主要用于界面文字之类的场景。
- 衬线字体（serif）：主要用于文书编辑之类的场景。
- 等宽字体（monospace）：主要用于编程开发、终端之类的场景。

</details>

以下是一个 fontconfig 的示例，设置了三种字体类型具体使用哪些字体，可以解决大多数字体异常。

1. 编辑配置文件

   ```sh
   mkdir -p ~/.config/fontconfig
   vim ~/.config/fontconfig/fonts.conf
   ```

   ```xml
   <?xml version="1.0"?>
   <!DOCTYPE fontconfig SYSTEM "urn:fontconfig:fonts.dtd">
   <fontconfig>

       <match target="font">
           <edit name="antialias" mode="assign"><bool>true</bool></edit>
           <edit name="hinting" mode="assign"><bool>true</bool></edit>
           <edit name="hintstyle" mode="assign"><const>hintslight</const></edit>
           <edit name="rgba" mode="assign"><const>rgb</const></edit>
           <edit name="lcdfilter" mode="assign"><const>lcddefault</const></edit>
       </match>

       <alias>
           <family>sans-serif</family>
           <prefer>
               <family>Noto Sans</family>
               <family>Noto Sans CJK SC</family>
               <family>Adwaita Sans</family>
           </prefer>
       </alias>

       <alias>
           <family>serif</family>
           <prefer>
               <family>Noto Sans</family>
               <family>Noto Sans CJK SC</family>
               <family>Adwaita Sans</family>
           </prefer>
       </alias>

       <alias>
           <family>monospace</family>
           <prefer>
               <family>JetBrains Mono</family>
               <family>JetBrains Maple Mono</family>
               <family>Adwaita Mono</family>
           </prefer>
       </alias>

   </fontconfig>
   ```

2. 刷新字体缓存

   ```sh
   fc-cache -fv
   ```

### 音视频固件和服务

让音频设备和屏幕分享正常工作。

1. 安装音视频固件

   ```sh
   sudo pacman -S sof-firmware alsa-ucm-conf alsa-firmware
   ```

    <details><summary>说明</summary>

   _
   - `sof-firmware` 为现代音视频设备提供固件
   - `alsa-ucm-conf` 提供必要的配置文件
   - `alsa-firmware` 为不常见或者较旧的设备提供固件

    </details>

2. 安装音视频服务

   ```sh
   sudo pacman -S pipewire wireplumber pipewire-pulse pipewire-alsa pipewire-jack
   ```

   <details><summary>说明</summary>

   _
   - `pipewire` 是由 Red Hat 主导开发的现代音视频服务。
   - `wireplumber` 会智能管理 pipewire。
   - `pipewire-pulse`、`pipewire-alsa`、`pipewire-jack` 分别为 PulseAudio、ALSA、JACK 提供兼容。

   </details>

3. 启用服务

   ```sh
   systemctl --user enable --now pipewire pipewire-pulse wireplumber
   ```

### 性能模式切换

`power-profiles-daemon` 是各个桌面环境通用的性能模式切换服务，有三个档位，performance 性能、balance 平衡、powersave 省电。

1. 安装：

   ```sh
   sudo pacman -S power-profiles-daemon
   ```

2. 启动服务：

   ```sh
   sudo systemctl enable --now power-profiles-daemon
   ```

### 蓝牙

1. 安装

   ```sh
   sudo pacman -S bluez
   ```

2. 启动服务

   ```sh
   sudo systemctl enable --now bluetooth
   ```

### Flatpak软件

Flatpak 是全发行版通用的打包方式。依赖和插件比较多的软件 Flatpak 版本通常更好用，比如 OBS 和 Easyeffects。如果 AUR 和仓库的软件都不太正常，也可以尝试 Flatpak 版本。

1. 安装 flatpak

   ```sh
   sudo pacman -S flatpak
   ```

2. 可选：更换国内源

   - 上交大源

     ```sh
     sudo flatpak remote-modify flathub --url=https://mirror.sjtu.edu.cn/flathub
     ```

   - 中科大源

     ```sh
     sudo flatpak remote-modify flathub --url=https://mirrors.ustc.edu.cn/flathub
     ```

### 可选：休眠到硬盘

如果需要休眠到硬盘功能，且之前设置了硬盘 swap 的话。

1. 查看 `/etc/mkinitcpio.conf` 这个文件的 `HOOKS` 部分

   ```sh
   grep ^HOOKS /etc/mkinitcpio.conf
   ```

   如果是 `HOOKS(base systemd ...)` 的话无需配置

2. 如果是 `HOOKS(base udev ...)` 的话

   - 添加 hook：

     ```sh
     sudo vim /etc/mkinitcpio.conf
     ```

     在 `HOOKS()` 内添加 `resume`，注意需要添加在 `udev` 的后面。

   - 重新生成 initramfs

     ```sh
     sudo mkinitcpio -P
     ```

   - 重启电脑

     ```sh
     reboot
     ```

之后就能使用命令休眠了：

```sh
systemctl hibernate
```

### 再次重启

再次重启使配置生效

```sh
reboot
```

> 顺便一提，`poweroff` 关机、`suspend` 挂起到内存
