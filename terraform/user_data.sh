#!/bin/bash

# -----------------------------------------------------------------------------
# Author: Shweta G 
# version: 1.0
# Description: This script installs Docker on an Ubuntu EC2 instance.
# Date: 27-07-2026
# -----------------------------------------------------------------------------

# Exit immediately if any command exits with a non-zero status
set -e

# Update local package index
sudo apt-get update -y

# Install prerequisite packages required to add repositories over HTTPS
sudo apt-get install -y \
    ca-certificates \
    curl \
    gnupg


 # Create the directory for keyrings securely
sudo install -m 0755 -d /etc/apt/keyrings

# Download and add Docker's official GPG key
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg

# Set up the stable Docker repository for Ubuntu
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Update the package index again to include the Docker repository sources
sudo apt-get update -y

# Install the latest version of Docker Engine, containerd, and Docker Compose plugin
sudo apt-get install -y \
    docker-ce \
    docker-ce-cli \
    containerd.io \
    docker-buildx-plugin \
    docker-compose-plugin

# Ensure Docker service is enabled and started automatically on boot
sudo systemctl enable docker
sudo systemctl start docker

# Add the default cloud user (e.g., 'ubuntu') to the 'docker' group 
# This allows running docker commands without prefixing with 'sudo'
sudo usermod -aG docker ubuntu

# Optional: Log Docker version to system logs for validation during provisioning
docker --version