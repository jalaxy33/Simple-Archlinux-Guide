# btrfs分区格式化与挂载

## 格式化分区

1. 查看分区情况

   ```sh
   lsblk -pf #查看分区情况
   fdisk -l /dev/想要查询详细情况的硬盘  #小写字母l，查看详细分区信息
   ```

2. 将 root 分区格式化为 btrfs 文件系统

   ```sh
   mkfs.btrfs /dev/root_partition   # 如 /dev/sda2, /dev/nvme0n1p2
   ```

   加上 `-f` 参数可以强制格式化

3. 格式化 EFI 分区

   ```sh
   mkfs.fat -F 32 /dev/efi_system_partition  # 如 /dev/sda1, /dev/nvme0n1p1
   ```

4. 可选：如果创建了 swap 分区，用 `mkswap` 将其初始化：

   ```sh
   mkswap /dev/swap_partition
   ```

## 创建btrfs子卷

子卷是 Btrfs 的一个特性，跟快照（存档和回档）有关。通常至少要创建 root 子卷和 home 子卷，分别用于存放系统文件和用户文件，根据命名规范取名为 `@` 和 `@home`。

> 为什么要创建多个子卷：子卷之间是平级关系，创建 root 快照时就不会包含其他子卷的内容。这样就可以只恢复系统文件，不影响用户数据。

1. 为了创建子卷，需要先挂载 root 分区到 `/mnt`：

   ```sh
   mount -t btrfs /dev/root_partition /mnt
   ```

2. 创建子卷

   至少创建 root 和 home 子卷：

   ```sh
   btrfs subvolume create /mnt/@
   btrfs subvolume create /mnt/@home
   ```

3. 可选：创建单独的子卷，用于存放大型文件等无需快照备份的文件。

   > 我的习惯是创建一个名为 `@unsnap` 的子卷

   ```sh
   btrfs subvolume create /mnt/@unsnap  # 可以起任何名
   ```

   对于存放大文件的子卷，可以禁用子卷的写时复制（CoW）：

   ```sh
   chattr +C /mnt/@unsnap
   ```

4. 可选：如果想使用 swap 文件而非 swap 分区，可以为其创建一个 swap 子卷

   ```sh
   btrfs subvolume create /mnt/@swap
   ```

   > ❗前提：如果你的内存大于等于 16G 且不需要休眠到硬盘功能，不做大型项目的话跳过这个

5. 查看当前分区子卷情况：

   ```sh
   btrfs subvolume list /mnt
   ```

6. 取消挂载当前分区

   ```sh
   umount /mnt
   ```

## 挂载分区

> 分区挂载需要遵从「先挂载根分区，再挂载其他分区」的顺序。

1. 先挂载根分区的 root 子卷（`@`）到 `/mnt`

   ```sh
   mount -t btrfs -o subvol=/@,compress=zstd /dev/root_partition /mnt
   ```

   <details><summary>参数说明</summary>

   ```sh
   # -o 指定额外的挂载参数
   # compress=zstd 指定透明压缩，zstd 是压缩算法
   ```

   </details>

   > `compress` 是 Btrfs 的另一个特性，透明压缩。在数据写入磁盘前先进行压缩，提升读写性能，节省空间，延长寿命。可以像这样 `zstd:3` 指定压缩等级，最高 15。默认为 3，在意 CPU 性能可以设置成 1。

2. 挂载根分区的 home 子卷（`@home`），注意添加 `--mkdir` 参数自动创建目录

   ```sh
   mount --mkdir -t btrfs -o subvol=/@home,compress=zstd /dev/root_partition /mnt/home
   ```

   如果创建了其他子卷，也需要挂载：

   ```sh
   # 例如挂载 @unsnap 子卷，挂载点任意命名，如 /mnt/Unsnap
   mount --mkdir -t btrfs -o subvol=/@unsnap,compress=zstd /dev/root_partition /mnt/Unsnap
   ```

