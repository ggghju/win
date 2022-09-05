#!/bin/bash

# =========================================================
# System Request:CentOS 7+ 、Debian 8+、Ubuntu 16+
# Origin Author:lmc999
# Dscription: Wireguard游戏加速器一键脚本
# Version: 2.0
# Github:https://github.com/lmc999/WireguardForGame
# TG交流群: https://t.me/gameaccelerate
# =========================================================

Green="\033[32m"
Font="\033[0m"
Blue="\033[33m"

NIC="$(ip -4 route ls | grep default | grep -Po '(?<=dev )(\S+)' | head -1)"

rootness(){
    if [[ $EUID -ne 0 ]]; then
       echo -e "${Blue}此脚本必须以root用户运行!即将退出程序...${Font}" 1>&2
       exit 1
    fi
}

checkos(){
    source /etc/os-release
    OS=$ID
    VERSION=$VERSION_ID
}






# Configure auto start on boot
auto_start(){
    echo -e "${Green}正在配置加速程序开机自启${Font}"
    nohup ./speederv2_amd64 -s -l0.0.0.0:9999 -r127.0.0.1:54179 -k  "atrandys" --mode 0 -f2:4 -q1 >speeder.log 2>&1 &
    if [ "${OS}" == 'CentOS' ];then
        sed -i '/exit/d' /etc/rc.d/rc.local
        echo "nohup ./speederv2_amd64 -s -l0.0.0.0:9999 -r127.0.0.1:54179 -k  "atrandys" --mode 0 -f2:4 -q1 >speeder.log 2>&1 & " >> /etc/rc.d/rc.local
        chmod +x /etc/rc.d/rc.local
    elif [ -s /etc/rc.local ]; then
        sed -i '/exit/d' /etc/rc.local
        echo "nohup ./speederv2_amd64 -s -l0.0.0.0:9999 -r127.0.0.1:54179 -k  "atrandys" --mode 0 -f2:4 -q1 >speeder.log 2>&1 & " >> /etc/rc.local
        chmod +x /etc/rc.local
    else
echo -e "${Green}检测到系统无rc.local自启，正在为其配置... ${Font} "
echo "[Unit]
Description=/etc/rc.local
ConditionPathExists=/etc/rc.local
 
[Service]
Type=forking
ExecStart=/etc/rc.local start
TimeoutSec=0
StandardOutput=tty
RemainAfterExit=yes
SysVStartPriority=99
 
[Install]
WantedBy=multi-user.target
" > /etc/systemd/system/rc-local.service
echo "#!/bin/sh -e
#
# rc.local
#
# This script is executed at the end of each multiuser runlevel.
# Make sure that the script will "exit 0" on success or any other
# value on error.
#
# In order to enable or disable this script just change the execution
# bits.
#
# By default this script does nothing.
" > /etc/rc.local
echo "nohup ./speederv2_amd64 -s -l0.0.0.0:9999 -r127.0.0.1:54179 -k  "atrandys" --mode 0 -f2:4 -q1 >speeder.log 2>&1 & " >> /etc/rc.local
chmod +x /etc/rc.local
systemctl enable rc-local >/dev/null 2>&1
systemctl start rc-local >/dev/null 2>&1
    fi
    sleep 3
    echo
    echo -e "${Blue}Wireguard游戏加速程序安装并配置成功!${Font}"    
    exit 0
}

rootness
checkos
auto_start
