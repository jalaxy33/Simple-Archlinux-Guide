# dae 代理

基于 eBPF 的内核级透明代理工具，性能好，纯命令行工具。

如果需要图形管理界面，可以选择[安装 daed](./daed代理.md)

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
     #udp_check_dns: '8.8.4.4:53'

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

     hk_sg {
      filter: name(regex: 'HK|香港|SG|新加坡')
      policy: min_moving_avg
    }
   }


   routing {
     # Force DNS/SSH-related processes direct.
     pname(NetworkManager, systemd-resolved, dnsmasq, dropbear) -> must_direct

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

6. 测试代理是否生效：

   ```sh
   curl -I www.google.com
   ```

   返回 `HTTP ... 200 ...` 开头的一大串内容就是成功了。
