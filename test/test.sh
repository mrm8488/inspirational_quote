#!/bin/bash

quote=`cat webpage | grep "<h6>" | tr -s ">" | cut -f3 -d ">" | sed 's/<.*//' | shuf -n 1`

if [ -n "$quote" ]
then
	echo "Test passed!"
else
	echo "Test failed!"

fi
