# 安装 GRUB 引导

## 1. 安装必要的软件包：

```sh
pacman -S grub efibootmgr
```

> `grub` 是引导程序本体，`efibootmgr` 用来将启动项写入 NVRAM

如果需要用双系统：

```sh
pacman -S os-prober fuse3
```

## 2. 安装引导

```sh
# 如果 efi 分区挂载到 /boot
grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=ARCH

# 如果 efi 分区挂载到 /efi
grub-install --target=x86_64-efi --efi-directory=/efi  --bootloader-id=ARCH
```

参数说明

```sh
# --target         指定架构
# --efi-directory  指定 ESP 位置
# --boot-directory 可以指定 GRUB 的安装目录，如果不写的话就是 `/boot/grub`
# --bootloader-id  取一个启动项名字
```

上面这段命令在 `/efi/EFI/ARCH` 目录生成 `grubx64.efi` 文件，同时在主板的存储芯片（NVRAM）中生成对应的启动项。

## 3. 编辑 GRUB 源文件

```sh
vim /etc/default/grub
```

编辑以下设置：

- 启动项记忆功能

  - `GRUB_DEFAULT=0` 改成 `=saved`
  - 再取消 `GRUB_SAVEDEFAULT=true` 的注释

- 显示开机日志

  - `GRUB_CMDLINE_LINUX_DEFAULT` 里面去掉 `quiet` 以显示开机日志
  - 再把 `loglevel` 日志等级设置为 5。
    > `loglevel` 共 8 级，5 级是一个信息量的平衡点。

- 禁用 watchdog

  - `GRUB_CMDLINE_LINUX_DEFAULT` 里添加 `nowatchdog`
  - Intel CPU 用户再写入 `modprobe.blacklist=iTCO_wdt`，AMD 用户写入 `modprobe.blacklist=sp5100_tco`

- 允许使用 os-prober 搜索其他系统

  取消最后一行 `GRUB_DISABLE_OS_PROBER=false` 的注释

## 4. 生成启动配置文件

```sh
grub-mkconfig -o /boot/grub/grub.cfg
```

## 5. 初始化 Btrfs 环境块

通常环境变量会存储在 `/boot/grub/grubenv` 中，这与启动项记忆等实用功能相关，但 Btrfs 文件系统的特殊性导致了写入异常。从 GRUB 2.14 版本开始，可以初始化 Btrfs Header 中的部分区域用于 `grubenv` 相关功能。

```sh
grub-editenv - set ok=1
```

<details><summary>参数说明</summary>

```sh
# grub-editenv 编辑 grubenv
# 短横杠代表 /boot/grub/grubenv
# set ok=1 这里随意写了点东西初始化环境快
```

</details>

可以用如下命令验证

```sh
grub-editenv - list
```

应该会看到类似下面这样的输出

```
env_block=512+1
ok=1
```

> 注意，如果你使用 LVM、RAID 或 encryption 则不适用这个方法
