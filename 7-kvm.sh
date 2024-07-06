#!/bin/bash
#  _  ____     ____  __  
# | |/ /\ \   / /  \/  | 
# | ' /  \ \ / /| |\/| | 
# | . \   \ V / | |  | | 
# |_|\_\   \_/  |_|  |_| 
#                        
#  
# by Stephan Raabe (2023) 
# ----------------------------------------------------- 

# ------------------------------------------------------
# Install Script for Libvirt
# ------------------------------------------------------

read -p "Do you want to start? " s
echo "START KVM/QEMU/VIRT MANAGER INSTALLATION..."

# ------------------------------------------------------
# Install Packages
# ------------------------------------------------------
sudo pacman -S virt-manager virt-viewer qemu vde2 ebtables iptables-nft nftables dnsmasq bridge-utils ovmf swtpm

# ------------------------------------------------------
# Edit libvirtd.conf
# ------------------------------------------------------
echo "Automating libvirtd configuration..."

# Ensure the libvirtd.conf file exists
conf_file="/etc/libvirt/libvirtd.conf"
if [ ! -f "$conf_file" ]; then
    echo "Error: libvirtd.conf not found."
    exit 1
fi

# Uncomment necessary lines
sed -i 's/#unix_sock_group = "libvirt"/unix_sock_group = "libvirt"/' "$conf_file"
sed -i 's/#unix_sock_rw_perms = "0770"/unix_sock_rw_perms = "0770"/' "$conf_file"

# Add log filters and outputs
echo 'log_filters="3:qemu 1:libvirt"' | sudo tee -a "$conf_file" >/dev/null
echo 'log_outputs="2:file:/var/log/libvirt/libvirtd.log"' | sudo tee -a "$conf_file" >/dev/null

echo "Configuration completed."


# ------------------------------------------------------
# Add user to the group
# ------------------------------------------------------
sudo usermod -a -G kvm,libvirt $(whoami)

# ------------------------------------------------------
# Enable services
# ------------------------------------------------------
sudo systemctl enable libvirtd
sudo systemctl start libvirtd

# ------------------------------------------------------
# Edit qemu.conf
# ------------------------------------------------------

echo "Automating libvirt qemu.conf configuration..."

# Ensure the qemu.conf file exists
conf_file="/etc/libvirt/qemu.conf"
if [ ! -f "$conf_file" ]; then
    echo "Error: qemu.conf not found."
    exit 1
fi

# Set username for user and group
echo "Setting username for user and group in qemu.conf..."
sed -i "s/#user = \"libvirt-qemu\"/user = \"deuce\"/" "$conf_file"
sed -i "s/#group = \"libvirt-qemu\"/group = \"deuce\"/" "$conf_file"

echo "Configuration completed."


# ------------------------------------------------------
# Restart Services
# ------------------------------------------------------
sudo systemctl restart libvirtd

# ------------------------------------------------------
# Autostart Network
# ------------------------------------------------------
sudo virsh net-autostart default

echo "Please restart your system with reboot."
