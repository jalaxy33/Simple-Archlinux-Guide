# 用wine兼容层安装windows软件

## 什么是Wine兼容层

Wine是一个在linux下运行Windows软件的兼容层。

具体可以看👉 [这里的介绍](https://github.com/SHORiN-KiWATA/Shorin-ArchLinux-Guide/wiki/玩游戏#wine兼容层运行)

## 前置准备

先安装显卡驱动，👉 [教程在这](https://github.com/SHORiN-KiWATA/Shorin-ArchLinux-Guide/wiki/显卡驱动和硬件编解码)

## 1. 安装兼容层

### 安装lutris

虽然可以直接用wine安装windows软件，但个人更推荐用 [lutris](https://lutris.net/) 统一管理所有的兼容层和安装的软件。

1. 安装 lutris：

   ```
   sudo pacman -S --needed lutris
   ```

   第一次启动会安装必要的进行时，安装需要网络环境。如果进行时安装中断，可在右上角进 `Preference/Updates` 里手动更新。

2. 在 lutris 中下载 `ge-proton`

   **方法**：右上角三道杠进入`首选项`，进入`update`页面，点击下载`wine-ge`（大概是这个名字），此时下载最新版本的ge-proton

3. 设置wine默认使用`ge-proton`

   主页面，单击左下角wine右边的齿轮。设置wine默认使用ge-proton

#### 如何卸载lutris

```sh
sudo pacman -Rns lutris
```

```sh
sudo rm -rfv ~/.config/lutris  ~/.local/share/lutris
```

### 可选：安装protonplus

这是一个专门管理不同版本proton的软件

```sh
yay -S protonplus
```

## 2. 安装Windows软件

### 可选：配置兼容层

点击 lutris 左侧边栏的 Runner 中的 Wine，旁边会出现一个小齿轮，点进去，选择一个 wine 版本（可以选择刚刚安装的 GE-Proton）。在这里还可以配置其他选项。

### 安装软件

1. 准备好软件的 exe 安装包

2. 点击 lutris 软件左上角的 `+` 号，选择带有 exe 的那一项（一般是第二项）。

3. 设置名称，最下面可以选择软件语言 → 选择安装目录（同时也是 prefix 目录），选择是否创建快捷方式 → 选择 exe 安装包路径 → 开始安装（一直默认即可）

### 配置软件

一些常用设置：

#### 配置软件路径

lutris 有时候无法自动识别安装包安装的软件的路径，需要手动指定一下。

在 lutris 中右键点击安装的软件图标，选择 Configure，点进「Game Options」，在第一项 Executable 选择软件 exe 所在路径，一般在安装目录下的 `drive_c/Program Files (x86)/` 下。

#### 访问Linux文件系统

如果需要传输文件，推荐打开右上角的 Advanced，开启最底下的 `Integrate system files in the prefix`。

#### 设置软件图标

软件图标在安装目录下的 `driver_c/proton_shorcuts/icons` 下，有需要的可以进行配置。
