#!/bin/sh

set -e

if [ -z "$SCW_S3_BUCKET" ]; then
  echo "SCW_S3_BUCKET is not set. Quitting."
  exit 1
fi

if [ -z "$SCW_ACCESS_KEY_ID" ]; then
  echo "SCW_ACCESS_KEY_ID is not set. Quitting."
  exit 1
fi

if [ -z "$SCW_SECRET_ACCESS_KEY" ]; then
  echo "SCW_SECRET_ACCESS_KEY is not set. Quitting."
  exit 1
fi

if [ -z "$SCW_BUCKET_REGION" ]; then
  echo "SCW_BUCKET_REGION is not set. Quitting."
  exit 1
fi

mkdir -p ~/.aws
touch ~/.aws/credentials
touch ~/.aws/config

cat << EOF > ~/.aws/config
[plugins]
endpoint = awscli_plugin_endpoint

[default]
region = fr-par
s3 =
  endpoint_url = https://s3.fr-par.scw.cloud
  signature_version = s3v4
  max_concurrent_requests = 100
  max_queue_size = 1000
  multipart_threshold = 50MB
  # Edit the multipart_chunksize value according to the file sizes that you want to upload. The present configuration allows to upload files up to 10 GB (1000 requests * 10MB). For example setting it to 5GB allows you to upload files up to 5TB.
  multipart_chunksize = 10MB
s3api =
  endpoint_url = https://s3.fr-par.scw.cloud

[profile fr-par]
region = fr-par
s3 =
  endpoint_url = https://s3.fr-par.scw.cloud
  signature_version = s3v4
  max_concurrent_requests = 100
  max_queue_size = 1000
  multipart_threshold = 50MB
  # Edit the multipart_chunksize value according to the file sizes that you want to upload. The present configuration allows to upload files up to 10 GB (1000 requests * 10MB). For example setting it to 5GB allows you to upload files up to 5TB.
  multipart_chunksize = 10MB
s3api =
  endpoint_url = https://s3.fr-par.scw.cloud
  
[profile nl-ams]
region = nl-ams
s3 =
  endpoint_url = https://s3.nl-ams.scw.cloud
  signature_version = s3v4
  max_concurrent_requests = 100
  max_queue_size = 1000
  multipart_threshold = 50MB
  # Edit the multipart_chunksize value according to the file sizes that you want to upload. The present configuration allows to upload files up to 10 GB (1000 requests * 10MB). For example setting it to 5GB allows you to upload files up to 5TB.
  multipart_chunksize = 10MB
s3api =
  endpoint_url = https://s3.nl-ams.scw.cloud
  
[profile pl-waw]
region = pl-waw
s3 =
  endpoint_url = https://s3.pl-waw.scw.cloud
  signature_version = s3v4
  max_concurrent_requests = 100
  max_queue_size = 1000
  multipart_threshold = 50MB
  # Edit the multipart_chunksize value according to the file sizes that you want to upload. The present configuration allows to upload files up to 10 GB (1000 requests * 10MB). For example setting it to 5GB allows you to upload files up to 5TB.
  multipart_chunksize = 10MB
s3api =
  endpoint_url = https://s3.pl-waw.scw.cloud
EOF

echo "[default]
aws_access_key_id = ${SCW_ACCESS_KEY_ID}
aws_secret_access_key = ${SCW_SECRET_ACCESS_KEY}" > ~/.aws/credentials


echo "Install yarn"
npm install -g yarn

echo "Install dependencies"
yarn install

echo "Run yarn build"
yarn run build

echo "Copying to website folder"
aws --profile ${SCW_BUCKET_REGION} s3 sync ./build/ s3://${SCW_S3_BUCKET} --exact-timestamps --delete $*

echo "Cleaning up things"

rm -rf ~/.aws
