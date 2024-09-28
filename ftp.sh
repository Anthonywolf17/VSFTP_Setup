#!/bin/bash

# Variables
VSFTPD_REPO="https://github.com/Anthonywolf17/vsftpd-2.3.4-infected-edited.git"
USER="ftp"
GROUP="root"
FTP_DIR="/var/ftp"

# Update system and install required packages
echo "[+] Updating system and installing build-essential..."
sudo apt-get update
sudo apt-get install -y build-essential

# Clone the vulnerable vsftpd repo
echo "[+] Cloning vulnerable vsftpd 2.3.4 repository..."
git clone $VSFTPD_REPO
chmod +x vsftpd-2.3.4-infected-edited/vsf_findlibs.sh

# Compile vsftpd
echo "[+] Compiling vsftpd..."
make -C vsftpd-2.3.4-infected-edited

# Add the 'nobody' user and create the empty directory required for vsftpd
echo "[+] Adding user 'nobody' and creating /usr/share/empty..."
sudo useradd nobody
sudo mkdir -p /usr/share/empty

# Install vsftpd binary and man pages
echo "[+] Copying vsftpd binaries and configuration files..."
sudo cp vsftpd-2.3.4-infected-edited/vsftpd /usr/local/sbin/vsftpd
sudo cp vsftpd-2.3.4-infected-edited/vsftpd.8 /usr/local/man/man8
sudo cp vsftpd-2.3.4-infected-edited/vsftpd.conf.5 /usr/local/man/man5
sudo cp vsftpd-2.3.4-infected-edited/vsftpd.conf /etc/vsftpd.conf

# Create FTP directory and set permissions
echo "[+] Setting up FTP directory and permissions..."
sudo mkdir -p $FTP_DIR
sudo useradd -d $FTP_DIR $USER
sudo chown root:root $FTP_DIR
sudo chmod og-w $FTP_DIR

# Start vsftpd service (you may want to customize this part depending on how you want to run it)
echo "[+] Creating Systemd Service..."
sudo cp vsftpd-2.3.4-infected-edited/vsftpd.service /etc/systemd/system/vsftpd.service
sudo systemctl daemon-reload
sudo systemctl enable vsftpd.service
sudo systemctl start vsftpd.service
sudo systemctl status vsftpd.service


echo "[+] Setup complete. Vulnerable vsftpd server is running."

echo "[+] Cleanup Started"
sudo rm -rf sudo systemctl enable
history -c && sudo history -w
