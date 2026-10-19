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

   复制[这个文件](../../assets/config.dae)的内容，注意在 `subscription` 处填入订阅链接。

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
