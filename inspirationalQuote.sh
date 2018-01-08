#! /bin/bash

web='https://www.passiton.com/inspirational-quotes'
page=`shuf -i 1-50 -n 1`
quote=`curl -s $web?page=$page | grep "<img alt=" | tr -s ">" | cut -f2 -d ">" | cut -f1 -d "#" | grep -v "&" | cut -f2 -d "=" | tr -d '"' | shuf -n 1`

echo "Daily quote: <<$quote>>"

# Made by Manuel Romero - mrm8488@gmail.com
