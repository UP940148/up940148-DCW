n="${1:-3}"
for i in `seq 1 "$n"`
do
  key=`openssl rand -base64 32`
  gcloud compute instances create \
  --machine-type f1-micro \
  --metadata secret="$key" \
  "client-$i"
done
