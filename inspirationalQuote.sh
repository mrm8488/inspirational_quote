#! /bin/bash

web='https://www.values.com/inspirational-quotes'
page=`shuf -i 1-200 -n 1`
quote=`curl -s $web?page=$page | grep "<h6>" | tr -s ">" | cut -f3 -d ">" | sed 's/<.*//' | shuf -n 1`

echo "Daily quote: <<$quote>>"

# Made by Manuel Romero - mrm8488@gmail.com
