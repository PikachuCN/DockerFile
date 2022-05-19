#!/bin/bash
echo
echo -e "Xray WS自动部署脚本 2022-5-19"



ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
mkdir /etc/xray/
wget https://github.com/XTLS/Xray-core/releases/download/v1.5.3/Xray-linux-64.zip
unzip Xray-linux-64.zip -d /etc/xray/
chmod +x /etc/xray/xray
mkdir /var/log/xray/

cat > /etc/xray/config.json<<-EOF
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

cat > /root/start.sh<<-EOF
	/etc/xray/xray -config /etc/xray/config.json
	tail -f /dev/null
EOF
chmod 755 /root/start.sh
rm Xray-linux-64.zip
