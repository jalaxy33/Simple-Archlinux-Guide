# 命令行工具推荐

## 更换shell

如果不想用 bash，有以下替换选项：

- [fish](https://fishshell.com/)：用户友好的交互式 shell，开箱即用

  ```sh
  sudo pacman -S fish
  ```

  但是不遵循 posix 标准，不能直接运行 bash 脚本，不建议设为默认 shell

- [zsh](<>)：遵循 posix 标准的 shell，可扩展

  ```sh
  sudo pacman -S zsh
  ```

  推荐再安装一个 [zimfw](https://zimfw.sh/) 框架，提供众多拓展功能模块：

  ```sh
  paru -S zimfw
  ```

## 终端体验优化

```sh
sudo pacman -S --needed starship ripgrep fzf zoxide eza fd
# yazi 及其依赖
sudo pacman -S --needed yazi ffmpeg 7zip poppler resvg imagemagick
# 可选
sudo pacman -S --needed bat lazygit chezmoi zellij
```

<details>
<summary>工具说明</summary><br>

必备：

- [starship](https://starship.rs/)：终端提示美化
- [ripgrep](https://github.com/burntsushi/ripgrep)：正则搜索工具，性能更好的 grep 命令
- [fzf](https://junegunn.github.io/fzf/)：模糊查找工具
- [zoxide](https://zoxide.org/)：带记忆功能的 cd 命令
- [eza](https://eza.rocks/)：更现代的 ls 命令
- [fd](https://github.com/sharkdp/fd)：更快的 find 命令
- [yazi](https://yazi-rs.github.io/docs/installation)：好用的终端文件浏览器

可选：

- [bat](https://github.com/sharkdp/bat)：带语法高亮的 cat 命令
- [lazygit](https://github.com/jesseduffield/lazygit)：好用的 git 互动式 TUI 管理工具
- [chezmoi](https://chezmoi.io/)：快速同步 dotfiles（用户配置文件），类似定位的还有 `stow`
- [zellij](https://zellij.dev/)：好用的终端复用器，在同一个窗口开多个终端，screen 命令的替代。比 `tmux` 的键位操作更直观，类似定位的还有 `herdr`。

</details>

### 可选：bash 交互体验优化

可以安装 [flyline](https://github.com/HalFrgrd/flyline)，让 bash 获得类似于 fish 的交互式体验

```sh
paru -S flyline
```

> 注：flyline 通过 cargo 编译安装，编译过程需要从 github 拉取依赖，安装前建议配置好 rust 开发环境和相应的网络环境。

  <details><summary>也可以用 homebrew 直接安装预编译二进制文件</summary>

```sh
brew install flyline
```

  </details>

然后在 `~/.bashrc` 中写入：

```sh
enable -f /usr/lib/bash/libflyline.so flyline
```

重启 bash 即启用

</details>

## 文本编辑器

vim 的替代品

```sh
sudo pacman -S --needed neovim helix
```

<details>
<summary>工具说明</summary><br>

- [neovim](https://neovim.io/)：更现代的 vim，拓展性极佳
  > neovim 需要配置才比较好用，推荐从一套预定义的配置开始，如 [lazyvim](http://www.lazyvim.org/)，欢迎用[我的配置](https://github.com/jalaxy33/nvim-advent)。
- [helix](https://helix-editor.com/)：类 vim 的终端文本编辑器，开箱即用

</details>

## 系统工具

```sh
sudo pacman -S --needed fastfetch btop
paru -S shorin-contrib-git
```

<details>
<summary>工具说明</summary><br>

- [fastfetch](https://github.com/fastfetch-cli/fastfetch)：快速获取系统重要信息
- [btop](https://github.com/aristocratos/btop)：CPU 和内存等系统资源实时监控，更好用的 top 命令，类似定位的还有 `htop`
- `shorin-contrib-git`：shorin 大佬提供的 Arch 工具集，提供了很多好用的小工具。网络不好也可以安装 `shorin-contrib-gitee-git`

</details>

## 缺失的linux命令

```sh
sudo pacman -S --needed rsync man-db less
```

<details>
<summary>命令说明</summary>

- [rsync](https://wiki.archlinuxcn.org/wiki/Rsync)：好用的增量文件传输工具，远程文件传输首选
  > 远程传输大文件首选 `rsync`，不要用 `scp`，会丢文件
- [man-db](https://wiki.archlinuxcn.org/wiki/Man_手册)：`man` 手册命令，查看某个命令的用法

  ```sh
  man ls
  ```

  <details>
  <summary><strong>技巧：指定 manpage 的阅读器</strong></summary><br>

  man 命令默认的阅读体验很一般，可以利用 `MANPAGER` 环境变量来指定使用的阅读器：

  ```sh
  # 指定为nvim
  export MANPAGER="nvim"
  ```

  </details>

- `less`：分页阅读命令，特别适合用来查看日志或代码文件，或者很长的命令输出

  ```sh
  # 查看一个文件
  less /path/to/file

  # 如果命令输出很长，可以通过 | 管道符用 less 来阅读
  find /usr | less
  ```

</details>
