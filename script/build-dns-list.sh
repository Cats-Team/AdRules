#!/bin/bash

source /etc/profile

cd $(cd "$(dirname "$0")";pwd)

php make-dns-addr.php
echo
echo "! Title: AdRules for AdGuard" > ../easylist.txt
echo "! Version: $(date "+%Y%m%d%H%M%S%N")" >> ../easylist.txt
echo "! Homepage: https://anti-ad.net/" >> ../easylist.txt
echo "! Total lines: 00000" >> ../easylist.txt
grep -vE '^!' ../dns.txt >> ../easylist.txt
php ./tools/adguard-extend.php ../easylist.txt
php ./tools/easylist-extend.php ../dns.txt
cat ../tmp/{l.txt,dns998*} >>../dns.txt
cat .././mod/rules/*-rules.txt |grep -E "^[(\@\@)|(\|\|)][^\/\^]+\^$" |sort|uniq >> ../dns.txt
