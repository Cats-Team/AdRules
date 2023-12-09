#!/bin/bash
cd $(cd "$(dirname "$0")";pwd)
echo update upsteam
mkdir -p origin-files

dead_hosts=(
  "https://raw.githubusercontent.com/badmojr/1Hosts/master/submit_here/exclude_for_all.txt"
  "https://raw.githubusercontent.com/badmojr/1Hosts/master/submit_here/exclude_for_mini_Lite_only.txt"
  "https://raw.githubusercontent.com/Cats-Team/deadhosts/main/dead.txt"
)

for i in "${!dead_hosts[@]}"
do
  curl -o "./origin-files/dead-hosts${i}.txt" -s "${dead_hosts[$i]}" &
done
wait

cp ../mod/rules/*rule* ./origin-files/
cp ../tmp/dns/* ./origin-files/
cd origin-files

cat *.txt | grep -P "^(127.0.0.1|0.0.0.0)" | grep -Fv "local" | grep -Ev "(#|\/)" \
 | sed -r 's/^(127.0.0.1|0.0.0.0)\s+//g' \
 | sed 's/[ ]//g'|sed '/^$/d' \
 | sort | uniq >base-src-hosts.txt

cat dead-hosts*.txt |sed -r "s/(\#|\!).*//g"| grep -v -E "^(#|\!)" \
 | sort | sed 's/[ ]//g'|sed '/^$/d'|sort \
 | uniq >base-dead-hosts.txt

cat dns-rules.txt *.txt | grep -E "^\|\|[^\*\^]+?\^$" |grep -Po "(?<=\|\|).+(?=\^)" \
 | sort | uniq >base-src-easylist.txt


#-----------------------------------------------

cat base-src-easylist.txt base-src-hosts.txt | grep -vE ']|@|!|\/' \
| sed 's/[ ]//g' | sed '/^$/d' \
| sort | uniq >pre0-rules.txt

grep -v -x -F -f base-dead-hosts.txt pre0-rules.txt | sed '/^\s*$/d' | grep -vE ']|@|!|\/|\:' | grep -vE "^(\.|-)" | sort > pre-rules.txt

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

for i in $rm
do

  echo -e "$i\n" >> dns.txt
done


cat ./mod/rules/dns-rules.txt | grep -vP "^/|^!" >> dns.txt
hostlist-compiler -c ./script/dns-rules-config.json -o dns-output.txt 

cat dns-output.txt |grep -v "!" > dns.txt
rm -f dns-output.txt
cat ./mod/rules/first-dns-rules.txt >> dns.txt
cat ./mod/rules/dns-rules.txt | grep -P "^/" >> dns.txt

update_time="$(TZ=UTC-8 date +'%Y-%m-%d %H:%M:%S')(GMT+8)"
echo "# Title:AdRules Quantumult X List " > qx.conf
echo "# Title:AdRules SmartDNS List " > smart-dns.conf
echo "# Title:AdRules List " > ./adrules.list
echo "# Update: $update_time" >> qx.conf 
echo "# Update: $update_time" >> smart-dns.conf 
echo "# Update: $update_time" >> adrules_domainset.txt 
echo "# Update: $update_time" >> ./adrules.list 

cat dns.txt |grep -vE '(@|\*)' |grep -Po "(?<=\|\|).+(?=\^)" | grep -v "\*" |sed 's/^/host-suffix,/g'|sed 's/$/,reject/g' >> ./qx.conf
cat dns.txt |grep -vE '(@|\*)' |grep -Po "(?<=\|\|).+(?=\^)" | grep -v "\*" |sed "s/^/address \//g"|sed "s/$/\/#/g" >> ./smart-dns.conf
cat dns.txt |grep -vE '(@|\*)' |grep -Po "(?<=\|\|).+(?=\^)" | grep -v "\*" |sed "s/^/domain:/g" > ./mosdns_adrules.txt
cat dns.txt |grep -vE '(@|\*)' |grep -Po "(?<=\|\|).+(?=\^)" | grep -v "\*" |sed "s/^/\+\./g" >> ./adrules_domainset.txt
cat dns.txt |grep -vE '(@|\*)' |grep -Po "(?<=\|\|).+(?=\^)" | grep -v "\*" |sed "s/^/DOMAIN-SUFFIX,/g" >> ./adrules.list


rm -f ./script/origin-files/*.txt
cd ./script/

#Export Allowlist
wls=( "$wl0" "$wl1" "$wl2" "$wl4" )
for wl in "${wls[@]}"; do
    echo "$wl" | grep "\." | grep -v "\*" >> ../allow-domains-list.txt
done

python rule.py ../allow-domains-list.txt
python rule.py ../dns.txt

exit
