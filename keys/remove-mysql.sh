#! /bin/bash

/etc/init.d/mysql.server stop
rm -rf /etc/mysql
rm -rf /etc/init.d/mysql.server
rm -rf /usr/local/mysql