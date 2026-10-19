# 开启 nftables 防火墙

默认不设置防火墙，放行任意端口。下面介绍如何使用 nftables 作为防火墙服务。

1. 首先需要安装 `nftables`：

```sh
sudo pacman -S --needed nftables
```

2. 编辑 `/etc/nftables.conf`，创建规则集，指定要开放的端口（如 2023, 2222 和 53317）：

   ```sh
   sudo vim /etc/nftables.conf
   ```

   复制[这个配置文件](../../assets/nftables.conf)的内容。

    <details><summary>建议修改默认的ssh端口号</summary>

   ssh 默认端口号是 22，容易被攻击，建议更改为其他端口号。

   更改方式：编辑 `/etc/ssh/sshd_config`。找到 `Port` 行，取消注释，改为 `Port <端口号>`。

    </details>

3. 测试配置是否合法：

   ```sh
   sudo nft -c /etc/nftables.conf
   ```

4. 然后为 nftables 设置开机自启：

   ```sh
   sudo systemctl enable --now nftables
   ```

5. 每次改完配置后需要重启服务，以更新配置：

   ```sh
   sudo systemctl restart nftables
   ```
