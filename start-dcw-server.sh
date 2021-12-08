#!/bin/bash

# Install Node and Git
curl -fsSL https://deb.nodesource.com/setup_17.x | sudo bash -
sudo apt-get install -y nodejs
sudo apt-get install git

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
for i in `seq 1 "$n"`
do
  gcloud compute instances create \
  --machine-type f1-micro \
  --tags http-server,https-server \
  --metadata-from-file startup-script=client-startup.sh \
  --metadata key="$secret",address="$IP" \
  "client-$i"
done

# Start DCW as server
cd distributed-controller-worker
sudo npm run server "$secret"