3. 然后挂载 efi 分区，典型挂载点有 `/mnt/boot` 或 `/mnt/efi`。

   ```sh
   mount --mkdir /dev/efi_system_partition /mnt/boot

   # 或
   mount --mkdir /dev/efi_system_partition /mnt/efi
   ```

   注意添加 `--mkdir` 参数，自动创建目录

4. 可选：启用 swap 分区或 swap 文件

   两种较为传统的创建交换空间的方式，我一般不做，后面会配置更现代的内存 swap（ZRAM）

   - swap 分区

     如果创建了 swap 分区，使用 `swapon` 启用它：

     ```sh
     swapon /dev/swap_partition
     ```

   - swap 文件

     > ❗前提：如果你的内存大于等于 16G 且不需要休眠到硬盘功能，不做大型项目的话跳过这个

     挂载之前创建的 swap 子卷：

     ```sh
     mount --mkdir -t btrfs -o subvol=/@swap,compress=zstd /dev/root_partition /mnt/swap
     ```

     创建 swap 文件：

     ```sh
     # 此处的 64g 需要换成自己的实际需求大小
     btrfs filesystem mkswapfile --size 64g --uuid clear /mnt/swap/swapfile
     ```

     > <details><summary>swap 大小参考</summary>
     >
     > | 内存(GB) | 不需要休眠(GB) | 需要休眠（GB） | 不建议超过（GB） |
     > | -------- | -------------- | -------------- | ---------------- |
     > | 1        | 1              | 2              | 2                |
     > | 2        | 2              | 3              | 4                |
     > | 3        | 3              | 5              | 6                |
     > | 4        | 4              | 6              | 8                |
     > | 5        | 2              | 7              | 10               |
     > | 6        | 2              | 8              | 12               |
     > | 8        | 3              | 11             | 16               |
     > | 12       | 3              | 15             | 24               |
     > | 16       | 4              | 20             | 32               |
     > | 24       | 5              | 29             | 48               |
     > | 32       | 6              | 38             | 64               |
     > | 64       | 8              | 72             | 128              |
     > | 128      | 11             | 139            | 256              |
     > | 256      | 16             | 272            | 512              |
     >
     > </details>

     启用 swap 文件：

     ```sh
     swapon /mnt/swap/swapfile
     ```

查看挂载情况：

```sh
df -h
```

## 多块硬盘如何创建btrfs分区

> 如果有多块硬盘，除了系统盘之外文件系统可以自由选择，根据自己的需求选即可。

关键是先在硬盘分区上创建对应的 btrfs 子卷，其他步骤和单硬盘安装一样。

假设除了系统盘，还有一块硬盘 `/dev/sda`，将其格式化为 btrfs 文件系统并挂载到 linux 系统中，步骤如下：

1. 创建硬盘分区，类型选择 Linux filesystem：

   ```sh
   cfdisk /dev/sda
   ```

2. 格式化为 btrfs 文件系统：

   ```sh
   mkfs.btrfs -f /dev/sda1  # 分区号可能不是 sda1，根据实际情况修改
   ```

3. **关键步骤**：创建 btrfs 子卷。参考上文步骤：

   挂载当前硬盘分区

   ```sh
   mount -t btrfs /dev/sda1 /mnt
   ```

   创建 btrfs 子卷，起一个自定义的名字，后续挂载的时候会用到

   ```sh
   btrfs subvolume create /mnt/@sda
   ```

   查看当前分区子卷情况

   ```sh
   btrfs subvolume list /mnt
   ```

   取消挂载当前分区

   ```sh
   umount /mnt
   ```

4. 挂载硬盘分区。注意挂载路径要改成之前创建的子卷路径：

   ```sh
   # 挂载 @sda 子卷到 /mnt/SDA 目录下
   mount --mkdir -t btrfs -o subvol=/@sda,compress=zstd /dev/sda1 /mnt/SDA
   ```

查看挂载情况：

```sh
df -h
```
