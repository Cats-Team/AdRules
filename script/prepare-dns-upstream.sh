#!/bin/bash

source /etc/profile
echo 更新上游中
cd $(cd "$(dirname "$0")";pwd)
mkdir -p origin-files
rm ./origin-files/*
dead_hosts=(
  "https://raw.githubusercontent.com/notracking/hosts-blocklists-scripts/master/domains.dead.txt"
  "https://raw.githubusercontent.com/notracking/hosts-blocklists-scripts/master/hostnames.dead.txt"
  "https://raw.githubusercontent.com/privacy-protection-tools/dead-horse/master/anti-ad-white-list.txt"
  "https://raw.githubusercontent.com/neodevpro/neodevhost/master/customallowlist"
  "https://raw.githubusercontent.com/notracking/hosts-blocklists-scripts/master/hostnames.whitelist.txt"
  "https://raw.githubusercontent.com/badmojr/1Hosts/master/submit_here/exclude_for_all.txt"
  "https://raw.githubusercontent.com/AdroitAdorKhan/EnergizedProtection/master/core/filter/whitelist"
  "https://raw.githubusercontent.com/Ultimate-Hosts-Blacklist/whitelist/master/domains.list"
)
allow=(
  "https://raw.githubusercontent.com/badmojr/1Hosts/master/submit_here/exclude_for_all.txt"
  "https://raw.githubusercontent.com/notracking/hosts-blocklists-scripts/master/hostnames.whitelist.txt"
  "https://raw.githubusercontent.com/privacy-protection-tools/dead-horse/master/anti-ad-white-list.txt"
  "https://raw.githubusercontent.com/AdroitAdorKhan/EnergizedProtection/master/core/filter/whitelist"
  "https://raw.githubusercontent.com/Ultimate-Hosts-Blacklist/whitelist/master/domains.list"
  "https://raw.githubusercontent.com/neodevpro/neodevhost/master/customallowlist"
)
for i in "${!dead_hosts[@]}" "${!allow[@]}"
do
  curl -o "./origin-files/dead-hosts${i}.txt" --connect-timeout 60 -s "${dead_hosts[$i]}" &
  curl -o "./origin-files/allow${i}.txt" --connect-timeout 60 -s "${allow[$i]}" &
done
cp ../mod/rules/*rule* ./origin-files/
cp ../tmp/{dns*,base*,hosts*,pre-allow1.txt} ./origin-files/
cd origin-files
mv pre-allow1.txt dns99999.txt
cat hosts*.txt | grep -v -E "^((#.*)|(\s*)|(\!.*))$" \
 | grep -Fv "local" | grep -Ev "(#|\/)" \
 | grep -v -E "^[0-9\.:]+\s+(ip6\-)?(localhost|loopback)$" \
 | sed 's/0.0.0.0/127.0.0.1/g' | sed 's/::/127.0.0.1/g' | sed 's/127.0.0.1 //g' |grep -Pv "((25[0-5]|2[0-4]\d|((1\d{2})|([1-9]?\d)))\.){3}(25[0-5]|2[0-4]\d|((1\d{2})|([1-9]?\d)))" | sort \
 | uniq >base-src-hosts.txt

cat dead-hosts*.txt | grep -v -E "^(#|\!)" \
 | sort | sed 's/[ ]//g'|sort \
 | uniq >base-dead-hosts.txt

cat allow*.txt | grep -v -E "^(#|\!)" |grep "\." |grep -v "\*" \
 | sort | sed 's/[ ]//g'|sed '/^$/d'|sort \
 | uniq > ../../allow-domains-list.txt

cat dns* *rule*| grep -E "^\|\|[^\*\^]+?\^$" |grep -Po "(?<=\|\|).+(?=\^)" \
 |grep -Pv "^((25[0-5]|2[0-4]\d|((1\d{2})|([1-9]?\d)))\.){3}(25[0-5]|2[0-4]\d|((1\d{2})|([1-9]?\d)))$" | sort | uniq >base-src-easylist.txt
cat dns* *rule*| grep -E "^\|\|?([^\^=\/:]+)?\*([^\^=\/:]+)?\^$" |grep -Po "(?<=\|\|).+(?=\^)"| sort | uniq >wildcard-src-easylist.txt
cat dns* *rule*| grep -E "^@@\|\|?[^\^=\/:]+?\^([^\/=\*]+)?" | sort | uniq >whiterule-src-easylist.txt

cd ../
#bash ./build-dns-list.sh
