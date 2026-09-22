# 网络代理

> [代理 - Shorin-ArchLinux-Guide](https://github.com/SHORiN-KiWATA/Shorin-ArchLinux-Guide/blob/main/wiki/archlinux/代理.md)

如果你使用 Linux 遇到了网络问题，可以配置代理。代理链接自己找，本文只推荐代理工具。

## 测试代理是否生效

配置完代理后一定要测试是否生效。

```sh
curl -I www.google.com
```

返回由 `HTTP ... OK` 开头的一大串内容就是成功了。

## 临时桌面环境<a name="tmpde"></a>

有些代理软件只有 GUI，需要有图形环境才能运行。在还没安装桌面环境时，可以安装一个临时的桌面环境。如果你已经有桌面了（任意桌面都可以），不需要这一步。

推荐使用 labwc，它相当轻量。

1. 安装 labwc 和一个终端：

   ```sh
   sudo pacman -S --needed labwc kitty
   ```

2. 启动 labwc

   ```sh
   labwc
   ```

   labwc 打开之后是纯黑的，正常点击桌面选择 `terminal` 或者按下 `Super（Win 键）+ 回车键` 就能打开终端，选 `exit` 可以退出 labwc。

- 结束后卸载 labwc：

  ```sh
  sudo pacman -Rns labwc
  ```

## 代理工具推荐

### daed

这是我觉得最简单的方法，需要连接同个局域网的另一台设备

1. 安装 daed，这个包在 archlinuxcn 源里：

   ```sh
   sudo pacman -S daed
   ```

2. 启动服务：

   ```sh
   sudo systemctl start daed
   ```

   如果要设置开机自启：

   ```sh
   sudo systemctl enable --now daed
   ```

3. 获取 IP 地址：

   ```sh
   ip a
   ```

4. 用处于同一局域网的设备访问 `http://<IP_ADDRESS>:2023` 登录 webui 管理界面，设置管理账号和六位以上密码，填入订阅链接，然后就可以开启代理了。

### flclash

flclash 需要图形环境，如果还没安装桌面，可以先安装一个[临时桌面环境](#tmpde)。

1. 安装 flclash，它在 archlinuxcn 源里：

   ```sh
   sudo pacman -S flclash
   ```

2. 启动

   ```sh
   flclash
   ```

3. 在主页开启 TUN 虚拟网卡

4. 导入订阅链接后，点击主页右下角三角形启动代理
