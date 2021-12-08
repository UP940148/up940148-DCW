#!/bin/bash

# Install Node and Git
curl -fsSL https://deb.nodesource.com/setup_17.x | sudo bash -
sudo apt-get install -y nodejs
sudo apt-get install -y git

# Install DCW
sudo git clone https://github.com/portsoc/distributed-controller-worker
cd distributed-controller-worker
sudo npm install

# Get IP address
IP=`curl -s -H "Metadata-Flavor: Google" "http://metadata.google.internal/computeMetadata/v1/instance/network-interfaces/0/access-configs/0/external-ip"`
# Generate secret
secret=`openssl rand -base64 32`

cd ../

# Create clients
gcloud config set compute/zone europe-west2-b

n="${1:-1}"
gcloud compute instances create \
--machine-type n2-highcpu-2 \
--tags http-server,https-server \
--metadata-from-file startup-script=client-startup.sh \
--metadata key="$secret",address="$IP" \
`seq -f "client-%g" 1 "$n"`

# Start DCW as server
cd distributed-controller-worker
sudo npm run server "$secret"

# Delete clients once process exits
gcloud --quiet compute instances delete \
`seq -f "client-%g" 1 "$n"`

gcloud --quiet compute instances delete dcw-server
