WireGuard Setup Demo
====================

This is a cluster of vagrant VMs that uses WireGuard to communicate with each other. This was created mainly for me to record the WireGuard setup in case I need to recreate it in the future. Putting it on GitHub in order to help anybody else who wishes to setup a WireGuard VPN.

Virtual Machines
----------------

- **server**: This VM runs the WireGuard server. It also has the ufw firewall enabled (this repository includes the configuration for allowing WireGuard through the firewall).
- **client01**: This VM connects to the server and **routes internet** traffic via the VPN. This setup can be used for privacy or for bypassing reginal/governmental/ISP/organizational restrictions. 
- **client02**: This VM connects to the server and **does not route internet** traffic via the VPN. This setup can be used in order to make internal network resources available to devices connected to the VPN. It can also be used to make internal network resources available to connected devices without needing port forwarding. For example, my raspberrypi at home connects to a DigitalOcean server running WireGuard using this setup. This allows me to connect to my VPN from my laptop/phone from anywhere in the world, and still access resources on my home raspberrypi (such as SSH and SMB shares), without needing to open up ports on my home router. 

Common Commands
---------------

- Run Vagrant cluster: `vagrant up`
- Run only particular VM: `vagrant up <vm_name>`
- SSH into particular VM: `vagrant ssh <vm_name>`
- Destroy Vagrant cluster: `vagrant destroy`
- Set umask before generating keys: `umask 077`
- Generate keys: `wg genkey | tee privatekey | wg pubkey > publickey`
- Start WireGuard: `wg-quick up wg0`
- Stop WireGuard: `wg-quick down wg0`
- Start WireGuard as systemd service: `systemctl start wg-quick@wg0`
- Enable WireGuard systemd service to start on system boot: `systemctl enable wg-quick@wg0`
- Stop WireGuard as systemd service: `systemctl stop wg-quick@wg0`
- View WireGuard configuration: `wg show`
- View WireGuard interface information: `ifconfig wg0`
- Monitor network traffic on WireGuard interface: `tcpdump -i wg0`

Warning
-------

If you decide to use this setup, please generate your own keys and replace all the keys in the configuration files. **The keys in this repository are not used anywhere else and should not be used anywhere else**. 
