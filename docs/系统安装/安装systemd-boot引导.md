# 安装 systemd-boot 引导

[systemd-boot](https://wiki.archlinuxcn.org/wiki/Systemd-boot) 是 systemd 提供的 bootloader 工具。

前提条件：

- 系统的 efi 分区（ESP）挂载到 `/boot` 下
- 已安装 `systemd` 包，该包为 `base` 包的依赖。一般无需手动安装。

本教程假设你已经 chroot 到了系统挂载点下

## 步骤

### 1. 安装 UEFI 启动管理器

```sh
bootctl install
```

### 2. 配置启动选单

```sh
vim /boot/loader/loader.conf
```

```
default  @saved
timeout  4
console-mode auto
editor   no
```

<details><summary>选项说明</summary>

```
- `default`：默认启动项。`@saved` 表示记住启动项
- `timeout`：超时等待的秒数
- `console-mode`：菜单分辨率。`auto` 表示自动调整
- `editor`：是否允许在开机时编辑设置。
```

</details>

### 3. 创建启动项

在 `/boot/loader/entries/` 目录下创建 `.conf` 启动项文件，例如 `arch.conf`

```sh
vim /boot/loader/entries/arch.conf
```

下面是一个最简单的配置模板：

```conf
title   Arch Linux
linux   /vmlinuz-linux
initrd  /initramfs-linux.img
options root=UUID=xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx rw
```

<details><summary>配置选项说明</summary>

</details>

1. 首先确定 `/boot` 下是否有内核相关的文件：

   ```sh
   ls /boot
   ```

   如果安装的是 linux 内核，应该有 `vmlinuz-linux` 和 `initramfs-linux.img`

   如果安装的是 linux-zen 内核，则是 `vmlinuz-linux-zen` 和 `initramfs-linux-zen.img`

2. 确认 root 分区的 UUID

   ```sh
   cat /etc/fstab
   ```

3. 创建启动项配置文件：

   ```sh
   vim /boot/loader/entries/arch.conf
   ```

   ```
   title   Arch Linux
   linux   /vmlinuz-linux
   initrd  /initramfs-linux.img
   options root=UUID=xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx rw
   ```

   填写说明：

   - `title`：显示的启动项标题

   - `linux`：要启动的 linux 内核，根据内核选择。

     > linux 内核为 `/vmlinuz-linux`，linux-zen 内核为 `/vmlinuz-linux-zen`

   - `initrd`：启动内核时使用的 initrd 文件。

     > linux 内核为 `/initramfs-linux.img`，linux-zen 内核为 `/initramfs-linux.img`

   - `options`：启动选项，`root=UUID=` 等号后改为 root 分区的 UUID

在 `options` 后添加这些选项：

- （❗重要）如果根分区是 btrfs 格式的
  - 添加 `rootflags=subvol=@`。其中 `@` 为 root 子卷名

- 显示开机日志
  - 添加 `loglevel=5`。loglevel 共 8 级，5 级是一个信息量的平衡点。

- 禁用 watchdog
  - 添加 `nowatchdog`
  - Intel CPU 用户再写入 `modprobe.blacklist=iTCO_wdt`，AMD 用户写入 `modprobe.blacklist=sp5100_tco`

### 4. 可选：设置 systemd-boot 自动更新

```sh
systemctl enable systemd-boot-update
```

设置后，会在每次开机时自动执行更新命令
