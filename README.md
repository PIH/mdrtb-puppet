Log on as root
------------------
$ sudo su -


Install puppet
------------------
```
cd /tmp
wget https://apt.puppetlabs.com/puppetlabs-release-precise.deb
dpkg -i puppetlabs-release-precise.deb
apt-get update
apt-get install puppet-common
puppet resource package puppet ensure=latest
```

Verify puppet has been installed
------------------
```
$ facter
```

Copy mdrtb puppet install package to /etc/puppet/
------------------
```
cd /etc/puppet/

apt-get install git
git clone --no-checkout https://github.com/PIH/mdrtb-puppet.git temp
mv temp/.git .
rm -rf temp
git reset --hard HEAD
git pull --rebase
```

Insert OpenMRS files
-------------------
* /etc/puppet/modules/openmrs/files/openmrs.tar.gz with a backup of your own openmrs database
* /etc/puppet/modules/openmrs/files/modules.tar.gz with a copy of your own .OpenMRS/modules folder
* /etc/puppet/modules/openmrs/files/openmrs.war with a your own version of openmrs.war file

Setup email
-----------
Modify hieradata/common.yaml with smtmp variables:
* smtp_username
* smtp_userpassword
* email_alerts_to

Run install
-----------
```
./install.sh
```
