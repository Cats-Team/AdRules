#!/bin/bash
cd $(cd "$(dirname "$0")";pwd)
echo update upsteam
mkdir -p origin-files

dead_hosts=(
  "https://raw.githubusercontent.com/notracking/hosts-blocklists-scripts/master/domains.dead.txt"
  "https://raw.githubusercontent.com/notracking/hosts-blocklists-scripts/master/hostnames.dead.txt"
  "https://raw.githubusercontent.com/privacy-protection-tools/dead-horse/master/anti-ad-white-list.txt"
  "https://raw.githubusercontent.com/neodevpro/neodevhost/master/customallowlist"
  "https://raw.githubusercontent.com/notracking/hosts-blocklists-scripts/master/hostnames.whitelist.txt"
  "https://raw.githubusercontent.com/badmojr/1Hosts/master/submit_here/exclude_for_all.txt"
  "https://raw.githubusercontent.com/badmojr/1Hosts/master/submit_here/exclude_for_mini_Lite_only.txt"
  "https://raw.githubusercontent.com/Ultimate-Hosts-Blacklist/whitelist/master/domains.list"
)

allow=(
  "https://raw.githubusercontent.com/badmojr/1Hosts/master/submit_here/exclude_for_all.txt"
  "https://raw.githubusercontent.com/badmojr/1Hosts/master/submit_here/exclude_for_mini_Lite_only.txt"
  "https://raw.githubusercontent.com/notracking/hosts-blocklists-scripts/master/hostnames.whitelist.txt"
  "https://raw.githubusercontent.com/privacy-protection-tools/dead-horse/master/anti-ad-white-list.txt"
  "https://raw.githubusercontent.com/Ultimate-Hosts-Blacklist/whitelist/master/domains.list"
  "https://raw.githubusercontent.com/neodevpro/neodevhost/master/customallowlist"
  "https://raw.githubusercontent.com/ookangzheng/blahdns/master/hosts/whitelist.txt"
)

for i in "${!dead_hosts[@]}" "${!allow[@]}"
do
  curl -o "./origin-files/dead-hosts${i}.txt" --connect-timeout 60 -s "${dead_hosts[$i]}" &
  curl -o "./origin-files/allow${i}.txt" --connect-timeout 60 -s "${allow[$i]}" &
done
wait
cp ../mod/rules/*rule* ./origin-files/
cp ../tmp/{dns*,hosts*} ./origin-files/
cd origin-files
cat hosts*.txt | grep -Fv "local" | grep -Ev "(#|\/)" \
 | grep -P "^(127.0.0.1|0.0.0.0)" | sed -r 's/^(127.0.0.1|0.0.0.0)\s+//g' \
 | sed 's/[ ]//g'|sed '/^$/d' \
 | sort | uniq >base-src-hosts.txt

cat dead-hosts*.txt |sed -r "s/(\#|\!).*//g"| grep -v -E "^(#|\!)" \
 | sort | sed 's/[ ]//g'|sed '/^$/d'|sort \
 | uniq >base-dead-hosts.txt

cat allow*.txt |sed -r "s/(\#|\!).*//g"|grep -v -E "^(#|\!)"|grep "\." |grep -v "\*" \
 | sort | sed 's/[ ]//g'|sed '/^$/d'|sort \
 | uniq > ../../allow-domains-list.txt

cat dns* *rule*| grep -E "^\|\|[^\*\^]+?\^$" |grep -Po "(?<=\|\|).+(?=\^)" \
 |grep -Pv "^((25[0-5]|2[0-4]\d|((1\d{2})|([1-9]?\d)))\.){3}(25[0-5]|2[0-4]\d|((1\d{2})|([1-9]?\d)))$" | sort | uniq >base-src-easylist.txt
cat dns* *rule*| grep -E "^\|\|?([^\^=\/:]+)?\*([^\^=\/:]+)?\^$" |grep -Po "(?<=\|\|).+(?=\^)"| sort | uniq >wildcard-src-easylist.txt

#
#-----------------------------------------------
#
#F----
cat base-src-easylist.txt base-src-hosts.txt wildcard-src-easylist.txt | grep -vE ']|@|!|\/' \
| sed 's/[ ]//g' | sed '/^$/d' \
| sort|uniq >pre0-rules.txt

grep -vFf base-dead-hosts.txt pre0-rules.txt | sed '/^\s*$/d'| grep -vE ']|@|!|\/|\:' | sort > pre-rules.txt

echo Moding...
#Reading----
wl=`cat ../mod-lists.txt | grep -v "^#" | sed "s/\#.*//g"`

# Classification
wl0=`echo "$wl" | grep '^0 ' | sed 's/0 //g'`
wl1=`echo "$wl" | grep '^1 ' | sed 's/1 //g'`
wl2=`echo "$wl" | grep '^2 ' | sed 's/2 //g'`
wl4=`echo "$wl" | grep '^4 ' | sed 's/4 //g'`
rm=`echo "$wl" | grep '^3 ' | sed 's/3 //g'`

for i in `echo "$wl0"`
do
  sed -i "/$i/d" pre-rules.txt
done
wait

for i in `echo "$wl1"`
do
  sed -i "/.*$i/d" pre-rules.txt
done
wait

for i in `echo "$wl2"`
do
  sed -i "/$i/d" pre-rules.txt
done
wait

sed -i -r '/^$/d' pre-rules.txt
cat pre-rules.txt | grep -v "\*"| sed '/^$/d' > ../../ad-domains.txt
cat pre-rules.txt | sed 's/^/||/g'|sed "s/$/\^/g"|sed '/^$/d' > ../../dns.txt
cat pre-rules.txt |  grep -v "\*"|sed '/^$/d' |sed 's/^/0.0.0.0 /g' > ../../hosts.txt

wait
cd ../../

echo "$wl2"|sed "s/^/\@\@\|\|/g" |sed "s/$/\^/g" >> dns.txt

hostlist-compiler -c ./script/dns-rules-config.json -o dns-output.txt 
wait
rm -f allowtest.txt
mv -f dns-output.txt dns.txt
#wildcard
for i in $rm
do
  sed -i "/||.*$i^/d" dns.txt
  echo "$i" |sed 's/^/||/g'|sed 's/$/\^/g'>> dns.txt
done
wait

update_time="$(TZ=UTC-8 date +'%Y-%m-%d %H:%M:%S')(GMT+8)"
echo "# Title:AdRules Quantumult X List " > qx.conf
echo "# Title:AdRules SmartDNS List " > smart-dns.conf
echo "# Update: $update_time" >> qx.conf 
echo "# Update: $update_time" >> smart-dns.conf 

cat dns.txt|grep -v '@'|grep -Po "(?<=\|\|).+(?=\^)"| grep -v "\*" |sed 's/^/host-suffix,/g'|sed 's/$/,reject/g' >> ./qx.conf
cat dns.txt|grep -v '@'|grep -Po "(?<=\|\|).+(?=\^)"| grep -v "\*" |sed "s/^/address \//g"|sed "s/$/\/#/g" >> ./smart-dns.conf

rm -f ./script/origin-files/*.txt
cd ./script/

#Export Allowlist
wls=( "$wl0" "$wl1" "$wl2" "$wl4" )
for wl in "${wls[@]}"; do
    echo "$wl" | grep "\." | grep -v "\*" >> ../allow-domains-list.txt
done

#Remove
sed -i -r '/(.+)?api\.ad/d' ../allow-domains-list.txt

python rule.py ../allow-domains-list.txt

exit
