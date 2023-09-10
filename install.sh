#!/bin/bash

# Set constants
SERVICE_NAME="wireguard-multihop-service"
SERVICE_PATH="/etc/systemd/system/$SERVICE_NAME.service"
SCRIPT_PATH="/opt/wireguard-multihop-service/wireguard_service.py"
CONFIG_PATH="/etc/wireguard-multihop-service/config.toml"
CONFIG_EXAMPLE_PATH="./config.toml.example"

echo "Starting installation of WireGuard Multi-hop Service..."

# Copy the Python script to /opt/
sudo mkdir -p /opt/wireguard-multihop-service
sudo cp ./src/wireguard_service.py $SCRIPT_PATH
sudo chmod +x $SCRIPT_PATH

# Check for existing WireGuard configurations
CONFIGS=$(ls /etc/wireguard/*.conf)
echo "Found the following WireGuard configurations:"
echo "$CONFIGS"
echo ""

# Prompt user to create the first route
read -p "Enter the starting WireGuard config path (e.g., /etc/wireguard/server1.conf): " FIRST_CONFIG
read -p "Enter the next hop in the route (e.g., /etc/wireguard/server2.conf): " SECOND_CONFIG
read -p "Enter the WAN interface (commonly 'eth0' or 'wlan0'): " WAN_INTERFACE

# Generate config.toml based on user input
echo "[[chain]]
interfaces = [\"$FIRST_CONFIG\", \"$SECOND_CONFIG\"]
wan_interface = \"$WAN_INTERFACE\"

[system]
enable_ip_forwarding = true
" | sudo tee $CONFIG_PATH > /dev/null

# Create the service file for systemd
echo "[Unit]
Description=Wireguard Multi-hop Service
After=network.target

[Service]
ExecStart=/usr/bin/python3 $SCRIPT_PATH
Restart=always

[Install]
WantedBy=multi-user.target
" | sudo tee $SERVICE_PATH > /dev/null

# Reload systemd, enable and start the service
sudo systemctl daemon-reload
sudo systemctl enable $SERVICE_NAME.service
sudo systemctl start $SERVICE_NAME.service

echo "Installation completed. Check service status with: sudo systemctl status $SERVICE_NAME.service"
