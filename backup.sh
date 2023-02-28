#!/bin/bash

# This checks if the number of arguments is correct
# If the number of arguments is incorrect ( $# != 2) print error message and exit
if [[ $# != 2 ]]
then
  echo "backup.sh target_directory_name destination_directory_name"
  exit
fi

# This checks if argument 1 and argument 2 are valid directory paths
if [[ ! -d $1 ]] || [[ ! -d $2 ]]
then
  echo "Invalid directory path provided"
  exit
fi

# set variables and display their values
targetDirectory=$1
destinationDirectory=$2

echo $targetDirectory
echo $destinationDirectory

# get current time stamp and set a value of backup file
currentTS=$(date +%s) 
backupFileName="backup-[$currentTS].tar.gz"
# get yesterday's time stamp
yesterdayTS=$(($currentTS - 24 * 60 * 60))

# We're going to:
  # 1: Go into the target directory
  # 2: Create the backup file
  # 3: Move the backup file to the destination directory

# define variable of original path
# go into the target directory
# define variable of destination path
origAbsPath=$(pwd)
cd $destinationDirectory 
destDirAbsPath=$(pwd)

# change directory
cd $origAbsPath 
cd $targetDirectory 

# create the backup file
declare -a toBackup

for file in $(ls) # list all files and directoriess
do
  # if file is older than yesterdayTS
  if ((`date -r $file +%s` > $yesterdayTS))
  then
    # add file
    toBackup+=($file)
  fi
done

# create backup
tar -czvf $backupFileName ${toBackup[@]}

# move backup
mv $backupFileName $destDirAbsPath
