#!/bin/sh
#
# crypt/decrypt a file from/to a private Dropbox subdirectory using 
# openssl

# openssl aliases
SSLENC="openssl aes-256-cbc -salt -a"
SSLDEC="openssl aes-256-cbc -d -a"
HOSTNAME=$(uname -n)

function usage ()
{
	echo "Usage:"
	echo "script_dropbox_crypt.sh [crypt|decrypt] file"
	echo ""
}	

# check whether we are on laptop or desktop
if [ "${HOSTNAME}" = 'kortirion' ]; then
	DROPBOXDIR='/mnt/documents/Dropbox/crypt'
elif [ "${HOSTNAME}" = 'driftavalii' ]; then
	DROPBOXDIR="~/Dropbox/crypt"
else
	echo "Host unknown"
	exit 1
fi


if [ "$1" = 'crypt' ]; then
	$SSLENC -in "${2}" -out ${DROPBOXDIR}/$(basename "${2}".enc)
	echo "File encrypted!"
elif [ "$1" = 'decrypt' ]; then
	$SSLDEC -in "${2}" -out $(basename "${2%%.enc}")
	echo "File decrypted to current directory"
else
	usage
	exit 1
fi

exit 0
