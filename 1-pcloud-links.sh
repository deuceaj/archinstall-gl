#!/bin/bash

# Function to manage and link specific user directories
links_script() {
    # List of user directories to manage
    user_dirs=("Documents" "Downloads" "Git" "Music" "Pictures" "Videos")

    # Base directory where the symlinks will point to
    target_base_dir="/media/Delta"

    # Ensure the target base directory exists
    if [ ! -d "$target_base_dir" ]; then
        echo "Error: Target base directory '$target_base_dir' does not exist."
        exit 1
    fi

    # Confirm with the user before proceeding
    read -p "This will delete specified directories in your home directory and create symlinks to $target_base_dir. Continue? (y/n): " choice

    # Check user's choice
    if [ "$choice" != "y" ]; then
        echo "Operation cancelled."
        exit 0
    fi

    # Process each directory
    for dir in "${user_dirs[@]}"; do
        local_dir_path="$HOME/$dir"
        target_dir_path="$target_base_dir/$dir"
        
        # Remove existing directory or symlink if it exists
        if [ -d "$local_dir_path" ] || [ -L "$local_dir_path" ]; then
            rm -rf "$local_dir_path"
            echo "Removed existing directory: $local_dir_path"
        fi
        
        # Create symbolic link
        ln -s "$target_dir_path" "$local_dir_path"
        echo "Created symlink for $dir to $target_dir_path"
    done

    echo "All specified user directories are symlinked successfully."
}

# Run the links_script function
links_script
