#!/bin/bash
echo
echo -e "Xray 部署脚本 Debian 10系统"
apt update -y
apt -y install unzip curl
curl -L https://github.com/XTLS/Xray-install/raw/main/install-release.sh | bash -s -- install
chmod 777 /usr/local/etc/xray/config.json
cat > /usr/local/etc/xray/config.json<<-EOF
{
    "log": {
        "loglevel": "warning"
    },
    "routing": {
        "domainStrategy": "AsIs",
        "rules": [
            {
                "type": "field",
                "ip": [
                    "geoip:private"
                ],
                "outboundTag": "block"
            }
        ]
    },
    "inbounds": [
        {
            "listen": "0.0.0.0",
            "port": 443,
            "protocol": "vmess",
            "settings": {
                "clients": [
                    {
                        "id": "c6bdab75-75be-446a-84f9-2fee409b725d"
                    }
                ]
            },
            "streamSettings": {
                "network": "ws",
                "security": "none"
            }
        }
    ],
    "outbounds": [
        {
            "protocol": "freedom",
            "tag": "direct"
        },
        {
            "protocol": "blackhole",
            "tag": "block"
        }
    ]
}
EOF

  sed -i '/net.ipv4.tcp_ecn/d' /etc/sysctl.d/99-sysctl.conf
  sed -i '/net.core.default_qdisc/d' /etc/sysctl.d/99-sysctl.conf
  sed -i '/net.ipv4.tcp_congestion_control/d' /etc/sysctl.d/99-sysctl.conf
  sed -i '/net.ipv4.tcp_ecn/d' /etc/sysctl.conf
  sed -i '/net.core.default_qdisc/d' /etc/sysctl.conf
  sed -i '/net.ipv4.tcp_congestion_control/d' /etc/sysctl.conf
  sysctl --system

  rm -rf bbrmod

  if [[ -e /appex/bin/lotServer.sh ]]; then
    echo | bash <(wget -qO- https://git.io/lotServerInstall.sh) uninstall
  fi
  clear
  # echo -e "${Info}:清除bbr/lotserver加速完成。"
  # sleep 1s

 echo "net.core.default_qdisc=fq" >>/etc/sysctl.d/99-sysctl.conf
 echo "net.ipv4.tcp_congestion_control=bbr" >>/etc/sysctl.d/99-sysctl.conf
 sysctl --system
echo -e "${Info}BBR+FQ修改成功，重启生效！"
systemctl enable xray
systemctl restart xray
echo -e "安装完成！"
echo "正在获取 IP 地址信息，请耐心等待"
local_ip=$(curl -4L api64.ipify.org)
echo -e "wmess IP为${local_ip}"
reboot
