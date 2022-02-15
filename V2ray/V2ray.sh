#!/bin/bash
echo
echo -e "V2ray 自动部署脚本 149"



ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
mkdir /etc/v2ray/
wget https://github.com/v2ray/dist/raw/master/v2ray-linux-64.zip
unzip v2ray-linux-64.zip -d /etc/v2ray/
chmod +x /etc/v2ray/v2ray
mkdir /var/log/v2ray/

cat > /etc/v2ray/config.json<<-EOF
{
	"log": {
		"access": "/var/log/v2ray/access.log",
		"error": "/var/log/v2ray/error.log",
		"loglevel": "warning"
	},
	"inbounds": [
		{
			"port": 3389,
			"protocol": "vmess",
			"settings": {
				"clients": [
					{
						"id": "c6bdab75-75be-446a-84f9-2fee409b725d",
						"level": 1,
						"alterId": 233
					}
				]
			},
			"streamSettings": {
				"network": "quic",
				"quicSettings": {
                                        "key": "",
                                        "header": {
                                                "type": "none"
                                        }
                                }
			},
			"sniffing": {
				"enabled": true,
				"destOverride": [
					"http",
					"tls"
				]
			}
		}
		//include_ss
		//include_socks
		//include_mtproto
		//include_in_config
		//
	],
	"outbounds": [
		{
			"protocol": "freedom",
			"settings": {
				"domainStrategy": "UseIP"
			},
			"tag": "direct"
		},
		{
			"protocol": "blackhole",
			"settings": {},
			"tag": "blocked"
        },
		{
			"protocol": "mtproto",
			"settings": {},
			"tag": "tg-out"
		}
		//include_out_config
		//
	],
	"dns": {
		"servers": [
			"https+local://cloudflare-dns.com/dns-query",
			"1.1.1.1",
			"1.0.0.1",
			"8.8.8.8",
			"8.8.4.4",
			"localhost"
		]
	},
	"routing": {
		"domainStrategy": "IPOnDemand",
		"rules": [
			{
				"type": "field",
				"ip": [
					"0.0.0.0/8",
					"10.0.0.0/8",
					"100.64.0.0/10",
					"127.0.0.0/8",
					"169.254.0.0/16",
					"172.16.0.0/12",
					"192.0.0.0/24",
					"192.0.2.0/24",
					"192.168.0.0/16",
					"198.18.0.0/15",
					"198.51.100.0/24",
					"203.0.113.0/24",
					"::1/128",
					"fc00::/7",
					"fe80::/10"
				],
				"outboundTag": "blocked"
			},
			{
				"type": "field",
				"inboundTag": ["tg-in"],
				"outboundTag": "tg-out"
			}
			,
			{
				"type": "field",
				"domain": [
					"domain:epochtimes.com",
					"domain:epochtimes.com.tw",
					"domain:epochtimes.fr",
					"domain:epochtimes.de",
					"domain:epochtimes.jp",
					"domain:epochtimes.ru",
					"domain:epochtimes.co.il",
					"domain:epochtimes.co.kr",
					"domain:epochtimes-romania.com",
					"domain:erabaru.net",
					"domain:lagranepoca.com",
					"domain:theepochtimes.com",
					"domain:ntdtv.com",
					"domain:ntd.tv",
					"domain:ntdtv-dc.com",
					"domain:ntdtv.com.tw",
					"domain:minghui.org",
					"domain:renminbao.com",
					"domain:dafahao.com",
					"domain:dongtaiwang.com",
					"domain:falundafa.org",
					"domain:wujieliulan.com",
					"domain:ninecommentaries.com",
					"domain:shenyun.com"
				],
				"outboundTag": "blocked"
			}			,
                {
                    "type": "field",
                    "protocol": [
                        "bittorrent"
                    ],
                    "outboundTag": "blocked"
                }
			//include_ban_ad
			//include_rules
			//
		]
	},
	"transport": {
		"kcpSettings": {
            "uplinkCapacity": 100,
            "downlinkCapacity": 100,
            "congestion": true
        }
	}
}
EOF

cat > /root/start.sh<<-EOF
	/etc/v2ray/v2ray -config /etc/v2ray/config.json
	tail -f /dev/null
EOF
chmod 755 /root/start.sh
rm v2ray-linux-64.zip
