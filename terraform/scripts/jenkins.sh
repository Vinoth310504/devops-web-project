#!/bin/bash

set -e

echo "Installing Jenkins..."

apt-get update -y

apt-get install -y fontconfig openjdk-21-jre

java -version

curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io-2026.key \
    -o /usr/share/keyrings/jenkins-keyring.asc

echo "deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] https://pkg.jenkins.io/debian-stable binary/" \
    > /etc/apt/sources.list.d/jenkins.list

apt-get update -y

apt-get install -y jenkins

systemctl enable jenkins
systemctl start jenkins

echo "Jenkins installation completed."

systemctl status jenkins --no-pager