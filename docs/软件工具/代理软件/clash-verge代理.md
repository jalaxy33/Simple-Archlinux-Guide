# clash-verge 代理

clash-verge 是基于 mihomo 内核和 tauri 的 GUI 软件，操作直观，设置项丰富，新手推荐。

## 前提条件

- 需要图形环境，如果还没安装桌面，可以先安装一个[临时桌面环境](../proxy网络代理.md#tmpde)。
- 开启 TUN 代理需要当前用户具有 sudo 权限

## 配置流程

1. 安装 clash-verge，这个包在 archlinuxcn 源里：

```sh
sudo pacman -S clash-verge-rev
```

2. 启动

```sh
clash-verge
```

3. 「订阅」页导入订阅链接，「代理」页选择要使用的代理组

4. 开启 TUN 代理：

   - 主页「网络设置」，切换至「虚拟网卡模式」，选择开启。

     > 首次启用时，会提示输入用户密码安装服务。后续可以点击齿轮 ⚙️ 右侧的符号安装/卸载服务。

   - 开启 TUN 代理后，检查是否成功创建 tun 虚拟网卡：

     ```sh
     ip a
     ```

     查看输出结果中是否有 tun 对应设备。

     clash-verge 的 tun 网卡默认名称为 `Mihomo`，也可以点击「虚拟网卡模式」旁的齿轮 ⚙️ 符号设置虚拟网卡名称。

5. 如果启用了防火墙，需要修改防火墙配置，放行 tun 对应设备（默认为 `Mihomo`）。

    <details>

    <summary>以 nftables 为例，其他防火墙类似</summary>

   配置过程：
   - 编辑配置文件：

     ```sh
     sudo vim /etc/nftables.conf
     ```

     填写以下内容：

     ```conf
     # 这里改为tun设备名
     define mohomo_if = "Mihomo"

     table inet filter {
       chain input {
         # 其他已有配置...

         # mihomo TUN
         iifname $mohomo_if accept
       }

       chain forward {
         # 其他已有配置...

         # mihomo TUN
         iifname $mohomo_if accept
         oifname $mohomo_if accept
       }
     }
     ```

   - 检查配置语法：

     ```sh
     sudo nft -c -f /etc/nftables.conf
     ```

   - 重启防火墙服务：

     ```sh
     sudo systemctl restart nftables
     ```

    </details>

6. 测试代理是否生效：

   ```sh
   curl -I www.google.com
   ```

   返回 `HTTP ... 200 ...` 开头的一大串内容就是成功了。
