#! /bin/bash 

USERNAME=backups
REMOTE_SERVER_ADDRESS=72.249.183.205
SSH_KEYS_PARAMS="-o IdentityFile=/etc/puppet/keys/id_rsa -o UserKnownHostsFile=~/.ssh/known_hosts -o PasswordAuthentication=no"

# my Mac
# SSH_KEYS_PARAMS="-o IdentityFile=/Users/cosmin/pih/dev/haiti/mdrtb-puppet/keys/id_rsa -o UserKnownHostsFile=~/.ssh/known_hosts -o PasswordAuthentication=no"


CONNECT_TO_SERVER="ssh $SSH_KEYS_PARAMS $USERNAME@$REMOTE_SERVER_ADDRESS"


# connect to the parent server
# ssh $SSH_KEYS_PARAMS $USERNAME@$REMOTE_SERVER_ADDRESS "ls -lah"
$CONNECT_TO_SERVER "ls -lah"
if [ "$?" = "0" ]; then
	echo "Successfully connected to the parent server"
else
	echo "Failed to connect to the parent server" 1>&2
	exit 1
fi

