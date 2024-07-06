#!/bin/bash

# Increase max_map_count
echo "Please enter your sudo password to increase max_map_count:"
sudo sh -c 'echo "vm.max_map_count=1048576" >> /etc/sysctl.d/99-vm-max_map_count.conf'
sudo sysctl --system || sudo reboot

# Ensure amdvlk and lib32-amdvlk are not installed
echo "Please enter your sudo password to remove amdvlk and lib32-amdvlk if they are installed:"
sudo pacman -R --noconfirm amdvlk lib32-amdvlk || true

# Update mesa drivers and related packages, install Steam, Proton-GE, and lib32-vulkan-radeon
echo "Please enter your sudo password to update packages and install Steam, Proton-GE, and lib32-vulkan-radeon:"
sudo sh -c 'pacman -Syu --noconfirm mesa vulkan-mesa-layers lib32-vulkan-mesa-layers steam lib32-vulkan-radeon'
yay -S --noconfirm proton-ge-custom-bin

echo "Installation completed successfully."
