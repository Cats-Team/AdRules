#!/bin/sh
LC_ALL='C'

cd tmp

# Start Merge and Duplicate Removal

echo Start Merge

rules=(
  jiekouAD.txt
  224.txt
  NoAppDownload.txt
  cjx-annoyance.txt
  anti-adblock-killer-filters.txt
  antiadblockfilters.txt
  abp-filters-anti-cv.txt
)

#Lite
echo " " > pre-lite.txt

for file in "${rules[@]}"
do
  cat "./content/$file" >> pre-lite.txt
done

echo "! Version: $(TZ=UTC-8 date +'%Y-%m-%d %H:%M:%S')(GMT+8) " > tpdate.txt 
cat ../mod/title/adblock_lite-title.txt .././mod/rules/adblock-rules.txt pre-lite.txt \
 | grep -Ev "^((\!)|(\[)).*" | sort -n | uniq > adblock_lite_pre.txt
grep -vxFf ../mod/rules/adblock-need-remove.txt ./adblock_lite_pre.txt > adblock_lite.txt
 
python ../script/rule.py adblock_lite.txt
echo "! Total count: $(wc -l < adblock_lite.txt)" > total.txt
cat ../mod/title/adblock_lite-title.txt tpdate.txt total.txt adblock_lite.txt > tmp.txt && mv tmp.txt adblock_lite.txt


#Normal
cat ../mod/title/adblock_lite-title.txt adblock_lite.txt ./content/{3.txt,clear_urls_uboified.txt,easyprivacy.txt}\
 | grep -Ev "^((\!)|(\[)).*" | sort -n | uniq > adblock_pre.txt  
grep -vxFf ../mod/rules/adblock-need-remove.txt ./adblock_pre.txt  > adblock.txt

python ../script/rule.py adblock.txt
echo "! Total count: $(wc -l < adblock.txt)" > total.txt
cat ../mod/title/adblock-title.txt tpdate.txt total.txt adblock.txt > tmp.txt && mv tmp.txt adblock.txt


#Plus
cat adblock.txt ./content/*.txt \
 | grep -Ev "^((\!)|(\[)).*" | sort -n | uniq  > adblock_plus_pre.txt  
grep -vxFf ../mod/rules/adblock-need-remove.txt ./adblock_plus_pre.txt > adblock_plus.txt


python ../script/rule.py adblock_plus.txt
echo "! Total count: $(wc -l < adblock_plus.txt)" > total.txt
cat ../mod/title/adblock_plus-title.txt tpdate.txt total.txt adblock_plus.txt > tmp.txt && mv tmp.txt adblock_plus.txt

rm adblock*pre.txt
mv adblock*.txt ../

exit
