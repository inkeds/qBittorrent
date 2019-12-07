#!/bin/bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH
#=================================================================#
#   System Required: CentOS 7 X86_64                              #
#   Description: qBittorrent Soft Install                         #
#   Author: LALA <QQ1062951199>                                   #
#   Website: https://www.lala.im                                  #
#=================================================================#

clear
echo
echo "#############################################################"
echo "# qBittorrent Soft Install                                  #"
echo "# Author: LALA <QQ1062951199>                               #"
echo "# Website: https://www.lala.im                              #"
echo "# System Required: CentOS 7 X86_64                          #"
echo "#############################################################"
echo

# Color
red='\033[0;31m'
green='\033[0;32m'
yellow='\033[0;33m'
font="\033[0m"

# HostIP input
read -p "请输入你的主机公网IP地址:" HostIP

# CPUcore input
read -p "选择使用多少个CPU线程进行编译（多个线程将有效提升编译效率）:" CPUcore

# Create Swap
read -p "如果机器内存小于2GB需临时创建Swap,是否创建Swap?（yes/no）:" Choose
if [ $Choose = "yes" ];then
	dd if=/dev/zero of=/var/swap bs=1024 count=2097152
	mkswap /var/swap
	chmod 0600 /var/swap
	swapon /var/swap
fi
if [ $Choose = "no" ]
then
    echo -e "${yellow} 你选择不创建swap,脚本将继续进行下一步操作 ${font}"
fi

# Disable SELinux Function
disable_selinux(){
    if [ -s /etc/selinux/config ] && grep 'SELINUX=enforcing' /etc/selinux/config; then
        sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/selinux/config
        setenforce 0
    fi
}
# Stop SElinux
disable_selinux

# Disable Firewalld
systemctl stop firewalld.service
systemctl disable firewalld.service

# Update System
yum -y update
if [ $? -eq 0 ];then
    echo -e "${green} 系统更新完成 ${font}"
else 
    echo -e "${red} 系统更新失败 ${font}"
    exit 1
fi

# Install Required
cd ~
yum -y install wget
if [ $? -eq 0 ];then
    echo -e "${green} Wget安装成功 ${font}"
else 
    echo -e "${red} Wget安装失败 ${font}"
    exit 1
fi
yum -y install git
if [ $? -eq 0 ];then
    echo -e "${green} Git安装成功 ${font}"
else 
    echo -e "${red} Git安装失败 ${font}"
    exit 1
fi
yum -y install epel-release
if [ $? -eq 0 ];then
    echo -e "${green} EPEL源安装成功 ${font}"
else 
    echo -e "${red} EPEL源安装失败 ${font}"
    exit 1
fi
yum -y groupinstall "Development Tools"
if [ $? -eq 0 ];then
    echo -e "${green} 开发工具包安装成功 ${font}"
else 
    echo -e "${red} 开发工具包安装失败 ${font}"
    exit 1
fi

# Install qBittorrent Required
yum -y install gcc gcc-c++ qt-devel boost-devel openssl-devel qt5-qtbase-devel qt5-linguist
if [ $? -eq 0 ];then
    echo -e "${green} qBittorrent编译所需依赖安装成功 ${font}"
else 
    echo -e "${red} qBittorrent编译所需依赖安装失败 ${font}"
    exit 1
fi

# Install libtorrent
cd ~
wget --no-check-certificate https://github.com/arvidn/libtorrent/releases/download/libtorrent-1_1_9/libtorrent-rasterbar-1.1.9.tar.gz
if [ $? -eq 0 ];then
    echo -e "${green} libtorrent软件包下载成功 ${font}"
else 
    echo -e "${red} libtorrent软件包下载失败 ${font}"
    exit 1
fi
tar -zxf libtorrent-rasterbar-1.1.9.tar.gz
cd libtorrent-rasterbar-1.1.9
./configure --prefix=/usr CXXFLAGS=-std=c++11
make -j${CPUcore}
make install
if [ $? -eq 0 ];then
    echo -e "${green} libtorrent编译成功 ${font}"
else 
    echo -e "${red} libtorrent编译失败 ${font}"
    exit 1
fi
ln -s /usr/lib/pkgconfig/libtorrent-rasterbar.pc /usr/lib64/pkgconfig/libtorrent-rasterbar.pc
ln -s /usr/lib/libtorrent-rasterbar.so.9 /usr/lib64/libtorrent-rasterbar.so.9
if [ $? -eq 0 ];then
    echo -e "${green} libtorrent软连接创建成功 ${font}"
else 
    echo -e "${red} libtorrent软连接创建失败 ${font}"
    exit 1
fi

# Install qBittorrent
cd ~
wget --no-check-certificate https://github.com/qbittorrent/qBittorrent/archive/release-4.1.1.tar.gz
if [ $? -eq 0 ];then
    echo -e "${green} qBittorrent软件包下载成功 ${font}"
else 
    echo -e "${red} qBittorrent软件包下载失败 ${font}"
    exit 1
fi
tar -xzvf release-4.1.1.tar.gz
cd qBittorrent-release-4.1.1
./configure --prefix=/usr --disable-gui CPPFLAGS=-I/usr/include/qt5 CXXFLAGS=-std=c++11
make -j${CPUcore}
make install
if [ $? -eq 0 ];then
    echo -e "${green} qBittorrent安装成功 ${font}"
else 
    echo -e "${red} qBittorrent安装失败 ${font}"
    exit 1
fi

# Create Systemd File
touch /usr/lib/systemd/system/qbittorrent.service
cat > /usr/lib/systemd/system/qbittorrent.service <<EOF
[Unit]
Description=qbittorrent torrent server
    
[Service]
User=root
ExecStart=/usr/bin/qbittorrent-nox
Restart=on-abort
    
[Install]
WantedBy=multi-user.target
EOF

# Setting qBittorrent Boot Running
systemctl enable qbittorrent

# Start qBittorrent
systemctl start qbittorrent

echo
echo "#############################################################"
echo "# qBittorrent Installation Complete                         #"
echo "# Web Panel: http://${HostIP}:8080                          #"
echo "# Web Account: admin                                        #"
echo "# Web Password: adminadmin                                  #"
echo "#############################################################"
echo