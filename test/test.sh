#!/bin/bash

quote=`cat webpage | grep "<img alt=" | tr -s ">" | cut -f2 -d ">" | cut -f1 -d "#" | grep -v "&" | cut -f2 -d "=" | tr -d '"' | shuf -n 1`

if [ -n "$quote" ]
then
	echo "Test passed!"
else
	echo "Test failed!"

fi
