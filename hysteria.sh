echo -e Start Installing hysteria 1.3.2

curl -L https://github.com/apernet/hysteria/releases/download/v1.3.2/hysteria-linux-amd64 --output hysteria
chmod 777 hysteria
openssl ecparam -genkey -name prime256v1 -noout -out my.key
openssl req -new -x509 -days 3650 -key my.key -out my.crt -subj "/C=US/O=DigiCert Inc. /CN=DigiCert Local Root CA"
cat > config.json<<-EOF
{
  "listen": ":38888",
  "cert": "my.crt",
  "key": "my.key",
  "obfs": "8ZuA2Zpqhuk8yakXvMjDqEXBwY"
}

EOF
cat >/etc/systemd/system/hysteria-server.service << EOF
[Unit]
Description=Hysteria Server Service
After=network.target

[Service]
Type=simple
ExecStart=/home/admin/hysteria server
WorkingDirectory=/home/admin/
CapabilityBoundingSet=CAP_NET_ADMIN CAP_NET_BIND_SERVICE CAP_NET_RAW
AmbientCapabilities=CAP_NET_ADMIN CAP_NET_BIND_SERVICE CAP_NET_RAW
NoNewPrivileges=true

[Install]
WantedBy=multi-user.target
EOF


systemctl daemon-reload
systemctl start hysteria-server
systemctl enable hysteria-server
echo -e The hysteria installation has been completed and boot-up has been configured
