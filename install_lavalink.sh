#!/bin/bash

# Update and upgrade the system
echo "Updating system..."
sudo apt update && sudo apt upgrade -y

# Install Java
echo "Installing Java..."
sudo apt install openjdk-11-jre-headless -y

# Verify Java installation
java_version=$(java -version 2>&1)
echo "Java version installed: $java_version"

# Download LavaLink.jar
echo "Downloading LavaLink.jar..."
wget https://github.com/DFanso/lavalink-server/blob/main/Lavalink.jar -O /opt/Lavalink.jar

# Create LavaLink configuration file
echo "Creating application.yml..."
cat <<EOL | sudo tee /opt/application.yml
server:
  port: 8080
  address: 0.0.0.0
lavalink:
  server:
    password: "dfanso"
    sources:
      youtube: true
      bandcamp: true
      soundcloud: true
      twitch: true
      vimeo: true
      http: true
    bufferDurationMs: 4000
    youtubePlaylistLoadLimit: 6
    playerUpdateInterval: 5
    youtubeSearchEnabled: true
    soundcloudSearchEnabled: true
metrics:
  prometheus:
    enabled: false
    endpoint: /metrics
  influx:
    enabled: false
    dbName: lavalink
    hostname: localhost
    port: 8086
    username: admin
    password: password
EOL

# Create a systemd service file for LavaLink
echo "Creating lavalink.service..."
cat <<EOL | sudo tee /etc/systemd/system/lavalink.service
[Unit]
Description=LavaLink
After=network.target

[Service]
User=root
WorkingDirectory=/opt
ExecStart=/usr/bin/java -jar /opt/Lavalink.jar
SuccessExitStatus=143
TimeoutStopSec=10
Restart=on-failure
RestartSec=5

[Install]
WantedBy=multi-user.target
EOL

# Reload systemd daemon
echo "Reloading systemd daemon..."
sudo systemctl daemon-reload

# Enable and start the LavaLink service
echo "Enabling and starting lavalink.service..."
sudo systemctl enable lavalink.service
sudo systemctl start lavalink.service

# Check the status of the service
echo "Checking the status of lavalink.service..."
sudo systemctl status lavalink.service

echo "LavaLink installation and setup complete!"
