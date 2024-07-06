#!/bin/bash

# Function to create media folders
create_media_folders() {
    # Check if /media folder exists, create if it doesn't
    if [ ! -d "/media" ]; then
        sudo mkdir /media
    fi

    # Create subfolders Delta, Epsilon, Gamma, Theta, and Vega within /media
    sudo mkdir -p /media/Delta /media/Epsilon /media/Gamma /media/Theta /media/Vega

    # Change ownership of /media and its subfolders to deuce:deuce
    sudo chown -R deuce:deuce /media

    echo "Media folders created successfully."
}

# Function to add entries to /etc/fstab
add_to_fstab() {
    # Define the entries to be added
    new_entries="#Mount Network Drives
    //192.168.2.11/Delta/                       /media/Delta     cifs    vers=2.0,credentials=/home/deuce/.local/.smbcredentials,iocharset=utf8,gid=1000,uid=1000,file_mode=0777,dir_mode=0777   0 0
    //192.168.2.11/Theta                        /media/Theta/    cifs    vers=2.0,credentials=/home/deuce/.local/.smbcredentials,iocharset=utf8,gid=1000,uid=1000,file_mode=0777,dir_mode=0777   0 0
    #Mount Hard Drives
    UUID=b1121d57-4180-4ad1-af4f-158af3b18883   /media/Epsilon   btrfs   nofail             0 0
    UUID=cd755bff-8cc1-4672-9655-ce40b91ff482   /media/Gamma     ext4    nofail             0 0
    #UUID=371be9f1-a428-49fc-81fe-262449962b3d   /media/Vega      btrfs   nofail             0 0"

    # Append the entries to /etc/fstab
    
   echo "$new_entries" | sudo tee -a /etc/fstab > /dev/null

    echo "Entries added to /etc/fstab successfully."
    sleep 5
    sudo mount -a
}




# Function to execute links.sh
links_script() {
    # List of folders to be linked
    folders=(
        #".config"
        ".fonts"
        ".kodi"
        ".local"
        ".oh-my-zsh"
        ".pcloud"
        ".ssh"
        ".steam"
        ".vscode"
        "wallpaper"
    )

    # List of files to be linked
    files=(
        ".zsh_history"
        ".zshrc"
        ".zshrc-alias"
    )

    # Path to the target directory where folders and files will be linked
    target_dir="/media/Epsilon/deuce_dot/"

    # Check if the target directory exists
    if [ ! -d "$target_dir" ]; then
        echo "Error: Target directory '$target_dir' does not exist."
        exit 1
    fi

    # Confirm with the user before proceeding
    read -p "This will delete specified folders and files in your home directory and create symlinks to $target_dir. Continue? (y/n): " choice

    # Check user's choice
    if [ "$choice" != "y" ]; then
        echo "Operation cancelled."
        exit 0
    fi

    # Loop through and delete existing folders and files
    for folder in "${folders[@]}"; do
        rm -rf "$HOME/$folder"
    done

    for file in "${files[@]}"; do
        rm -f "$HOME/$file"
    done

    # Use sudo to delete the .config folder
    #sudo rm -rf "$HOME/.config"

    # Create symbolic link for .config folder using sudo
    #sudo ln -s "$target_dir.config" "$HOME/.config"

    # Create symbolic links for folders
    for folder in "${folders[@]}"; do
        ln -s "$target_dir$folder" "$HOME/$folder"
    done

    # Create symbolic links for files
    for file in "${files[@]}"; do
        ln -s "$target_dir$file" "$HOME/$file"
    done

    echo "Folders and files symlinked successfully."
}

# Execute functions with pauses in between
#create_media_folders
sleep 2
#add_to_fstab
sleep 2
links_script

echo "Combined script executed successfully."
 
