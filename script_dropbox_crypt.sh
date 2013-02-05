#!/bin/sh
#
# crypt/decrypt a file from/to a private Dropbox subdirectory using 
# openssl

DROPBOXDIR='/mnt/documents/Dropbox/crypt'

# openssl aliases
SSLENC="openssl aes-256-cbc -salt -a"
SSLDEC="openssl aes-256-cbc -d -a"
HOSTNAME=$(uname -n)
# flags
DECRYPT=0
CRYPT=0
ERASE=0

function usage ()
{
	echo "Usage:"
	echo "script_dropbox_crypt.sh -d|-c [-e] file(s)"
	echo ""
}	

function cryptfiles()
{
	for file in "$@"; do
		echo "Encrypting $file ..."
		$SSLENC -in $file -out ${DROPBOXDIR}/$(basename "$file".enc)
		if [ $? -eq 1 ]; then
			exit 1
		else
			if [[ $ERASE -gt 0 ]]; then
				rm "$file"
				echo "File encrypted!"
			else
				echo "File encrypted!"
			fi
		fi
	done
}

function decryptfiles()
{
	for file in "$@"; do
		echo "Decrypting $file ..."
		$SSLDEC -in "$file" -out $(basename "${file%%.enc}")
		if [ $? -eq 1 ]; then
			exit 1
		else
			if [[ $ERASE -gt 0 ]]; then
				rm "$file"
				echo "File decrypted!"
			else
				echo "File decrypted!"
			fi
		fi
	done
}


while getopts cde opt; do
	case "$opt" in
		c) CRYPT=1;; # crypting mode
		d) DECRYPT=1;; # decrypting mode
		e) ERASE=1;; # erase the input files after successful de/encryption
		*) usage;;
	esac
done

# remove all arguments but for the very last one (should be the file)
shift $(( OPTIND -1 ))

if [[ $CRYPT -gt 0 ]]; then
	cryptfiles "$@"
elif [[ $DECRYPT -gt 0 ]]; then
	decryptfiles "$@"
else
	usage
	exit 1
fi

exit 0
