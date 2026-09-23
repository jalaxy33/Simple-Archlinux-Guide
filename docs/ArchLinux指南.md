# ArchLinux极简指南

## 写在前面

本文基于[Shorin-Archlinux-Guide](https://github.com/SHORiN-KiWATA/Shorin-ArchLinux-Guide) 提供的安装配置教程
，主要记录本人在安装配置 Archlinux 过程中遇到的问题和解决方案，以及一些个人的理解和总结。

可以结合下面这些视频教程一起看，视频教程会更直观一些：

- [「Archlinux究极指南2025」从手动安装到显卡直通，最后删除Linux](https://www.bilibili.com/video/BV1L2gxzVEgs)
- [「Linux游戏指南」一次挑战与一场斗争](https://www.bilibili.com/video/BV1zyttzPEmp)
- [从「Linuxmint入门」到「ArchLinux安装详解」桌面端Linux入门的最佳路径](https://www.bilibili.com/video/BV19DBqB4EY4/)

> 注：视频教程有时效性，可能有过时失效的部分，请注意甄别

## 1. 前期准备

安装任意Linux系统前，需要完成一些准备工作。主要是：

- 下载 ISO 镜像，如 [archlinux](https://archlinux.org/download/)
- 制作系统盘，推荐用 [Ventoy](https://www.ventoy.net/cn/index.html)
- 调整 Windows 设置（如果有）和 BIOS 设置

👉 详情看这篇：[安装任意Linux系统的前期准备工作](https://github.com/SHORiN-KiWATA/Shorin-ArchLinux-Guide/blob/main/wiki/安装任意Linux系统的前期准备工作.md)

## 2. 安装系统

两种方式：**手动安装**和**脚本安装**。

脚本安装方便，但是安装过程可能会遇到一些脚本无法处理的问题。推荐手动安装。

👉 安装方法：

- 手动安装教程：[手动安装ArchLinux](./系统安装/手动安装ArchLinux.md)
- 官方安装脚本：在进入 livecd 后，运行 `archinstall` 命令。

  > 安装脚本更新频繁，这里不做详细描述，大致流程可以参考这个[视频教程](https://www.bilibili.com/video/BV1L2gxzVEgs)

## 3. 配置系统快照

_待完成：btrfs系统快照_

## 4. 安装显卡驱动

_待完成：显卡驱动_

## 5. 配置桌面环境

- [安装 Niri 桌面](./桌面环境/安装Niri.md)

## 6. 软件与工具

- [CLI命令行工具推荐](./软件工具/CLI命令行工具推荐.md)
- [GUI软件推荐](./软件工具/GUI软件推荐.md)
- [配置网络代理](./软件工具/proxy网络代理.md)

_待完成：输入法_

## 7. 日常使用

- [远程桌面](./日常使用/远程桌面.md)
- [我遇到过的问题](./我遇到过的问题.md)
