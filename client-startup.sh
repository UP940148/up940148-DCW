#!/bin/bash

# Get metadata
key=`curl -s -H "Metadata-Flavor: Google" \
"http://metadata.google.internal/computeMetadata/v1/instance/attributes/key"`
address=`curl -s -H "Metadata-Flavor: Google" \
"http://metadata.google.internal/computeMetadata/v1/instance/attributes/address"`

# Install Node and Git
curl -fsSL https://deb.nodesource.com/setup_17.x | sudo bash -
sudo apt-get install -y nodejs
sudo apt-get install git

# Install DCW
git clone https://github.com/portsoc/distributed-controller-worker
cd distributed-controller-worker
sudo npm install

# Start DCW as client
sudo npm run client "$key" "$address"
