#!/bin/bash

source /etc/profile

cd $(cd "$(dirname "$0")";pwd)

#bash ./rebuilt-dns-list.sh
cat ./tmp/l.txt >> dns.txt

cat ./tmp/dns998* >> dns.txt
cat ./mod/rules/*-rules.txt |grep -E "^[(\@\@)|(\|\|)][^\/\^]+\^$" |sort|uniq >> dns.txt

cat ./script/*/white_domain_list.php |grep -Po "(?<=').+(?=')" | sed "s/^/||&/g" |sed "s/$/&^/g"| sed '/^$/d'   > allowtest.txt
hostlist-compiler -c ./script/dns-rules-config.json -o dns-output.txt &
wait
#rm -f allowtest.txt
mv -f dns-output.txt dns.txt
cat ./mod/rules/*-rules.txt |grep -E "^[(\@\@)][^\/\^]+\^$" |sort|uniq >> dns.txt
cd ./script/
cd ../
bash ./sc*/exin*dns.sh
