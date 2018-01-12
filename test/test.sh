#!/bin/bash

quote=`cat webpage | grep "<img alt=" | tr -s ">" | cut -f2 -d ">" | cut -f1 -d "#" | cut -f2 -d '"' | grep -v "&" | shuf -n 1`

if [ -n "$quote" ]
then
	echo "Test passed!"
else
	echo "Test failed!"

fi
