# ext4分区格式化与挂载

## 格式化分区

1. 查看分区情况

   ```sh
   lsblk -pf #查看分区情况
   fdisk -l /dev/想要查询详细情况的硬盘  #小写字母l，查看详细分区信息
   ```

2. 将 root 分区格式化为 ext4 文件系统

   ```sh
   mkfs.ext4 /dev/root_partition   # 如 /dev/sda2, /dev/nvme0n1p2
   ```

   加上 `-f` 参数可以强制格式化

3. 格式化 EFI 分区

   ```sh
   mkfs.fat -F 32 /dev/efi_system_partition  # 如 /dev/sda1, /dev/nvme0n1p1
   ```

4. 如果创建了 swap 分区，用 `mkswap` 将其初始化：

   ```sh
   mkswap /dev/swap_partition
   ```

## 挂载分区

> 分区挂载需要遵从「先挂载根分区，再挂载其他分区」的顺序。

1. 先挂载 root 分区到 `/mnt`

   ```sh
   mount /dev/root_partition（根分区） /mnt
   ```

2. 然后挂载 efi 分区，典型挂载点有 `/mnt/boot` 或 `/mnt/efi`。

   ```sh
   mount --mkdir /dev/efi_system_partition /mnt/boot

   # 或
   mount --mkdir /dev/efi_system_partition /mnt/efi
   ```

   注意添加 `--mkdir` 参数，自动创建目录

3. 如果创建了 swap 分区，使用 `swapon` 启用它：

   ```sh
   swapon /dev/swap_partition
   ```

查看挂载情况：

```sh
df -h
```
