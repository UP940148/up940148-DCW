gcloud config set compute/zone europe-west2-b
gcloud compute instances create \
--machine-type f1-micro \
--scopes cloud-platform \
--tags http-server,https-server \
dcw-server
