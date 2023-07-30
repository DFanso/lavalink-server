# lavalink-server
## installing lavalink server on a linux server. help with gpt4, lavalink.jar added to repo,


> i need to install lavalink server on ubuntu

Installing LavaLink on an Ubuntu system involves a few steps. First, you'll need to install Java (as LavaLink is a Java program), and then download and run the LavaLink.jar file.

Here is a step by-step guide:

**Step 1: Update Your System**

First, you should always update your system to ensure that you have the most recent packages. You can do this by running the following commands in your terminal:

bash

```bash
sudo apt update
sudo apt upgrade -y
```

**Step 2: Install Java**

LavaLink requires Java to be installed on your system. If you don't have Java installed, you can install it with:

bash

```bash
sudo apt install openjdk-11-jre-headless -y
```

To verify that Java was installed correctly, use the following command:

bash

```bash
java -version
```

**Step 3: Download LavaLink**

Next, download the latest LavaLink.jar file from the LavaLink GitHub repository.

bash

```bash
wget https://github.com/DFanso/lavalink-server/blob/main/Lavalink.jar
```

(Replace "3.x" with the current version number. Check the LavaLink repository for the latest version.)

**Step 4: Create a LavaLink Configuration File**

LavaLink requires a configuration file to run. Create a new file named `application.yml` in the same directory as your LavaLink.jar file:

bash

```bash
nano application.yml
```

Then, copy the following basic configuration into the `application.yml` file:

yml

```yml
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

Replace `"your_password_here"` with a password of your choice. This password will be used to connect your bot to the LavaLink server.

**Step 5: Run LavaLink**

Finally, you can run LavaLink with the following command:

bash

```bash
java -jar Lavalink.jar
```

To run it in the background, you can use the screen command:

bash

```bash
screen -S LavaLink
java -jar Lavalink.jar
```

To detach from the screen session, press `CTRL+A` then `D`. To re-attach, use `screen -r LavaLink`.

You should now have a running LavaLink server. Note that you'll need to integrate it with your bot code using the appropriate LavaLink client library.

> how to run this 24/7

To keep Lavalink running 24/7 on your Ubuntu server, you could use something like `screen` or `tmux`, but a more recommended way is to use `systemd` which is a system and service manager for Linux. It will help you manage your LavaLink application as a service, which you can configure to start on system boot.

Here is how you can set up a systemd service for your LavaLink server:

**Step 1: Create a systemd Service File**

Create a new systemd service file in `/etc/systemd/system` with `sudo` permissions. The convention is to name the file `your_service_name.service`.

bash

```bash
sudo nano /etc/systemd/system/lavalink.service
```

**Step 2: Add in the Following Configuration**

Add the following configuration to the service file you just created, adjust it to your needs:

bash

```bash
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

*   `your_username`: Replace this with your actual username.
*   `/path/to/your/lavalink/directory`: Replace this with the actual path to the directory where your `Lavalink.jar` file is located.

**Step 3: Enable and Start the Service**

Now, you can enable and start the service with:

bash

```bash
sudo systemctl enable lavalink.service
sudo systemctl start lavalink.service
```

*   The `enable` command will make the LavaLink service start automatically on boot.
*   The `start` command will start the LavaLink service immediately without needing to reboot.

**Step 4: Check the Status of the Service**

You can check the status of the service with:

bash

```bash
sudo systemctl status lavalink.service
```

This should show that the service is active (running).

You can also stop and restart the service anytime with `sudo systemctl stop lavalink.service` and `sudo systemctl restart lavalink.service` commands respectively.

By setting up a systemd service, you will have LavaLink run in the background 24/7, and it will automatically start on system boot.

> Created symlink /etc/systemd/system/multi-user.target.wants/lavalink.service → /etc/systemd/system/lavalink.service. root@v2ray:~# sudo systemctl start lavalink.service root@v2ray:~# sudo systemctl start lavalink.service root@v2ray:~# sudo systemctl status lavalink.service ● lavalink.service - LavaLink Loaded: loaded (/etc/systemd/system/lavalink.service; enabled; vendor preset: enabled) Active: activating (auto-restart) (Result: exit-code) since Fri 2023-07-28 17:28:05 UTC; 3s ago Process: 31210 ExecStart=/usr/bin/java -jar Lavalink.jar (code=exited, status=200/CHDIR) Main PID: 31210 (code=exited, status=200/CHDIR) Jul 28 17:28:05 v2ray systemd\[1\]: lavalink.service: Main process exited, code=exited, status=200/CHDIR Jul 28 17:28:05 v2ray systemd\[1\]: lavalink.service: Failed with result 'exit-code'.

