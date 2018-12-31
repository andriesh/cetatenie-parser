#!/bin/bash
# Author: Andriesh Rusnac
case=$1
re='^[0-9]+$'
if ! [[ $case =~ $re ]] ; then
	echo "error: Not a case number" >&2; exit 1
fi
if [[ ! -f `which pdfgrep` ]]; then
	echo "error: pdfgrep not installed" >&2; exit 1
fi

downloader() {
host='http://cetatenie.just.ro'
for D in `curl -s ${host}/index.php/ro/ordine/articol-11 | grep -zoP '<a[^<]*[^<]*href="\K[^"]+' | egrep "2017|2018|2019" | grep '/images/Ordin_nr' | uniq`
do
D=`echo $D | sed 's/\/images\///'`
if [[ ! -f ./pdf/${D} ]]; then
	echo "New doc: ${host}/images/${D}"
	wget ${host}/images/${D} -P ./pdf/
fi
done
}

searching() {
for p in `ls ./pdf/*.pdf`; do
echo "Searching in $p"
pdfgrep $case $p |grep -B1 $case
done
}


## Controls
downloader
searching
