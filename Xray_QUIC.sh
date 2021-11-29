#!/bin/bash
echo
echo -e "Xray 部署脚本 Debian 10系统"
apt update -y
apt install unzip curl
curl -L https://github.com/XTLS/Xray-install/raw/main/install-release.sh | bash -s -- install
chmod 777 /usr/local/etc/xray/config.json
cat > /usr/local/etc/xray/config.json<<-EOF
{
	"inbounds": [{
		"port": 3389,
		"listen": "0.0.0.0",
		"tag": "VLESS-in",
		"protocol": "VLESS",
		"settings": {
			"clients": [{
				"id": "c6bdab75-75be-446a-84f9-2fee409b725d",
				"alterId": 0
			}],
			"decryption": "none"
		},
		"streamSettings": {
			"network": "quic",
			"quicSettings": {
				"key": "",
				"header": {
					"type": "none"
				}
			}
		}
	}],
	"outbounds": [{
			"protocol": "freedom",
			"settings": {},
			"tag": "direct"
		},
		{
			"protocol": "blackhole",
			"settings": {},
			"tag": "blocked"
		}
	],
	"dns": {
		"servers": [
			"https+local://1.1.1.1/dns-query",
			"1.1.1.1",
			"1.0.0.1",
			"8.8.8.8",
			"8.8.4.4",
			"localhost"
		]
	},
	"routing": {
		"domainStrategy": "AsIs",
		"rules": [{
			"type": "field",
			"inboundTag": [
				"VLESS-in"
			],
			"outboundTag": "direct"
		}]
	}
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
echo -e "vless://c6bdab75-75be-446a-84f9-2fee409b725d@${local_ip}:3389?encryption=none&security=none&type=quic&headerType=none&quicSecurity=&key=#12.qspp.net"
