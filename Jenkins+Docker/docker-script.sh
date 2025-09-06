#!/bin/bash

#Exit immediately if any command fails.
set -e

echo "Docker Setup Script"
echo "===================="
echo "Choose an option:"
echo "1) Install Docker"
echo "2) Remove Docker"
read -p "Enter your choice (1 or 2): " choice

if [ "$choice" == "2" ]; then
    echo "Removing Docker and related packages..."
    for pkg in docker.io docker-doc docker-compose docker-compose-v2 podman-docker containerd runc; do
        sudo apt-get remove -y $pkg
    done
    sudo apt-get purge -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
    sudo rm -rf /etc/apt/sources.list.d/docker.list /etc/apt/keyrings/docker.asc
    sudo apt-get autoremove -y
    echo " Docker has been removed."
    exit 0
fi

if [ "$choice" == "1" ]; then
    echo "Installing Docker..."

    # Remove old versions
    for pkg in docker.io docker-doc docker-compose docker-compose-v2 podman-docker containerd runc; do
        sudo apt-get remove -y $pkg
    done

    # Add Docker's official GPG key
    sudo apt-get update
    sudo apt-get install -y ca-certificates curl
    sudo install -m 0755 -d /etc/apt/keyrings
    sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
    sudo chmod a+r /etc/apt/keyrings/docker.asc

    # Add Docker repository
    echo \
      "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
      $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}") stable" | \
      sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

    # Install Docker packages
    sudo apt-get update
    sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

    # Start and enable Docker service
    echo "Starting Docker service..."
    sudo systemctl start docker
    sudo systemctl enable docker
    echo " Docker service is running and enabled on boot."

    # Linux post-installation steps
    echo "Configuring Docker permissions..."
    if ! getent group docker > /dev/null; then
        sudo groupadd docker
        echo "Created 'docker' group."
    fi

    sudo usermod -aG docker $USER
    echo "Added user '$USER' to 'docker' group."

    echo "Applying group change with 'newgrp docker'..."
    newgrp docker <<EONG
echo " Docker is now ready to use without sudo."
docker version
EONG

    exit 0
fi

echo "Invalid choice. Please run the script again and choose 1 or 2."

