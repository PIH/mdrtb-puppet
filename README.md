Log on as root
------------------
$ sudo su -

Install git
------------------
$ apt-get install git

Install puppet
------------------
$ cd /tmp/
$ wget https://apt.puppetlabs.com/puppetlabs-release-precise.deb
$ dpkg -i puppetlabs-release-precise.deb
$ apt-get update
$ apt-get install puppet-common
$ puppet resource package puppet ensure=latest

Verify puppet has been installed
------------------
$ facter

Copy mdrtb puppet install package
------------------
cd /etc/puppet/
cp -a /home/cioan/puppet/* .

./install.sh