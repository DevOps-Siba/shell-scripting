#!/bin/bash
#Director backup with rotaion 
#keep only last 3 backups
#Step:1 Check if user gave a directory path 
if [ -z "$1" ]; then
	echo "Please provide a directory path"
	echo "Example: ./backup_with_rotation.sh /home/dws/backup-test"
        exit 1

fi

DIR="$1"

#Check if directory exists
if [ ! -d "$DIR" ]; then
	echo "directory doesnot exit"

	exit 1

fi


#Create time stamp for backup name :
#
DATE=$(date +"%Y-%m-%d_%H-%M-%S")
BACKUP_NAME="backup_$DATE"
BACKUP_PATH="$DIR/$BACKUP_NAME"


# Step 4: Create backup folder
mkdir "$BACKUP_PATH"

# Step 5: Copy files to backup folder
# -a : archive mode (keeps permissions)
# --exclude : do not copy old backups
rsync -a --exclude="backup_*" "$DIR/" "$BACKUP_PATH/"


echo "Backup created: $BACKUP_PATH"

# Step 6: Get list of all backup folders
BACKUPS=$(ls -d "$DIR"/backup_* 2>/dev/null)

# Step 7: Count number of backups
BACKUP_COUNT=$(echo "$BACKUPS" | wc -l)

# Step 8: If more than 3 backups, delete old ones
if [ "$BACKUP_COUNT" -gt 3 ]; then
    OLD_BACKUPS=$(echo "$BACKUPS" | sort | head -n $(($BACKUP_COUNT - 3)))

    for OLD in $OLD_BACKUPS
    do
        echo "Deleting old backup: $OLD"
        rm -rf "$OLD"
    done
fi

