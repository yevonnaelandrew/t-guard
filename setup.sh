#!/bin/bash

while true; do
    OPTION=$(whiptail --title "Main Menu" --menu "Choose an option:" 20 70 13 \
                    "1" "Update System and Install Prerequisites" \
                    "2" "Install Docker" \
                    "3" "Install Wazuh (SIEM)" \
                    "4" "Install Shuffle (SOAR)" \
                    "5" "Install DFIR-IRIS (Incident Response Platform)" \
                    "6" "Setup Simulation and POC" \
                    "10" "Show Status" 3>&1 1>&2 2>&3)
    # Script version 1.0 updated 15 November 2023
    # Depending on the chosen option, execute the corresponding command
    case $OPTION in
    1)
        sudo apt-get update -y
        sudo apt-get upgrade -y
        sudo apt-get install wget curl nano git -y
        ;;
    2)
        # Check if Docker is installed
        if command -v docker > /dev/null; then
            echo "Docker is already installed."
        else
            # Install Docker
            curl -fsSL https://get.docker.com -o get-docker.sh
            sudo sh get-docker.sh
            sudo systemctl enable docker.service && sudo systemctl enable containerd.service
        fi
        ;;
    3)
        cd wazuh
        sudo docker network create shared-network
        sudo docker compose -f generate-indexer-certs.yml run --rm generator
        sudo docker compose up -d
        ;;
    4)
        cd shuffle
        sudo docker compose up -d
        ;;
    5)
        cd iris-web
        sudo docker compose build
        sudo docker compose up -d
    6)
        cd examples/poc-wazuh/brute-force
        sudo docker compose build
        sudo docker compose up -d
        ;;
    10)
        sudo docker ps
        ;;
esac
    # Give option to go back to the previous menu or exit
    if (whiptail --title "Exit" --yesno "Do you want to exit the script?" 8 78); then
        break
    else
        continue
    fi
done
