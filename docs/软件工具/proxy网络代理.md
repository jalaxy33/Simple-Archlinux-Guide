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

### dae

基于 eBPF 的内核级透明代理工具，性能好，纯命令行工具。

> 注意：**dae 不支持 clash 订阅链接**，请使用 vless 或 vmess 等[链接格式](https://github.com/daeuniverse/dae/blob/main/docs/zh/proxy-protocols.md)

1. 安装 dae

   ```sh
   sudo pacman -S dae
   ```

   也可以安装带 AVX2 CPU 优化版本的，这个包在 archlinuxcn 里：

   ```sh
   sudo pacman -S dae-avx2-bin
   ```

2. 编辑配置文件：

   ```sh
   sudo vim /etc/dae/config.dae
   ```

    <details>
    <summary>写入这些内容（注意在 subscription 处填入订阅链接）</summary>

   ```dae
   global {
     # Auto-detect WAN interface.
     wan_interface: auto
   
     # IPv4-only DNS for UDP checks.
     udp_check_dns: '8.8.4.4:53'
   
     log_level: info
     allow_insecure: false
     auto_config_kernel_parameter: true
   }
   
   
   subscription {
     # Fill in your subscription links here.
     # my_sub: 'https://your-subscription-link'
   }
   
   dns {
     # Prefer IPv4; no AAAA.
     ipversion_prefer: 4
   
     upstream {
       # Google DNS over TCP+UDP.
       googledns: 'tcp+udp://dns.google:53'
       # AliDNS over UDP.
       alidns: 'udp://dns.alidns.com:53'
     }
   
     routing {
       request {
         # China domains via AliDNS; fallback to Google DNS.
         qname(geosite:cn) -> alidns
         fallback: googledns
       }
     }
   }
   
   
   group {
     proxy {
       # Pick the node with the lowest moving average latency per connection.
       policy: min_moving_avg
     }
   }
   
   
   routing {
     # Force DNS/SSH-related processes direct.
     pname(dnsmasq, dropbear) -> must_direct
   
     # Force DNS server IPs/domains direct.
     dip(8.8.8.8) -> must_direct
     dip(1.1.1.1) -> must_direct
     domain(dns.alidns.com) -> must_direct
     domain(dns.google) -> must_direct
     domain(cloudflare-dns.com) -> must_direct
   
     # Multicast/broadcast and private IPs direct.
     dip(224.0.0.0/3, 'ff00::/8') -> direct
     dip(geoip:private) -> direct
   
     # China IPs/domains direct.
     dip(geoip:cn) -> direct
     domain(geosite:cn) -> direct
   
     # Block ads.
     domain(geosite:category-ads) -> block
   
     # Per-domain overrides.
     domain(suffix:github.com, suffix:notion.com) -> proxy
     domain(suffix:xiaoe-tech.com, suffix:yuque.com) -> direct
   
     fallback: proxy
   }
   ```

    </details>

3. 验证配置文件正确性

   ```sh
   sudo dae validate -c /etc/dae/config.dae
   ```

4. 启动服务

   ```sh
   sudo systemctl start dae
   ```

   如果要设置开机自启：

   ```sh
   sudo systemctl enable --now dae
   ```

5. 后续如果更新了配置文件或需要手动更新订阅，执行以下命令重载：

   ```sh
   sudo dae reload
   ```

   重载过程通常不会中断现有连接，且比完全重启服务更快。

### daed

dae 的 webui。这是我觉得最简单的方法，但是可能需要连接同个局域网的另一台设备

1. 安装 daed，这个包在 archlinuxcn 源里：

   ```sh
   sudo pacman -S daed
   ```

   > 注意，daed 和 dae 冲突，只能装其中一个

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
