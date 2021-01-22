#! /bin/bash
curlcmd='curl --proxy http://10.20.30.40:8080'
# target web
web='https://www.passiton.com/inspirational-quotes'

# random (1-50) number for pagination
if [[ "$OSTYPE" =~ "darwin" ]]; then
	page=`jot -r 1 1 50`
else
	page=`shuf -i 1-50 -n 1`
fi

# magic! (filter web elements to get a quote)
getquote () {
if [[ "$OSTYPE" =~ "darwin" ]]; then
	quote=`$curlcmd -s $web?page=$page | grep "<img alt=" | tr -s ">" | cut -f2 -d ">" | cut -f1 -d "#" | cut -f2 -d '"' | grep -v "&" | head -$(jot -r 1 ) | tail -1`
else
	quote=`$curlcmd -s $web?page=$page | grep "<img alt=" | tr -s ">" | cut -f2 -d ">" | cut -f1 -d "#" | cut -f2 -d '"' | grep -v "&" | shuf -n 1`
fi
}

if [ -z "$quote" ]; then
	getquote
fi

if [ -n $1 ]; then 
	if [[ "$1" == "-c" ]]; then
		if [ -x "$(command -v cowsay)" ]; then
			if [ -z $2 ]; then
				cowsay -f elephant <<< "$quote"
			else
				cowsay -f $2 <<< "$quote"
			fi
		else
fmt <<< "
Daily quote:

$quote

Suggest you install 'cowsay' to vastly improve this quote.
"
		fi
	elif [[ "$1" == "-r" ]]; then
		if [ -x "$(command -v cowsay)" ]; then
				cowsay -f $(cowsay -l | grep -v Cow | tr ' ' '\n' | sort -R | head -1) <<< "$quote"
		else
fmt <<< "
Daily quote:

$quote

Suggest you install 'cowsay' to vastly improve this quote.
"
		fi
	else
		fmt <<< "
Daily quote:

$quote
"
	fi
else
	fmt <<< "
Daily quote:

$quote
"
fi


# Based on inspirationalQuote by Manuel Romero - mrm8488@gmail.com
# Modified by Brantley Padgett - brantleyp1@yahoo.com
