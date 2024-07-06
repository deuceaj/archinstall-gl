#!/bin/bash

# Prompt for sudo password
echo "Please enter your sudo password:"
read -s PASSWORD

# Path to the file containing the token
TOKEN_FILE="/media/Delta/nord.txt"

# Read the token from the file
TOKEN=$(grep "Nord_Token:" "$TOKEN_FILE" | sed 's/Nord_Token://')

# Check if the token is found
if [ -z "$TOKEN" ]; then
    echo "Error: Token not found in $TOKEN_FILE"
    exit 1
fi

# Append the token to the command
COMMAND="nordvpn login --token $TOKEN"

# Run usermod with sudo
echo "$PASSWORD" | sudo -S usermod -aG nordvpn $USER

# Enable nordvpnd.service with sudo
echo "$PASSWORD" | sudo -S systemctl enable nordvpnd.service

# Start nordvpnd.service with sudo
echo "$PASSWORD" | sudo -S systemctl start nordvpnd.service

# Run the command
echo "Running command: $COMMAND"
$COMMAND
