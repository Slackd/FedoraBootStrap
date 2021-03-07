#!/bin/bash

sudo dnf update -y
sudo dnf group install security-lab -y
sudo dnf install hydra hydra-frontend gobuster scalpel foremost steghide whois aircrack-ng traceroute -y
