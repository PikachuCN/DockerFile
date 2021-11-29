#!/bin/bash
echo
echo -e "X2ray 部署脚本"
apt update
apt install unzip
curl -L https://github.com/XTLS/Xray-install/raw/main/install-release.sh | bash -s -- install
chmod 777 /usr/local/etc/xray/config.json
cat > /usr/local/etc/xray/config.json<<-EOF
{
	"inbounds": [{
		"port": 31545,
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
systemctl enable xray
systemctl restart xray
