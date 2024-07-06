#!/bin/bash

# Script to switch the default shell to zsh

# Check if zsh is installed
if command -v zsh >/dev/null 2>&1; then
    echo "Zsh is installed."
    
    # Change the default shell to zsh
    if chsh -s "$(which zsh)"; then
        echo "Default shell changed to zsh. Please log out and log back in to see the change."
    else
        echo "Failed to change the default shell to zsh."
    fi
else
    echo "Zsh is not installed. Installing zsh now..."
    # Installing zsh using pacman. This requires root privileges.
    sudo pacman -Syu zsh --noconfirm

    # Verify zsh installation and change shell
    if command -v zsh >/dev/null 2>&1; then
        if chsh -s "$(which zsh)"; then
            echo "Default shell changed to zsh. Please log out and log back in to see the change."
        else
            echo "Failed to change the default shell to zsh after installation."
        fi
    else
        echo "Installation of zsh failed. Please check your package manager and installation commands."
    fi
fi