The error code `status=200/CHDIR` typically indicates that the service is unable to change to the Working Directory specified in the service file.

Ensure that the path to the directory where the `Lavalink.jar` is located is correct in the `lavalink.service` file. The specified user should also have the correct permissions to access and execute files in this directory.

Here's what you can do to troubleshoot:

1.  Check the path in `WorkingDirectory=/path/to/your/lavalink/directory`. This should be the absolute path to the directory containing `Lavalink.jar`. Use `cd` and `ls` commands to navigate to your directories and ensure that the file is actually there.
    
2.  Check the permissions of the directory containing `Lavalink.jar`. The user specified in `User=your_username` should have the correct permissions to read and execute files in this directory. If you are unsure, you can temporarily give all permissions to all users to this directory with `sudo chmod -R 777 /path/to/your/lavalink/directory` and see if the problem persists (this is not recommended for production environments due to security concerns).
    
3.  The user specified in `User=your_username` in the `lavalink.service` file should be an actual user on your system. Check this by using `id your_username`.
    
4.  Make sure you saved the changes to your `lavalink.service` file after editing it. After any modification, you must reload the systemd manager configuration with `sudo systemctl daemon-reload`, then restart your service with `sudo systemctl restart lavalink.service`.
    

Check the status of your service again using `sudo systemctl status lavalink.service`. If there's still an issue, you can view detailed logs using `journalctl -u lavalink.service` to get more information about what's going wrong.

> jar file is on root folder

If your `Lavalink.jar` file is located in the root directory (`/root`), you'll need to make sure that the systemd service is set up with the correct `User` and `WorkingDirectory` parameters.

If you're running the service as root, your service file should look something like this:

bash

```bash
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

Note: It's generally not a good practice to run services as root for security reasons. It's better to create a specific user for running such services or place the service files in a non-root directory where a non-root user has access.

After modifying the service file, don't forget to reload the systemd daemon and restart the service:

bash

```bash
sudo systemctl daemon-reload
sudo systemctl restart lavalink.service
```

And then check the status again:

bash

```bash
sudo systemctl status lavalink.service
```

> how to check lavalink is working or not

There are a few ways to check if Lavalink is working correctly:

**1\. Checking the Lavalink logs**

After starting Lavalink, you can check its logs to ensure it's running correctly. If you're running it as a systemd service, you can check its logs with:

bash

```bash
journalctl -u lavalink.service
```

If Lavalink is starting correctly, you should see something like:

bash

```bash
INFO  com.sedmelluq.lava.link.Lavalink - Started Lavalink in 5.267 seconds
```

**2\. Checking the service status**

As you've already done, you can use `systemctl` to check the status of the Lavalink service:

bash

```bash
sudo systemctl status lavalink.service
```

**3\. Checking if the Lavalink port is open**

By default, Lavalink listens on port 8080. You can check if this port is open using `netstat`:

bash

```bash
sudo netstat -tuln | grep 8080
```

If Lavalink is running correctly, you should see a line similar to this:

bash

```bash
tcp6   0  0 :::8080      :::*    LISTEN
```

This indicates that a service (hopefully Lavalink) is listening on port 8080.

**4\. Connecting a bot**

Ultimately, the best way to ensure Lavalink is working is to connect a bot to it. If you're using a library that supports Lavalink (like discord.py\[voice\] or eris-lavalink for Node.js), you can try creating a bot and connecting it to Lavalink. You should be able to play a track without any issues if Lavalink is working correctly.

> sudo netstat -tuln | grep 8080

If you're running the `sudo netstat -tuln | grep 8080` command to check if Lavalink is listening on port 8080, you should see something like this in the output:

bash

```bash
tcp6       0      0 :::8080                 :::*                    LISTEN
```     

This means that there is a process (hopefully Lavalink) listening on port 8080, waiting for connections.

If you don't see any output, that means no process is listening on port 8080, which could indicate that Lavalink isn't running or that it's configured to use a different port.

If you're encountering an issue where the `netstat` command isn't found, you may need to install it first. On Ubuntu, `netstat` is provided by the `net-tools` package, which you can install with:

bash

```bash
sudo apt install net-tools
```

Then, you should be able to use the `netstat` command.
