# vnc远程桌面

如果想要 headless 的远程桌面，即无需共享屏幕，远程使用独立窗口，可以使用 vnc 方案。

<details><summary>参考资料</summary>

- [TigerVnc - archwiki](https://wiki.archlinux.org/title/TigerVNC)
- [Xfce - archwiki](https://wiki.archlinux.org/title/Xfce)
- [novnc](https://github.com/novnc/novnc)

</details>

## x11桌面——tigervnc

x11 桌面的 vnc 配置很简单。

### 安装配置相关服务

首先需要一个 x11 桌面环境，如果现在在用的就是 x11 桌面可以跳过，如果不是则需要下载一个，这里用 xfce 举例：

```sh
sudo pacman -S xfce4
```

然后安装 vnc 服务，这里选择 tigervnc：

```sh
sudp pacman -S tigervnc
```

配置 vnc 服务器：

1. 执行命令创建 vnc 服务密码：

   ```sh
   vncpasswd
   ```

2. 编辑 `/etc/tigervnc/vncserver.users` 配置用户端口映射。

   ```sh
   sudo vim /etc/tigervnc/vncserver.users
   ```

   默认情况下，`:1` 是 5091 端口（5090+1），`:2` 是 5092 端口，依次类推。

   假设用户名为 `user1`，将其映射到 5091 端口：

   ```
   :1 user1
   ```

3. 创建或编辑 `~/.config/tigervnc/config` 配置文件：

   ```sh
   vim ~/.config/tigervnc/config
   ```

   至少需要填写 `session` 字段参数，填入桌面启动命令，以 xfce 桌面为例，启动命令为 `startxfce4`：

   ```
   session=startxfce4
   geometry=1920x1080
   localhost
   alwaysshared
   ```

### 启动服务

临时启动服务，需要指定端口。默认情况下，`:1` 表示 5091 端口：

```sh
vncserver :1
```

持久化服务，同样需要加端口：

```sh
sudo systemctl start vncserver@:1.service
```

> 停止服务将 `start` 换成 `stop`，重启换成 `restart`，开机自启换成 `enable --now`

### 连接服务

#### 使用vnc客户端

在其他设备上安装 vnc 客户端，如 tigervnc。

- 方式一：可以直接访问显示端口，但是这种方式不安全，缺乏身份验证机制，建议只在受信任的局域网内使用。

  假设 vnc 服务在 10.1.10.2 地址的 5901 端口上运行，端口号也可以简写为 `:1`

  ```
  vncserver 10.1.10.2:1
  ```

  这种方式需要服务器防火墙开放对应的端口（如5901）

- 方式二：通过 SSH 端口转发，这种方式更安全。

  ```sh
  ssh user1@10.1.10.2 -L 9901:localhost:5901
  ```

  > 上面这个命令的意思是：通过 ssh 登录远程后，将远程的 5901 端口转发到本地的 9901 端口。

  通过 SSH 连接后，保持这个 shell 窗口开启，因为它将作为服务器的安全隧道。或者，直接在后台使用 `-f` 选项运行 SSH。

  然后启动 vnc 客户端

  ```sh
  vncviewer localhost:9901
  ```

  这种方式会复用 ssh 端口，无需服务器开放 vnc 端口。

#### 基于novnc实现浏览器访问

这种方式不需要安装 vnc 客户端，可以直接在浏览器中访问。缺点是快捷键可能会跟浏览器或系统冲突。

服务器安装 novnc，这个包在 AUR 里：

```sh
yay -S novnc

# 或
paru -S novnc
```

服务器启动 vncserver 后，启动 novnc。转发的端口可任意指定，这里设为 6081：

```sh
novnc --listen 6081 --vnc localhost:5901
```

然后远程就可以用浏览器访问，假设服务器 ip 为 10.1.10.2：

```
http://10.1.10.2:6081/vnc.html
```
