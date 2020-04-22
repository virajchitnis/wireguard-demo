#!/bin/zsh

# This script automates the addition of a new device to the VPN server. 
# It will create a new directory by the name of the device, and store the keys and congiruation in this directory. 
# Finally, it will display the qrcode for adding the configuration to a mobile device on screen. 
# Change the IP subnets, endpoint, and server public key as per your needs.

# This script also requires a file called 'latest_ip' to be present in the same directory. This file should contain the last part of the IP address that you want to start your device list after. 
# For example, if you want the first device in your VPN to have the IP 10.0.0.10, the 'latest_ip' file should contain 9. 
# The 'latest_ip' file will be automatically updated in order to keep track of the latest IP in use. 

DEVICE_NAME=$1

mkdir ${DEVICE_NAME}
cd ${DEVICE_NAME}
umask 077
wg genkey | tee privatekey | wg pubkey > publickey
wg genpsk > presharedkey

IP=$(($(cat ../latest_ip)+1))
PRIVATE_KEY=$(cat privatekey)
PUBLIC_KEY=$(cat publickey)
PRESHARED_KEY=$(cat presharedkey)
IP_HEX=$(([##16]IP))

cat >wg0.conf <<EOL
[Interface]
PrivateKey = ${PRIVATE_KEY}
Address = 10.0.0.${IP}/24, fd86:ea04:1115::${IP_HEX:l}/64
DNS = 10.0.0.1, fd86:ea04:1115::1

[Peer]
PublicKey = 78eIdV4yEnLgB2ecXmViEc9/Y3PIhYxwIdUT9mIVry0=
PresharedKey = ${PRESHARED_KEY}
Endpoint = 192.168.56.50:51820
AllowedIPs = 0.0.0.0/0, ::/0
EOL

sudo systemctl stop wg-quick@wg0.service
sudo tee -a /etc/wireguard/wg0.conf > /dev/null <<EOT

[Peer]
# ${DEVICE_NAME}
PublicKey = ${PUBLIC_KEY}
PresharedKey = ${PRESHARED_KEY}
AllowedIPs = 10.0.0.${IP}/32, fd86:ea04:1115::${IP_HEX:l}/128
EOT
sudo systemctl start wg-quick@wg0.service

echo $IP > ../latest_ip
qrencode -t ansiutf8 < config.conf