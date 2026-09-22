# GUI软件推荐

> [软件安装相关 - Shorin-ArchLinux-Guide](https://github.com/SHORiN-KiWATA/Shorin-ArchLinux-Guide/blob/main/wiki/archlinux/软件安装相关.md)

## 浏览器

最常用的是 firefox 和 chrome。习惯 chromium 系的还推荐 brave。按自己喜好选择即可。

<details>
<summary><strong>chromium 系浏览器</strong></summary>

- chrome，在AUR里：

  ```sh
  paru -S google-chrome
  ```

  启动命令：`google-chrome-stable`

- brave，两个版本：

  - 原版

    ```sh
    sudo pacman -S brave-bin
    ```

    启动命令：`brave`

  - 移除 AI 功能的版本，我用的是这个，在 AUR 里

    ```sh
    paru -S brave-origin-bin
    ```

    启动命令：`brave-origin`

</details>

<details>
<summary><strong>firefox 系浏览器</strong></summary>

- firefox，需要同时安装中文语言包:

  ```sh
  sudo pacman -S firefox firefox-i18n-zh-cn
  ```

  启动命令：`firefox`

- zen，也需要安装中文语言包：

  ```sh
  sudo pacman -S zen-browser zen-browser-i18n-zh-cn
  ```

  启动命令：`zen`

</details>

## 多媒体

<details>
<summary><strong>视频播放器</strong></summary>

- mpv：

  ```sh
  sudo pacman -S mpv
  ```

</details>

<details>
<summary><strong>图片查看器</strong></summary>

- imv：

  ```sh
  sudo pacman -S imv
  ```

  <details><summary><strong>设置 imv 为默认图片查看器</strong></summary><br>

  `imv` 默认每次只打开一张图片，建议用 `imv-dir`，可以查看当前目录下的所有图片。

  一条命令修改默认图片查看器为 `imv-dir`：

  ```sh
  xdg-mime default imv-dir.desktop $(grep "^image/" /usr/share/mime/types)
  ```

  另外，imv-dir 的默认排序不是自然排序，有时候可能会有问题。编辑 `/usr/bin/imv-dir`（不推荐）或者创建一个 `~/.local/bin/imv-dir` 并用 `chmod +x` 赋予执行权限，内容如下：

  ```sh
  #!/bin/sh -efu
  if [ $# -gw 2 ]; then
    exec imv "$@"
  else
    exec imv -n "$1" $(ls "$(dirname "$1")" | sort -n)
  fi
  ```

  </details>

</details>

<details>
<summary><strong>听歌软件</strong></summary>

- splayer-next：第三方网易云客户端

  ```sh
  sudo pacman -S splayer-next
  ```

- spotify：

  ```sh
  flatpak install com.spotify.Client
  ```

</details>

## 系统工具

<details>
<summary><strong>软件管理</strong></summary>

- pinapp：管理软件快捷方式（`.desktop`），还可以用来设置软件环境变量、隐藏不要的快捷方式等

  ```sh
  flatpak install io.github.fabrialberio.pinapp
  ```

</details>

## 网络工具

<details>
<summary><strong>文件传输与下载</strong></summary>

- localsend：局域网文件传输

  ```sh
  sudo pacman -S localsend
  ```

- motrix-next：下载工具

  ```sh
  paru -S motrix-next
  ```

</details>

<details>
<summary><strong>网络代理</strong></summary>

- flclash

  ```sh
  sudo pacman -S --needed flclash
  ```

</details>

## 办公软件

<details>
<summary><strong>office替代</strong></summary>

- onlyoffice：国产的开源办公软件，比较轻量且无广告。

  ```sh
  sudo pacman -S onlyoffice-bin
  ```

- wps：需要额外安装中文语言包

  ```sh
  paru -S wps-office-cn wps-office-mui-zh-cn
  ```

</details>
