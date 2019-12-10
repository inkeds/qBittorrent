# qBittorrent一键脚本

centos7专用qBittorrent一键安装包。
本脚本来自荒岛博客，作者lala。[原文地址](https://lala.im/4036.html)

# 安装说明

<font color=#FF0000 >**脚本仅支持CentOS7，64位系统！！！请使用纯净的系统安装！！！请使用ROOT用户执行脚本！！！**</font>

# 使用方法

1、使用

```python
wget https://raw.githubusercontent.com/inkeds/qBittorrent/master/qBittorrentCentOS7install.sh && chmod +x qBittorrentCentOS7install.sh
```

2、安装

```
./qBittorrentCentOS7install.sh
```

# 说明

因为编译libtorrent的时候需要用到大量的内存，小于2GB的机器可能会因为内存不足导致进程被杀掉，创建的swap文件保存在/var目录下，安装完成之后可以自己手动删除掉。

脚本编译时有使用多个CPU线程的功能，根据你自己机器的CPU核心数来设置就行了。
