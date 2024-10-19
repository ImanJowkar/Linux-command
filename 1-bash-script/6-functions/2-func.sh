#!/bin/bash



create_files () {
	echo "creating $1"
	touch $1
	chmod 400 $1
	echo "Creating $2"
	touch $2
	chmod 600 $2
	return 10
}

create_files a.txt b.txt
