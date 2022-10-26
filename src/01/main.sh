#!/bin/bash

if ! [[ $1 =~ ^[+-]?[0-9]+$ ]];
then
	echo >&2 $1
	exit 1
else
	echo "Incorrect input"
fi
