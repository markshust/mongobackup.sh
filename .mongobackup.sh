#!/bin/bash
## This script syncs a mongodb backup to a Google Cloud Storage bucket.
##
## Author: Mark Shust <mark@shust.com>
## Version: 1.0.0

MONGO_DB=db-name
MONGO_HOST=rs0/db-host:27017
MONGO_USER=username
MONGO_PASS=password
HOST_DIR=/home/myhome
BACKUP_DIR=/mongobackup
BUCKET=gs://bucket-name
DATE=`date +%Y-%m-%d:%H:%M:%S`

sudo mkdir -p $HOST_DIR/$BACKUP_DIR

/usr/bin/docker run --rm \
  -v $HOST_DIR/$BACKUP_DIR:$BACKUP_DIR \
  markoshust/mongoclient \
  mongodump --host $MONGO_HOST -u $MONGO_USER -p $MONGO_PASS --db $MONGO_DB --out $BACKUP_DIR

sudo mkdir -p $HOST_DIR/$BACKUP_DIR/$MONGO_DB/$DATE
sudo mv $HOST_DIR/$BACKUP_DIR/$MONGO_DB/* $HOST_DIR/$BACKUP_DIR/$MONGO_DB/$DATE

/usr/bin/gsutil -m rsync -r $HOST_DIR/$BACKUP_DIR $BUCKET

sudo /bin/rm -rf $HOST_DIR/$BACKUP_DIR

echo 'Database backup complete.'
