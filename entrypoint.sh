#!/bin/sh

set -e

if [ -z "$AWS_S3_BUCKET" ]; then
  echo "AWS_S3_BUCKET is not set. Quitting."
  exit 1
fi

if [ -z "$AWS_ACCESS_KEY_ID" ]; then
  echo "AWS_ACCESS_KEY_ID is not set. Quitting."
  exit 1
fi

if [ -z "$AWS_SECRET_ACCESS_KEY" ]; then
  echo "AWS_SECRET_ACCESS_KEY is not set. Quitting."
  exit 1
fi

if [ -z "$AWS_DEFAULT_REGION" ]; then
  echo "AWS_DEFAULT_REGION is not set. Quitting."
  exit 1
fi


#if [ -z "$PROJECT_NAME" ]; then
#  echo "PROJECT_NAME is not set. Quitting."
#  exit 1
#fi


mkdir -p ~/.aws
touch ~/.aws/credentials

cat << EOF > ~/.aws/credentials
[default]
aws_access_key_id = ${AWS_ACCESS_KEY_ID}
aws_secret_access_key = ${AWS_SECRET_ACCESS_KEY}

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
EOF

#echo "[default]
#aws_access_key_id = ${AWS_ACCESS_KEY_ID}
#aws_secret_access_key = ${AWS_SECRET_ACCESS_KEY}
#
#region = fr-par
#s3 =
#  endpoint_url = https://s3.fr-par.scw.cloud
#  signature_version = s3v4
#  max_concurrent_requests = 100
#  max_queue_size = 1000
#  multipart_threshold = 50MB
#  # Edit the multipart_chunksize value according to the file sizes that you want to upload. The present configuration allows to upload files up to 10 GB (1000 requests * 10MB). For example setting it to 5GB allows you to upload files up to 5TB.
#  multipart_chunksize = 10MB
#s3api =
#  endpoint_url = https://s3.fr-par.scw.cloud" > ~/.aws/credentials


echo "Change directory to Source"
#mkdir website
#cd website

echo "Install yarn"
npm install -g yarn

echo "Install dependencies"
yarn install

echo "Run yarn build"
yarn run build

echo "Copying to website folder"
aws s3 sync ./build/ s3://${AWS_S3_BUCKET} --exact-timestamps --delete --region ${AWS_DEFAULT_REGION} $*

echo "Cleaning up things"

rm -rf ~/.aws
