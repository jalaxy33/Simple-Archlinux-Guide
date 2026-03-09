# ArchLinux安装配置指南

## 写在前面

本文基于 [Shorin-Archlinux-Guide](https://github.com/SHORiN-KiWATA/Shorin-ArchLinux-Guide) 提供的安装配置教程，重复的部分会略过，主要记录一些我在安装和配置过程中遇到的问题和解决方案，以及一些个人的理解和总结。

可以结合下面这些视频教程一起看，视频教程会更直观一些：

- [「Archlinux究极指南2025」从手动安装到显卡直通，最后删除Linux](https://www.bilibili.com/video/BV1L2gxzVEgs)
- [「Linux游戏指南」一次挑战与一场斗争](https://www.bilibili.com/video/BV1zyttzPEmp)
- [从「Linuxmint入门」到「ArchLinux安装详解」桌面端Linux入门的最佳路径](https://www.bilibili.com/video/BV19DBqB4EY4/)

[教程文档](https://github.com/SHORiN-KiWATA/Shorin-ArchLinux-Guide/wiki)写的很详细，推荐按照下面的步骤阅读。

## 1. 前期准备

概要：同步windows时间、准备系统盘、修改bios设置

👉 看这篇：[安装任意Linux系统的前期准备工作](https://github.com/SHORiN-KiWATA/Shorin-ArchLinux-Guide/wiki/安装任意Linux系统的前期准备工作)

## 2. 安装系统

两种方式：**手动安装**和**脚本安装**。

脚本安装方便，但是可能会遇到一些脚本无法处理的问题。推荐手动安装。

👉 教程：

- [手动安装](https://github.com/SHORiN-KiWATA/Shorin-ArchLinux-Guide/wiki/安装ArchLinux#手动安装)
- [脚本安装](https://github.com/SHORiN-KiWATA/Shorin-ArchLinux-Guide/wiki/安装ArchLinux#脚本安装)
- [手动安装省流版](https://github.com/SHORiN-KiWATA/Shorin-ArchLinux-Guide/wiki/手动安装省流版)：方便快速查阅

‼️ 如果你用的是手动安装，强烈建议你看看：[手动安装系统的注意事项](./手动安装系统的注意事项.md)

## 3. 前期配置

👉 直接看这篇就好：[安装桌面环境前的准备](https://github.com/SHORiN-KiWATA/Shorin-ArchLinux-Guide/wiki/安装桌面环境前的准备)

## 4. 安装快照

最重要的事情之一。推荐在安装系统后立即安装快照工具，并创建一个快照。这样可以在后续的安装过程中，如果遇到问题，可以直接回滚到这个快照，避免重新安装系统。

👉 看这篇：[快照和系统维护](https://github.com/SHORiN-KiWATA/Shorin-ArchLinux-Guide/wiki/快照和系统维护)

我的习惯：

1. 不安装 `snap-pac`；
2. 关闭时间线快照，手动管理快照：

   ```sh
   snapper -c root set-config TIMELINE_CREATE=no
   snapper -c home set-config TIMELINE_CREATE=no
   ```

## 5. 安装显卡驱动

建议在安装显卡驱动前创建快照，以便在出现问题时可以快速回滚到之前的系统状态。

👉 看这篇：[显卡驱动和硬件编解码](https://github.com/SHORiN-KiWATA/Shorin-ArchLinux-Guide/wiki/显卡驱动和硬件编解码)

其他卡都好说，如果是比较老的Nvidia显卡，参考 [archwiki](https://wiki.archlinux.org/title/NVIDIA)，用AUR助手安装对应的驱动，例如：

```sh
# 安装nvidia-580xx系列的dkms驱动
yay -S --needed nvidia-580xx-dkms nvidia-580xx-utils lib32-nvidia-580xx-utils
```

## 6. 安装命令行工具

👉 可以参考这篇文章，按需安装：[好用的命令行工具](./好用的命令行工具.md)

我还会额外安装一个 [JetBrains Maple Mono](https://github.com/SpaceTimee/Fusion-JetBrainsMapleMono) Nerdfont 字体：
```sh
yay -S --needed ttf-jetbrains-maple-mono-nf-xx-xx
```

## 7. 安装桌面环境

如果需要桌面环境，有两种选择：

1. **Desktop Environment桌面环境**（简称 DE）：如GNOME、KDE、XFCE等，功能全面，适合一般用户。
2. **Window Manager窗口管理器**（简称 WM）：如 hyprland、niri、sway 等，轻量级，适合高级用户和喜欢自定义的用户。

如果没有头绪的话建议从桌面环境上手，GNOME和KDE二选一就行。可以创建快照之后放心尝试想要的桌面环境。

👉 可以看看下面的教程：

- [安装桌面环境或窗口管理器](https://github.com/SHORiN-KiWATA/Shorin-ArchLinux-Guide/wiki/安装桌面环境或窗口管理器)：不知道怎么选可以看看这个。
- GNOME：[安装GNOME](https://github.com/SHORiN-KiWATA/Shorin-ArchLinux-Guide/wiki/安装GNOME)、[GNOME自定义设置](https://github.com/SHORiN-KiWATA/Shorin-ArchLinux-Guide/wiki/我的GNOME自定义设置)、[视频教程](https://www.bilibili.com/video/BV1L2gxzVEgs)
- KDE：[安装KDE](https://github.com/SHORiN-KiWATA/Shorin-ArchLinux-Guide/wiki/我的KDE自定义设置)、[KDE自定义设置](https://github.com/SHORiN-KiWATA/Shorin-ArchLinux-Guide/wiki/我的KDE自定义设置)、[视频教程看这里（从52分开始）](https://www.bilibili.com/video/BV19DBqB4EY4)
- Niri：[安装Niri](https://github.com/SHORiN-KiWATA/Shorin-ArchLinux-Guide/wiki/安装Niri)、[视频教程](https://www.bilibili.com/video/BV1fgUEBMEMZ/)
- Hyprland：[安装Hyprland](https://github.com/SHORiN-KiWATA/Shorin-ArchLinux-Guide/wiki/安装Hyprland)、[视频教程](https://www.bilibili.com/video/BV1wTsVzpET4)

🌟 如果不想自己配置，可以看看这个一键安装脚本（推荐！）：[一键配置桌面环境](https://github.com/SHORiN-KiWATA/Shorin-ArchLinux-Guide/wiki/一键配置桌面环境)
> 安装前执行 `timedatectl` 确认系统时区是否为 `Asia/Shanghai`。如果不是，执行 `sudo timedatectl set-timezone Asia/Shanghai` 和 `sudo hwclock --systohc`

✅ 我尝试过的：

- GNOME：基本上都是跟着上面的教程进行安装和配置
- Niri：直接用上面的一键脚本安装，选的是 Niri+[DMS](https://danklinux.com/) 方案。➡️ [我的Niri配置](./我的Niri配置.md)。

## 8. 透明代理

在安装过程中可能遇到网络问题，这时候需要安装透明代理工具。

👉 看这篇：[代理](https://github.com/SHORiN-KiWATA/Shorin-ArchLinux-Guide/wiki/代理)

> 个人觉得最方便的是 [daed](https://github.com/daeuniverse/daed)

## 9. 本地化设置

设置系统语言。

👉 看这篇：[本地化设置](./本地化设置.md)

## 10. 输入法

推荐用 fcitx5+Rime，功能强大，配置也比较简单。遇到问题可以参考下面的教程。

👉 看这篇：[中文输入法](https://github.com/SHORiN-KiWATA/Shorin-ArchLinux-Guide/wiki/中文输入法)

## 11. GRUB美化

可以给GRUB启动界面换一个好看的主题，我比较喜欢 [CyberGRUB-2077
](https://github.com/adnksharp/CyberGRUB-2077) 这个主题。

👉 教程：[grub美化](https://github.com/SHORiN-KiWATA/Shorin-ArchLinux-Guide/wiki/grub美化)

## 12. 终端美化

👉 看这篇：[终端美化](https://github.com/SHORiN-KiWATA/Shorin-ArchLinux-Guide/wiki/终端美化)

zsh我喜欢用 [zimfw](https://github.com/zimfw/zimfw) 这个框架，提供了很多方便的功能和插件，安装后可以直接使用。可以看[这里的说明](./好用的命令行工具.md#zsh)。

## 13. 安装其他软件

👉 可以看以下教程：

- [如何安装软件](./如何安装软件.md)：介绍了常用的软件安装方式。
- [常用软件](./常用软件.md)：推荐了一些我觉得好用的软件。
- [编程开发工具](./编程开发工具.md)：编程开发相关的软件和工具配置。
- [用wine兼容层安装windows软件](./用wine兼容层安装windows软件.md)：安装在linux下没有的软件。
- [软件安装相关](https://github.com/SHORiN-KiWATA/Shorin-ArchLinux-Guide/wiki/软件安装相关)：这篇文章推荐了很多好用的软件。
- [Linux玩游戏](https://github.com/SHORiN-KiWATA/Shorin-ArchLinux-Guide/wiki/玩游戏)：介绍了在Linux上玩游戏所需的软件和工具，如Steam、wine兼容层、安卓模拟器等。
- 游戏设置补充一个 `gamemode`，用于提升游戏性能，参考这个教程： [🔥-性能提升](https://arch.icekylin.online/app/common/play#🔥-性能提升)

## 其他进阶主题

👉 你可能感兴趣的一些主题：

- [性能优化](https://github.com/SHORiN-KiWATA/Shorin-ArchLinux-Guide/wiki/性能优化)：介绍了一些性能相关的优化措施，如更换linux-zen内核、zram内存压缩、调整显卡设置等。
- [显卡切换](https://github.com/SHORiN-KiWATA/Shorin-ArchLinux-Guide/wiki/显卡切换)：指定程序使用独显模式还是混合模式运行。
- [远程桌面](./远程桌面.md)：介绍了远程桌面的配置方式。个人推荐 `sunshine+moonlight` 日月组合方案，性能更好。

🖥️ 虚拟机相关的主题：

- [KVM虚拟机](https://github.com/SHORiN-KiWATA/Shorin-ArchLinux-Guide/wiki/KVM虚拟机)：KVM是Linux下性能最好的虚拟机解决方案。
- [虚拟机显卡直通](https://github.com/SHORiN-KiWATA/Shorin-ArchLinux-Guide/wiki/KVM虚拟机#显卡直通)（可选）：有需要在虚拟机里玩游戏或者使用显卡性能的，可以考虑显卡直通。
- [其他虚拟机方案](https://github.com/SHORiN-KiWATA/Shorin-ArchLinux-Guide/wiki/虚拟机)：如果不想折腾KVM，也可以考虑其他虚拟机方案，如VMware、VirtualBox等，安装和配置相对简单一些。

windows镜像ISO文件推荐在 [ITellYOU](https://next.itellyou.cn/) 下载；virtio驱动在[这里](https://fedorapeople.org/groups/virt/virtio-win/direct-downloads/archive-virtio/?C=M;O=A)下载最新的 ISO 文件。

## 我遇到过的问题

👉 我遇到过的问题及解决方法：[我遇到过的问题](./我遇到过的问题.md)

💡 其他人的经验分享：

- [Shorin-遇到过的问题及解决方法](https://github.com/SHORiN-KiWATA/Shorin-ArchLinux-Guide/wiki/issues)

## 附录

- [ArchLinux常用命令](./ArchLinux常用命令.md)
- [干净删除Linux](https://github.com/SHORiN-KiWATA/Shorin-ArchLinux-Guide/wiki/干净删除Linux)

<br/>
<br/>

---

<br/>

## 本指南文档目录

- [ArchLinux安装配置指南](./ArchLinux安装配置指南.md)
- [手动安装系统的注意事项](./手动安装系统的注意事项.md)
- [好用的命令行工具](./好用的命令行工具.md)
- [我的Niri配置](./我的Niri配置.md)
- [本地化设置](./本地化设置.md)
- [如何安装软件](./如何安装软件.md)
- [常用软件](./常用软件.md)
- [编程开发工具](./编程开发工具.md)
- [用wine兼容层安装windows软件](./用wine兼容层安装windows软件.md)
- [远程桌面](./远程桌面.md)
- [我遇到过的问题](./我遇到过的问题.md)
- [ArchLinux常用命令](./ArchLinux常用命令.md)
