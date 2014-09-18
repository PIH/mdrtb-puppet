#! /bin/bash

  if [ ! -f /etc/ssl/private/pih-emr.org.key ]
  then
    echo "Please provide a username to fetch private data"
    read user
    # download the key from the amigo server
    scp $user@72.249.183.205:/home/backups/.keys/* .

    mv pih-emr.org.key /etc/ssl/private/
  fi


puppet apply -v \
  --detailed-exitcodes \
  --logdest=console \
  --logdest=syslog \
  --hiera_config=./hiera.yaml \
  --modulepath=./modules \
  manifests/site.pp
