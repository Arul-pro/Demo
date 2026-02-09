#!/bin/bash

# Stop script if any command fails
set -e

echo "Updating system packages..."
sudo apt update

echo "Installing Java and required tools..."
sudo apt install -y fontconfig openjdk-21-jre wget gnupg

echo "Adding Jenkins repository key..."
sudo mkdir -p /etc/apt/keyrings

sudo wget -O /etc/apt/keyrings/jenkins-keyring.asc \
https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key

echo "Adding Jenkins repository..."
echo "deb [signed-by=/etc/apt/keyrings/jenkins-keyring.asc] https://pkg.jenkins.io/debian-stable binary/" \
| sudo tee /etc/apt/sources.list.d/jenkins.list > /dev/null

echo "Updating package list again..."
sudo apt update

echo "Installing Jenkins..."
sudo apt install -y jenkins

echo "Enabling and starting Jenkins service..."
sudo systemctl daemon-reload
sudo systemctl enable jenkins
sudo systemctl start jenkins

echo "Jenkins status:"
sudo systemctl status jenkins --no-pager

echo "----------------------------------------"
echo "Jenkins Installed!"
echo "Open: http://YOUR-SERVER-IP:8080"
echo "Admin Password:"
sudo cat /var/lib/jenkins/secrets/initialAdminPassword
echo "----------------------------------------"


