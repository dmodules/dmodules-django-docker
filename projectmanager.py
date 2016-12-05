#!/bin/bash
# stop on errors

command=$1

if [ "$command" == 'backup' ]; then

    echo "Creating backup...."

    docker-compose run web python manage.py dumpdata > ./data/backups/db.json

    echo "Backup process finish"

fi


if [ "$command" == 'restore' ]; then

    echo "Restore backup...."

    docker-compose run web python manage.py loaddata /data/backups/db.json

    echo "Restore process finish"

fi