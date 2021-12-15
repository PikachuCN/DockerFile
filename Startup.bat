@echo off
rem >>正在开启远程桌面
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Terminal Server" /v fDenyTSConnections /t REG_DWORD /d 0 /f
netsh advfirewall firewall set rule group="远程桌面" new enable=yes
netsh advfirewall set currentprofile state off
netsh advfirewall set allprofiles state off
netsh advfirewall set domainprofile state off
netsh advfirewall set privateprofile state off
netsh advfirewall set publicprofile state off

echo >>正在修改密码
net user administrator xxxxxxxx

echo >>正在激活系统
cscript //nologo c:\windows\system32\slmgr.vbs /ipk W269N-WFGWX-YVC9B-4J6C9-T83GX
cscript //nologo c:\windows\system32\slmgr.vbs /skms kms.03k.org
cscript //nologo c:\windows\system32\slmgr.vbs -ato


echo >>正在关闭电源休眠
@powercfg -change -standby-timeout-ac 0
