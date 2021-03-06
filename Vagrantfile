# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|

  SERVER_NAME = "server"
  config.vm.define SERVER_NAME do |subconfig|
    subconfig.vm.box = "ubuntu/bionic64"
    subconfig.vm.hostname = SERVER_NAME
    subconfig.vm.network "private_network", ip: "192.168.56.50", virtualbox__intnet: "vboxnet0"

    subconfig.vm.provider "virtualbox" do |vb|
      vb.name = "wireguard-" + SERVER_NAME
      vb.memory = "1024"
      vb.cpus = 1
    end

    subconfig.vm.provision "shell", inline: <<-SHELL
      add-apt-repository -y ppa:wireguard/wireguard
      apt-get update
      apt-get install -y wireguard qrencode zsh wget
      echo "net.ipv4.ip_forward = 1" >> /etc/sysctl.d/wg.conf
      echo "net.ipv6.conf.all.forwarding = 1" >> /etc/sysctl.d/wg.conf
      sysctl --system
      cp /vagrant/wireguard.ufw.conf /etc/ufw/applications.d/wireguard
      cp /vagrant/udp2raw.ufw.conf /etc/ufw/applications.d/udp2raw
      ufw allow OpenSSH
      ufw allow WireGuard
      ufw allow udp2raw
      yes | ufw enable

      wget --no-verbose https://github.com/wangyu-/udp2raw-tunnel/releases/download/20181113.0/udp2raw_binaries.tar.gz
      tar -zxvf udp2raw_binaries.tar.gz udp2raw_amd64_hw_aes
      mv udp2raw_amd64_hw_aes /opt/udp2raw_amd64_hw_aes
      cp /vagrant/udp2raw-wireguard.service /etc/systemd/system/udp2raw-wireguard.service
    SHELL

    subconfig.vm.provision "shell", run: "always", inline: <<-SHELL
      cp /vagrant/server-conf/wg0.conf /etc/wireguard/wg0.conf
      systemctl start wg-quick@wg0
      systemctl start udp2raw-wireguard
    SHELL
  end

  CLIENT_ONE_NAME = "client01"
  config.vm.define CLIENT_ONE_NAME do |subconfig|
    subconfig.vm.box = "ubuntu/bionic64"
    subconfig.vm.hostname = CLIENT_ONE_NAME
    subconfig.vm.network "private_network", ip: "192.168.56.51", virtualbox__intnet: "vboxnet0"

    subconfig.vm.provider "virtualbox" do |vb|
      vb.name = "wireguard-" + CLIENT_ONE_NAME
      vb.memory = "1024"
      vb.cpus = 1
    end

    subconfig.vm.provision "shell", inline: <<-SHELL
      add-apt-repository -y ppa:wireguard/wireguard
      apt-get update
      apt-get install -y wireguard resolvconf
    SHELL

    subconfig.vm.provision "shell", run: "always", inline: <<-SHELL
      cp /vagrant/client01-conf/wg0.conf /etc/wireguard/wg0.conf
      wg-quick up wg0
    SHELL
  end

  CLIENT_TWO_NAME = "client02"
  config.vm.define CLIENT_TWO_NAME do |subconfig|
    subconfig.vm.box = "ubuntu/bionic64"
    subconfig.vm.hostname = CLIENT_TWO_NAME
    subconfig.vm.network "private_network", ip: "192.168.56.52", virtualbox__intnet: "vboxnet0"

    subconfig.vm.provider "virtualbox" do |vb|
      vb.name = "wireguard-" + CLIENT_TWO_NAME
      vb.memory = "1024"
      vb.cpus = 1
    end

    subconfig.vm.provision "shell", inline: <<-SHELL
      add-apt-repository -y ppa:wireguard/wireguard
      apt-get update
      apt-get install -y wireguard
    SHELL

    subconfig.vm.provision "shell", run: "always", inline: <<-SHELL
      cp /vagrant/client02-conf/wg0.conf /etc/wireguard/wg0.conf
      wg-quick up wg0
    SHELL
  end

  CLIENT_THREE_NAME = "client03"
  config.vm.define CLIENT_THREE_NAME do |subconfig|
    subconfig.vm.box = "ubuntu/bionic64"
    subconfig.vm.hostname = CLIENT_THREE_NAME
    subconfig.vm.network "private_network", ip: "192.168.56.53", virtualbox__intnet: "vboxnet0"

    subconfig.vm.provider "virtualbox" do |vb|
      vb.name = "wireguard-" + CLIENT_THREE_NAME
      vb.memory = "1024"
      vb.cpus = 1
    end

    subconfig.vm.provision "shell", inline: <<-SHELL
      add-apt-repository -y ppa:wireguard/wireguard
      apt-get update
      apt-get install -y wireguard resolvconf wget

      wget --no-verbose https://github.com/wangyu-/udp2raw-tunnel/releases/download/20181113.0/udp2raw_binaries.tar.gz
      tar -zxvf udp2raw_binaries.tar.gz udp2raw_amd64_hw_aes
      mv udp2raw_amd64_hw_aes /opt/udp2raw_amd64_hw_aes
      cp /vagrant/udp2raw-client.service /etc/systemd/system/udp2raw-client.service
    SHELL

    subconfig.vm.provision "shell", run: "always", inline: <<-SHELL
      cp /vagrant/client03-conf/wg0.conf /etc/wireguard/wg0.conf
      systemctl start udp2raw-client
      wg-quick up wg0
    SHELL
  end
end
