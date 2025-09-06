#!/bin/bash

# Jenkins Installer/Remover Script
# Run with: bash jenkins_setup.sh

#Exit immediately if any command fails.
set -e

echo "=============================="
echo " Jenkins Setup Script"
echo "=============================="
echo "Choose an option:"
echo "1) Install Jenkins"
echo "2) Remove Jenkins"
read -p "Enter your choice [1 or 2]: " choice

if [[ "$choice" == "1" ]]; then
    echo "Starting Jenkins installation..."

    # Update system
    sudo apt update

    # Install OpenJDK 21
    sudo apt install openjdk-21-jdk -y

    # Verify Java installation
    java -version

    # Add Jenkins key and repo
    sudo wget -O /etc/apt/keyrings/jenkins-keyring.asc \
      https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key

    echo "deb [signed-by=/etc/apt/keyrings/jenkins-keyring.asc] \
      https://pkg.jenkins.io/debian-stable binary/" | sudo tee \
      /etc/apt/sources.list.d/jenkins.list > /dev/null

    # Update and install Jenkins
    sudo apt-get update
    sudo apt-get install jenkins -y

    # Start Jenkins service
    sudo systemctl start jenkins

    # Check Jenkins status
    systemctl status jenkins

    echo " Jenkins installation complete."

# SETUP REMOVE
elif [[ "$choice" == "2" ]]; then
    echo "Removing Jenkins and related packages..."

    # Stop Jenkins service
    sudo systemctl stop jenkins

    # Remove Jenkins and Java
    sudo apt-get remove --purge jenkins openjdk-21-jdk -y
    sudo apt-get autoremove -y

    # Remove Jenkins repo and key
    sudo rm -f /etc/apt/sources.list.d/jenkins.list
    sudo rm -f /etc/apt/keyrings/jenkins-keyring.asc

    echo " Jenkins removal complete."

else
    echo " Invalid choice. Please run the script again and choose 1 or 2."
fi
