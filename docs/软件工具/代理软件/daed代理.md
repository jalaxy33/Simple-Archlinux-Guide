# daed 代理

dae 的 webui，配置简单，开箱即用。

> 注意：**dae 和 daed 不支持 clash 订阅链接**，请使用 vless 或 vmess 等[链接格式](https://github.com/daeuniverse/dae/blob/main/docs/zh/proxy-protocols.md)

1. 安装 daed，这个包在 archlinuxcn 源里：

   ```sh
   sudo pacman -S daed
   ```

   也可以安装带 AVX2 CPU 优化版本的，这个包也在 archlinuxcn 源里：

   ```sh
   sudo pacman -S daed-avx2-bin
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

4. 用处于同一局域网的设备访问 `http://<IP_ADDRESS>:2023` 登录 webui 管理界面，设置管理账号和六位以上密码，填入订阅链接，将订阅拖入「群组」的订阅组处，之后点击右上角开关就开启代理了。

5. （可选）如果代理不稳定，需要创建或修改路由规则。

   方法：webui 右上角「路由」标签卡，编辑已有规则或创建一个新规则，选择「进阶模式」。

    <details>
    <summary>填入以下内容</summary>

   ```dae
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
   ```

    </details>

6. 测试代理是否生效：

   ```sh
   curl -I www.google.com
   ```

   返回 `HTTP ... 200 ...` 开头的一大串内容就是成功了。
