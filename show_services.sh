#!/bin/bash

# Obtain the status of all services
services=$(systemctl list-units --type=service --all --no-pager --plain | awk '{print $1}' | head -n -7 | tail -n +2)

# Colours
color_red="\e[31m"
color_green="\e[32m"
color_reset="\e[0m"

# Function to display the status of services
display_status() {
    for service in $services; do
        status=$(systemctl is-active $service)
        if [ "$status" == "active" ]; then
            echo -e "Service: $service - Status: ${color_green}$status${color_reset}"
        else
            echo -e "Service: $service - Status: ${color_red}$status${color_reset}"
        fi
    done
}

# Check the value of $1 and perform actions accordingly
case "$1" in
    "all")
        display_status
        ;;
    "active")
        for service in $services; do
            status=$(systemctl is-active $service)
            if [ "$status" == "active" ]; then
                echo -e "Service: $service - Status: ${color_green}$status${color_reset}"
            fi
        done
        ;;
    "inactive")
        for service in $services; do
            status=$(systemctl is-active $service)
            if [ "$status" != "active" ]; then
                echo -e "Service: $service - Status: ${color_red}$status${color_reset}"
            fi
        done
        ;;
    "enabled")
        systemctl list-unit-files --type=service --state=enabled
        ;;
    *)
        echo "Invalid option. Usage: $0 [all|active|inactive|enabled]"
        exit 1
        ;;
esac
