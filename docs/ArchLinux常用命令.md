# Archlinux常用命令

## 可选：安装pamac

pamac 提供了 pacman 的图形化界面：

```sh
sudo pacman -S --needed pamac-aur
```

## pacman常用命令

更详细的命令可以看 [archwiki](https://wiki.archlinuxcn.org/wiki/Pacman)。

以下所有命令默认省略 `sudo`。

### 安装与下载

- 安装应用：

  ```sh
  pacman -S <包1> <包2> ...
  ```

  跳过已安装的包，使用 `--needed` 参数：

  ```sh
  pacman -S --needed <包名>
  ```

  自动确认，`--noconfirm` 参数：

  ```sh
  pacman -S --noconfirm <包名>
  ```

- 从软件源之外的地方安装包

  ```sh
  pacman -U /path/to/package/package_name-version.pkg.tar.zst
  ```

- 下载包但不安装

  ```sh
  pacman -Sw <包名>
  ```

### 查询与搜索

查询搜索一般不需要`sudo`权限

- 搜索包

  ```sh
  pacman -Ss <关键词>
  ```

- 列出所有已安装的包

  ```sh
  pacman -Qe
  ```

- 列出所有已安装的依赖

  ```sh
  pacman -Qd
  ```

- 列出孤立依赖包

  ```sh
  pacman -Qdt
  ```

### 卸载与清理

- 卸载包，同时删除不再被其他包需要的依赖：

  ```sh
  sudo pacman -Rns <包名>
  ```

  （不推荐）强制卸载包，无视依赖关系：

  ```sh
  sudo pacman -Rdd <包名>
  ```

- 清理缓存

  ```sh
  sudo pacman -Sc
  ```

- 清理孤立依赖包

  ```sh
  sudo pacman -Rns $(pacman -Qdt)
  ```

### 更新升级

- 升级系统以及所有安装的包

  ```bash
  sudo pacman -Syu
  ```

#### ⚠️切勿部分升级

请注意，ArchLinux是滚动更新的发行版，不支持部分升级，详情见 [archwiki](https://wiki.archlinuxcn.org/wiki/系统维护#不支持部分升级)。

切勿使用以下命令：

- `pacman -Sy 软件包`
- 先执行 `pacman -Sy` 或 `pacman -Syuw` 再执行 `pacman -S 软件包`（此处应使用 `-Su` 安装软件包）。

