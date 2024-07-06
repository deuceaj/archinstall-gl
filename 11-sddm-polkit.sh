#!/bin/bash

# Define paths for the configuration files
SDDM_CONFIG_FILE="/etc/sddm.conf"
POLKIT_RULES_FILE="/etc/polkit-1/rules.d/49-nopasswd_global.rules"

# Function to append SDDM autologin configuration
append_sddm_config() {
    if grep -q "\[Autologin\]" "$SDDM_CONFIG_FILE"; then
        echo "Autologin section already exists in $SDDM_CONFIG_FILE. Please check the file."
    else
        echo -e "[Autologin]\nUser=deuce\nSession=hyprland" | sudo tee -a "$SDDM_CONFIG_FILE" > /dev/null
        echo "Autologin configuration added to $SDDM_CONFIG_FILE."
    fi
}

# Function to handle Polkit rules
handle_polkit_rules() {
    if [[ ! -f "$POLKIT_RULES_FILE" ]]; then
        echo "Creating $POLKIT_RULES_FILE..."
        sudo touch "$POLKIT_RULES_FILE"
    else
        echo "$POLKIT_RULES_FILE already exists."
    fi

    # Append Polkit rule
    echo -e '/* Allow members of the wheel group to execute any actions without password authentication, similar to "sudo NOPASSWD:" */\npolkit.addRule(function(action, subject) {\n    if (subject.isInGroup("deuce")) {\n        return polkit.Result.YES;\n    }\n});' | sudo tee -a "$POLKIT_RULES_FILE" > /dev/null
    echo "Polkit rule added to $POLKIT_RULES_FILE."
}

# Append SDDM configuration
append_sddm_config

# Handle Polkit rules
handle_polkit_rules
