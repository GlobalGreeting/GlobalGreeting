#!/bin/bash

### Check to see if any files have changed

status="$(git status | grep Changes)"
if [ -n "$status" ]; then
    git add .
    git commit -m "$1"
    git push -u origin master
else
    echo "No Changes"
    exit
fi

### Create the Primary Bucket (if necessary) and enable Versioning

buckets="$(aws --profile globalgreeting s3api list-buckets --query 'Buckets[].Name' | grep globalgreetingeast)"
if [ -z "$buckets" ]; then
    echo 'Create Global Greeting East (Primary) Bucket; Enable Versionion'
    aws s3 mb s3://globalgreetingeast --profile globalgreeting --region us-east-1
    aws s3api put-bucket-versioning --profile globalgreeting --bucket globalgreetingeast --versioning-configuration Status=Enabled
else
    echo "Primary Bucket Exists"
fi

### Create the Backup Bucket (if necessary) and enable Versioning

buckets="$(aws --profile globalgreeting s3api list-buckets --query 'Buckets[].Name' | grep globalgreetingcopy)"
if [ -z "$buckets" ]; then
    echo 'Create Global Greeting West (Backup) Bucket; Enable Versioning'
    aws s3 mb s3://globalgreetingcopy --profile globalgreeting --region us-west-1
    aws s3api put-bucket-versioning --profile globalgreeting --bucket globalgreetingcopy --versioning-configuration Status=Enabled
else
    echo "Backup Bucket Exists"
fi

### Sync the files from the local repository to the Primary Bucket

echo 'Sync Files to Global Greeting East Bucket'
aws s3 sync . s3://globalgreetingeast --profile globalgreeting --exclude '.gitignore' --exclude 'policy.json' --exclude '.git/*' --exclude '*.md' --exclude '*.sh*'

### Sync the files from the Primary Bucket to the Backup Bucket

echo 'Sync Files to Global Greeting West Bucket'
aws s3 sync s3://globalgreetingeast s3://globalgreetingcopy --profile globalgreeting

### Ensure the files in the bucket are accessible

echo 'Enable Access'
aws s3api put-bucket-policy --bucket globalgreetingeast --policy file://policy.json --profile globalgreeting

### Configure the Bucket as a website

echo 'Setup the Bucket as a website'
aws s3 website s3://globalgreetingeast --profile globalgreeting --index-document index.html --error-document error.html

### Ensure the website is accessible

echo 'Check Website'
content="$(curl https://globalgreetingeast.s3.amazonaws.com/index.html --silent | grep Chinese)"

if [ -z "$contents" ]; then
    echo "Success: website created and available"
else
    echo "Fail: website not available"
fi

