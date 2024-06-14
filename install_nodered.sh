#!/bin/bash

# Aktualizace systému
sudo apt-get update
sudo apt-get upgrade -y

# Instalace Node.js (Node-RED vyžaduje Node.js 12.x nebo vyšší)
curl -sL https://deb.nodesource.com/setup_14.x | sudo -E bash -
sudo apt-get install -y nodejs

# Instalace build-essential pro kompilaci nativních doplňků
sudo apt-get install -y build-essential

# Instalace Node-RED
sudo npm install -g --unsafe-perm node-red

# Vytvoření adresáře pro Node-RED
mkdir -p ~/.node-red
cd ~/.node-red

# Instalace příslušných knihoven
npm install node-red-node-mysql
npm install node-red-node-email
npm install node-red-contrib-iiot
npm install node-red-contrib-mcp23017
npm install node-red-contrib-ncd-comm
npm install node-red-contrib-owfs
npm install node-red-node-pi-dht22
npm install node-red-node-pi-gpio

# Instalace OWFS
sudo apt-get install -y owfs ow-shell owserver

# Konfigurace OWFS
echo 'server: usb = all' | sudo tee -a /etc/owfs.conf
echo 'mountpoint = /mnt/1wire' | sudo tee -a /etc/owfs.conf
sudo mkdir -p /mnt/1wire
sudo chown -R pi:pi /mnt/1wire

# Povolení I2C
sudo raspi-config nonint do_i2c 0

# Povolení 1-WIRE
sudo raspi-config nonint do_onewire 0

# Restart OWFS služby
sudo systemctl restart owserver

# Spuštění Node-RED
node-red-start

# Automatické spuštění Node-RED při startu systému
sudo systemctl enable nodered.service

echo "Node-RED a všechny příslušné knihovny byly nainstalovány, OWFS je nastaven a Node-RED je spuštěn. Můžete přistupovat k Node-RED na http://<vaše_ip>:1880/"
