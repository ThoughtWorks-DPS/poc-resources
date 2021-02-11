#!/bin/sh
curl -LOs https://github.com/segmentio/chamber/releases/download/v2.9.1/chamber-v2.9.1-linux-amd64
sudo mv chamber-v2.9.1-linux-amd64 /usr/local/bin/chamber
sudo chmod +x /usr/local/bin/chamber