#!/bin/bash
AWS_BUCKET_NAME="$AWS_BUCKET_NAME"
HEALTH_CHECK_URL="$HEALTH_CHECK_URL"

if [ -z "$AWS_BUCKET_NAME" ];
then
    echo "Invalid Bucket Name"
    exit
fi

BACKUP_FOLDER="/tmp/influxdb"
CURRENT_DATETIME=`date +"%Y-%m-%d-%T"`
BACKUP_FILE_NAME="/tmp/${CURRENT_DATETIME}.tar.gz"

echo "Starting InfluxDB backup to $BACKUP_FOLDER"
influxd backup -portable /tmp/influxdb
if [ $? -ne 0 ]; then
    echo "Failed To Backup Influx"
    exit
fi

echo "Zipping Files To $BACKUP_FILE_NAME"
tar -czvf $BACKUP_FILE_NAME $BACKUP_FOLDER
if [ $? -ne 0 ]; then
    echo "Failed To Zip Archive"
    exit
fi

echo "Removing directory $BACKUP_FOLDER"
rm -rf $BACKUP_FOLDER

echo "Uploading To S3 Bucket: $AWS_BUCKET_NAME"
aws s3 cp $BACKUP_FILE_NAME "s3://$AWS_BUCKET_NAME/"
if [ $? -ne 0 ]; then
    echo "Failed To Upload To S3"
    exit
fi

rm $BACKUP_FILE_NAME

curl $HEALTH_CHECK_URL

echo "Done"