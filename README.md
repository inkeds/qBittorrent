# qBittorrent一键脚本

centos7专用qBittorrent一键安装包。
本脚本来自荒岛博客，作者lala。[原文地址](https://lala.im/4036.html)

# 安装说明

<font color=#FF0000 >**脚本仅支持CentOS7，64位系统！！！请使用纯净的系统安装！！！请使用ROOT用户执行脚本！！！**</font>

因为编译libtorrent的时候需要用到大量的内存，小于2GB的机器可能会因为内存不足导致进程被杀掉，创建的swap文件保存在/var目录下，安装完成之后可以自己手动删除掉。

脚本编译时有使用多个CPU线程的功能，根据你自己机器的CPU核心数来设置就行了。

# 使用方法

CentOS7的GCC和Boost版本过低，请先升级

### 一、升级编译器

**1、升级GCC

```
yum install centos-release-scl
yum install devtoolset-7-gcc*
scl enable devtoolset-7 bash
```

**2、升级Boost

```
yum -y install wget zlib-devel bzip2-devel
wget https://dl.bintray.com/boostorg/release/1.70.0/source/boost_1_70_0.tar.gz
tar -xzvf boost_1_70_0.tar.gz
cd boost_1_70_0
```

构建参数如下：

```
./bootstrap.sh --with-libraries=all --with-python=/usr/bin/python3 --with-python-root=/usr/lib64/python3.6 --with-python-version=3.6
```

编辑如下文件：

```
nano project-config.jam
```

默认你应该可以看到下面这一段配置：

```
{
    using python : 3.6 : /usr/lib64/python3.6 ;
}
```

改为：

```
{
    using python : 3.6 : /usr/lib64/python3.6 : /usr/include/python3.6m : /lib ;
}
```

编译并安装：

```
./b2 cxxflags="--std=c++11" -j8
./b2 install --prefix=/usr
ldconfig -v
```

### 二、一键脚本安装

**1、使用

```python
wget https://raw.githubusercontent.com/inkeds/qBittorrent/master/qBittorrentCentOS7install.sh && chmod +x qBittorrentCentOS7install.sh
```

**2、安装

```
./qBittorrentCentOS7install.sh
```

