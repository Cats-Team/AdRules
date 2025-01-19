#!/bin/bash
LC_ALL='C'

update_time="$(TZ=UTC-8 date +'%Y-%m-%d %H:%M:%S')(GMT+8)"

cp ./mod/rules/*rule* ./tmp/dns/

cat ./tmp/dns/* | grep -Ev '[A-Z]' |grep -vE '@|:|\?|\$|\#|\!|/' | sort | uniq >dns.txt

hostlist-compiler -c ./script/dns-rules-config.json -o dns-output.txt 

cat dns-output.txt |grep -P "^\|\|[a-z0-9\.\-\*]+\^$"> dns.txt

python ./script/remove.py

cat ./mod/rules/first-dns-rules.txt >> dns.txt
python ./script/rule.py dns.txt
echo -e "! Total count: $(wc -l < dns.txt) \n! Update: $update_time" > total.txt
cat ./mod/title/dns-title.txt total.txt dns.txt | sed '/^$/d' > tmp.txt && mv tmp.txt dns.txt


echo "# Title:AdRules Quantumult X List " > qx.conf
echo "# Title:AdRules SmartDNS List " > smart-dns.conf
echo "# Title:AdRules List " > adrules.list
echo "# Update: $update_time" >> qx.conf 
echo "# Update: $update_time" >> smart-dns.conf 
echo "# Update: $update_time" >> adrules_domainset.txt 
echo "# Update: $update_time" >> adrules.list 

cat dns.txt |grep -vE '(@|\*)' |grep -Po "(?<=\|\|).+(?=\^)" | grep -v "\*" > ./domain.txt
cat domain.txt |sed 's/^/host-suffix,/g'|sed 's/$/,reject/g' >> ./qx.conf
cat domain.txt |sed "s/^/address \//g"|sed "s/$/\/#/g" >> ./smart-dns.conf
cat domain.txt |sed "s/^/domain:/g" > ./mosdns_adrules.txt
cat domain.txt |sed "s/^/\+\./g" >> ./adrules_domainset.txt
cat domain.txt |sed "s/^/DOMAIN-SUFFIX,/g" >> ./adrules.list

python ./script/dns-script/singbox.py
python ./script/dns-script/surge.py

wget -O ssc https://github.com/PuerNya/sing-srs-converter/releases/download/v2.0.1/sing-srs-converter-v2.0.1-linux-x86_64_v3
chmod +x ssc
./ssc adrules.list -m
mv adrules.list.srs adrules-singbox.srs

wget https://github.com/MetaCubeX/mihomo/releases/download/Prerelease-Alpha/version.txt
version=$(cat version.txt)
wget "https://github.com/MetaCubeX/mihomo/releases/download/Prerelease-Alpha/mihomo-linux-amd64-$version.gz"
gzip -d "mihomo-linux-amd64-$version.gz"
chmod +x "mihomo-linux-amd64-$version"
./"mihomo-linux-amd64-$version" convert-ruleset domain text adrules_domainset.txt adrules-mihomo.mrs

rm ssc mihomo-linux-amd64 *.gz version.txt
rm dns-output.txt total.txt domain.txt

exit
