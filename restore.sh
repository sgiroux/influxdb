#!/bin/bash
RESTORE_URL="$1"

if [ -z "$RESTORE_URL" ];
then
    echo "Invalid URL Supplied"
    exit
fi

URL="${RESTORE_URL}"
echo "Starting backup restoration from ${URL}"

# Clean up
rm -f /tmp/backup.tar.gz
rm -rf /tmp/backup
aws s3 cp "${URL}" /tmp/backup.tar.gz

mkdir /tmp/backup
tar xf /tmp/backup.tar.gz -C /tmp/backup

influxd restore -portable /tmp/backup/tmp/influxdb/

echo "Restoration complete"