#!/bin/bash

# Function to manage and link specific config directories
links_script() {
    # Define local config path and target directory path
    local_config_path="$HOME/.config"
    target_dir="/media/Epsilon/deuce/.config"

    # List of config directories to manage
    config_dirs=("BraveSoftware" "Code" "NordPass" "NordVPN" "pcloud" "Obsidian")

    # Ensure the target base directory exists
    if [ ! -d "$target_dir" ]; then
        echo "Error: Target directory '$target_dir' does not exist."
        exit 1
    fi

    # Confirm with the user before proceeding
    read -p "This will delete specified config folders in your ~/.config directory and create symlinks to $target_dir. Continue? (y/n): " choice

    # Check user's choice
    if [ "$choice" != "y" ]; then
        echo "Operation cancelled."
        exit 0
    fi

    # Process each config directory
    for dir in "${config_dirs[@]}"; do
        local_folder_path="$local_config_path/$dir"
        
        # Remove existing directory or symlink if it exists
        if [ -d "$local_folder_path" ] || [ -L "$local_folder_path" ]; then
            rm -rf "$local_folder_path"
            echo "Removed existing directory: $local_folder_path"
        fi
        
        # Create symbolic link
        ln -s "$target_dir/$dir" "$local_folder_path"
        echo "Created symlink for $dir"
    done

    echo "All specified config folders are symlinked successfully."
}

# Run the links_script function
links_script
