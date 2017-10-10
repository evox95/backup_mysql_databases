#!/bin/bash

#   @author     Mateusz Batocha
#   @www        https://bestcoding.net

#
# MySQL credentials
#
MYSQL_USERNAME='root';
MYSQL_PASSWORD='rootPassword';
MYSQL_BACKUP_PATH='/home/backups';

#
# Test MySQL credentials
#
DB_con_ok=$(mysql -u$MYSQL_USERNAME -p$MYSQL_PASSWORD -e "SHOW DATABASES;" | grep "mysql")
if [[ $DB_con_ok != "mysql" ]]
then
    echo
    echo "The DB connection could not be established. Check you username and password and try again."
    echo
    exit;
fi

#
# Change dir to backups path
#
cd $MYSQL_BACKUP_PATH;

#
# Remove old backups (older than 7 days)
#
find . -mtime +7 -exec rm {} \;

#
# Get actual date
#
BACKUP_DATE=$(date +"%H_%M__%d_%m_%Y");

#
# backupDatabase 'databaseToBackup'
#
function backupDatabase {

    DB_NAME=$1;
    
    echo "";
    
    echo "Backing up '${DB_NAME}'...";
    
    mysqldump --force -u$MYSQL_USERNAME -p$MYSQL_PASSWORD $DB_NAME | gzip > "dbBackup__${DB_NAME}__${BACKUP_DATE}.sql.gz";
    
    echo "Database '${DB_NAME}' backup completed!";
    
}

#
# backupAllDatabases
#
function backupAllDatabases {

    echo "Getting databases list...";

    DATABASES=`mysql -u$MYSQL_USERNAME -p$MYSQL_PASSWORD -Bse "SHOW DATABASES;"`;
   
    for db in $DATABASES
    do
        backupDatabase $db;
    done
    
    echo "Databases backup completed!";
    
}

#
# run backup
#
backupAllDatabases;
