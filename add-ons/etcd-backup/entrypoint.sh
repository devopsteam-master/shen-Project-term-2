#!/bin/bash
set -e -o pipefail

ENDPOINTS="$1"

echo $ENDPOINTS
NOW=$(date +%Y-%m-%d_%H:%M:%S)

# Configure MinIO client alias
mc alias set "$MINIO_ALIAS_NAME" "$MINIO_SERVER" "$MINIO_ACCESS_KEY" "$MINIO_SECRET_KEY" --api "$MINIO_API_VERSION" > /dev/null

# Optional: Check bucket list
# echo "Check bucket list"
# mc ls "$MINIO_ALIAS_NAME"

# Dump etcd snapshot to the archive
echo "Dumping etcd to $ARCHIVE"
echo "> ETCDCTL_API=3 etcdctl --endpoints=$ENDPOINTS --cacert=/certs/ca.crt --cert=/certs/healthcheck-client.crt --key=/certs/healthcheck-client.key snapshot save /tmp/etcd_backup_$NOW"
etcdctl --endpoints=$ENDPOINTS --cacert=/certs/ca.crt --cert=/certs/healthcheck-client.crt --key=/certs/healthcheck-client.key snapshot save /tmp/etcd_backup_$NOW

# Upload the backup to MinIO
#echo "salam" > a.txt
#mc put a.txt $MINIO_ALIAS_NAME/$MINIO_BUCKET
echo "Copying etcd_backup_$NOW to $MINIO_ALIAS_NAME/$MINIO_BUCKET"
echo "> mc put /tmp/etcd_backup_$NOW $MINIO_ALIAS_NAME/$MINIO_BUCKET --json"
mc put /tmp/etcd_backup_$NOW $MINIO_ALIAS_NAME/$MINIO_BUCKET || echo "Backup failed"; mc rm "$MINIO_ALIAS_NAME/$MINIO_BUCKET"

# Check the size of the backup file
echo "Size check"
ls -lah /tmp/etcd_backup_$NOW

echo "Backup complete"
