# flclash代理

flclash 是基于 mihomo 内核和 electron 的 GUI 软件，操作简单，界面美观，新手推荐。

## 前提条件

- 需要图形环境，如果还没安装桌面，可以先安装一个[临时桌面环境](../proxy网络代理.md#tmpde)。
- 开启 TUN 代理需要当前用户具有 sudo 权限

## 配置流程

1. 安装 flclash，它在 archlinuxcn 源里：

   ```sh
   sudo pacman -S flclash
   ```

   archlinuxcn源的版本较旧，也可以从 AUR 安装较新版本：

   ```sh
   paru -S flclash-bin
   ```

2. 为了能运行 tun 透明代理，需要授予 flclash 网络管理权限：

   ```sh
   sudo setcap cap_net_admin=ep /usr/bin/flclash
   ```

3. 启动

   ```sh
   flclash
   ```

4. 在主页开启 TUN 虚拟网卡，首次开启需要输入密码

5. 配置页导入订阅链接后，点击主页右下角三角形启动代理

6. 检查 TUN 虚拟网卡是否创建成功

   ```sh
   ip a
   ```

   检查输出结果中是否有名为 `FlClash` 的设备。

7. 如果启用了防火墙，需要修改防火墙配置，放行 tun 对应设备（这里是 `FlClash`）。

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
     define flclash_if = "FlClash"

     table inet filter {
       chain input {
         # 其他已有配置...

         # flclash TUN
         iifname $flclash_if accept
       }

       chain forward {
         # 其他已有配置...

         # flclash TUN
         iifname $flclash_if accept
         oifname $flclash_if accept
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

8. 测试代理是否生效：

   ```sh
   curl -I www.google.com
   ```

   返回 `HTTP ... 200 ...` 开头的一大串内容就是成功了。
