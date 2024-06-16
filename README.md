# Lavalink Server

## Installing Lavalink Server on Ubuntu

This guide will help you install the LavaLink server on an Ubuntu system. LavaLink is a Java application, so you'll need to have Java installed on your system.

### Step-by-Step Guide

#### Step 1: Update Your System

First, update your system to ensure you have the most recent packages:

```bash
sudo apt update
sudo apt upgrade -y
```

#### Step 2: Install Java

LavaLink requires Java. Install it with:

```bash
sudo apt install openjdk-11-jre-headless -y
```

Verify the installation with:

```bash
java -version
```

#### Step 3: Download LavaLink

Download the latest LavaLink.jar file from the LavaLink GitHub repository:

```bash
wget https://github.com/DFanso/lavalink-server/blob/main/Lavalink.jar
```

#### Step 4: Create a LavaLink Configuration File

LavaLink requires a configuration file named `application.yml`. Create this file in the same directory as your LavaLink.jar file:

```bash
nano application.yml
```

Copy the following configuration into `application.yml`:

```yaml
server:
  port: 8080
  address: 0.0.0.0
lavalink:
  server:
    password: "your_password_here"
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
```

Replace `"your_password_here"` with a secure password of your choice.

#### Step 5: Run LavaLink

Run LavaLink with:

```bash
java -jar Lavalink.jar
```

To run it in the background, use `screen`:

```bash
screen -S LavaLink
java -jar Lavalink.jar
```

Detach from the screen session with `CTRL+A` then `D`. Re-attach with `screen -r LavaLink`.

### Running LavaLink 24/7

To keep LavaLink running continuously, use `systemd`.

#### Step 1: Create a systemd Service File

Create a service file for LavaLink:

```bash
sudo nano /etc/systemd/system/lavalink.service
```

Add the following configuration:

```ini
[Unit]
Description=LavaLink
After=network.target

[Service]
User=your_username
WorkingDirectory=/path/to/your/lavalink/directory
ExecStart=/usr/bin/java -jar Lavalink.jar
SuccessExitStatus=143
TimeoutStopSec=10
Restart=on-failure
RestartSec=5

[Install]
WantedBy=multi-user.target
```

Replace `your_username` with your actual username and `/path/to/your/lavalink/directory` with the path to your LavaLink directory.

#### Step 2: Enable and Start the Service

Enable and start the service:

```bash
sudo systemctl enable lavalink.service
sudo systemctl start lavalink.service
```

Check the status of the service:

```bash
sudo systemctl status lavalink.service
```

### Troubleshooting

If you encounter issues, ensure the path and permissions are correct. The user specified should have access to the LavaLink directory. If your `Lavalink.jar` is in the root directory, adjust the service file accordingly:

```ini
[Unit]
Description=LavaLink
After=network.target

[Service]
User=root
WorkingDirectory=/root
ExecStart=/usr/bin/java -jar /root/Lavalink.jar
SuccessExitStatus=143
TimeoutStopSec=10
Restart=on-failure
RestartSec=5

[Install]
WantedBy=multi-user.target
```

Reload the systemd daemon and restart the service after any changes:

```bash
sudo systemctl daemon-reload
sudo systemctl restart lavalink.service
```

### Checking LavaLink Status

1. **Check Logs:**

   ```bash
   journalctl -u lavalink.service
   ```

2. **Check Service Status:**

   ```bash
   sudo systemctl status lavalink.service
   ```

3. **Check Open Ports:**

   ```bash
   sudo netstat -tuln | grep 8080
   ```

   If `netstat` is not installed, install it with:

   ```bash
   sudo apt install net-tools
   ```

4. **Connect a Bot:** Ensure your bot can connect to the LavaLink server and play tracks without issues.

By following these steps, you should have a running LavaLink server on your Ubuntu system.
