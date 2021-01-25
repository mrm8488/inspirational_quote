#! /bin/bash

#is proxy required?
#proxyrequired=yes ## uncomment or set to no to disable proxy

curlproxy='http://10.20.30.40:8080'
if [[ "${proxyrequired}" == "yes" ]]; then
	curlcmd="curl --proxy ${curlproxy}"
else
	curlcmd='curl'
fi

# target websites
web='https://www.passiton.com/inspirational-quotes'
demotivateurl='https://despair.com/collections/demotivators'

# some defualts
cowsay='FALSE'
cowfile='elephant'
random='FALSE'
demotivate='FALSE'



# random (1-50) number for pagination
if [[ "$OSTYPE" =~ "darwin" ]]; then
	page=`jot -r 1 1 50`
else
	page=`shuf -i 1-50 -n 1`
fi

#errusage
errusage () {
echo "Usage:
	$0 --cowsay|-c [cowfile] -- Have quote in cowsay. You can specify the cowfile, or it will run whatever is set as default.
	$0 --random|-r -- Have quote in random cowsay.
	$0 --demotivate|-d -- Find a demotivational quote instead of motivational.
	$0 --help|-h -- This message.
"
}

# Transform long options to short
for arg in "$@"; do
  shift
  case "$arg" in
    "--help") set -- "$@" "-h" ;;
    "--random") set -- "$@" "-r" ;;
    "--cowsay") set -- "$@" "-c" ;;
    "--demotivate") set -- "$@" "-d" ;;
    *)		set -- "$@" "$arg" 
  esac
done

# Parse short options
ARGS=""
while [ $# -gt 0 ]
do
	unset OPTIND
	unset OPTARG
	while getopts "hrdc" opt
	do
	  case "${opt}" in
		h)  errusage
			exit 0
		;;
		r)  random=TRUE
		    cowsay=TRUE
	        ;;
		d)  demotivate=TRUE
	        ;;
		c)  #if [[ "$OPTIND" == 
		    #defaultcow="$OPTARG"
		    cowsay=TRUE
	        ;;
		:)  cowsay=TRUE
		    defaultcow="$cowfile"
	        ;;
		?)  errusage >&2
	        ;;
	esac
	done
	shift $((OPTIND-1))
	ARGS="${ARGS} $1 "
	shift
done
#shift $(($OPTIND - 1))

if [ -z $ARGS ]; then
	defaultcow="$cowfile"
else
	defaultcow="$ARGS"
fi

# magic! (filter web elements to get a quote)
getquote () {
if [[ "${demotivate}" == "TRUE" ]]; then
	quote=`$curlcmd -s $demotivateurl | grep "<p>" | grep -v "Sign up for" | awk '{$1=$1};1' | sed 's/<p>//' | sed 's/<\/p>//' | sort -R | head -1`
else
	quote=`$curlcmd -s $web?page=$page | grep "<img alt=" | tr -s ">" | cut -f2 -d ">" | cut -f1 -d "#" | cut -f2 -d '"' | grep -v "&" | sort -R | head -1`
fi
}

if [ -z "$quote" ]; then
	getquote
fi

if [[ "$cowsay" == "TRUE" ]]; then 
		if [ -x "$(command -v cowsay)" ]; then
			if [[ "$random" == "TRUE" ]]; then
				cowsay -f $(cowsay -l | grep -v Cow | tr ' ' '\n' | sort -R | head -1) <<< "$quote"
			else
				cowsay -f ${defaultcow} <<< "$quote"
			fi
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


# Based on inspirationalQuote by Manuel Romero - mrm8488@gmail.com
# Modified by Brantley Padgett - brantleyp1@yahoo.com
