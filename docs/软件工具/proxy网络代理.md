# 网络代理

> [代理 - Shorin-ArchLinux-Guide](https://github.com/SHORiN-KiWATA/Shorin-ArchLinux-Guide/blob/main/wiki/archlinux/代理.md)

如果你使用 Linux 遇到了网络问题，可以配置代理。代理链接自己找，本文只推荐代理工具。

## 测试代理是否生效

配置完代理后一定要测试是否生效。

```sh
curl -I www.google.com
```

返回由 `HTTP ... 200 ...` 开头的一大串内容就是成功了。

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

追求配置简单的用带 GUI 或 webui 的，追求底层控制的直接用相应的裸核配置，后者有更高的性能上限。

### mihomo 系（clash 系）

- [clash-verge](./代理软件/clash-verge代理.md)：基于 tauri 的 GUI 软件，设置项丰富，新手推荐。
- [flclash](./代理软件/flclash代理.md)：基于 electron 的 GUI 软件，界面美观，新手推荐。
- [mihomo裸核](https://github.com/jalaxy33/learn-mihomo/blob/main/docs/mihomo-on-linux.md)：mihomo 系代理的底层服务，命令行工具，配置难度较高但更灵活，性能好且稳定。

### dae 系

dae 是基于 eBPF 的内核级透明代理工具，性能好。

> （2026.10）注：经测试，目前 dae 和 daed 代理的网络连接不稳定，建议使用其他方案

- [daed](./代理软件/daed代理.md)：dae 的 webui，无需图形环境，配置简单，开箱即用。
- [dae裸核](./代理软件/dae代理.md)：基于 eBPF 的内核级透明代理工具，性能好，纯命令行工具。
