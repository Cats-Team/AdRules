cd /d %~dp0
cd aa
@echo off

::start download

wget -O i1.txt https://adguardteam.github.io/AdGuardSDNSFilter/Filters/filter.txt
wget -O i2.txt https://raw.githubusercontent.com/o0HalfLife0o/list/master/ad-pc.txt
wget -O i3.txt https://raw.githubusercontent.com/o0HalfLife0o/list/master/ad-edentw.txt
wget -O i4.txt https://raw.githubusercontent.com/banbendalao/ADgk/master/ADgk.txt
wget -O i5.txt http://file.trli.club/dns/hosts.txt
wget -O i6.txt https://adaway.org/hosts.txt
wget -O i7.txt https://anti-ad.net/adguard.txt
wget -O i8.txt https://raw.githubusercontent.com/banbendalao/ADgk/master/kill-baidu-ad.txt
wget -O i9.txt https://raw.githubusercontent.com/xinggsf/Adblock-Plus-Rule/master/rule.txt
wget -O i10.txt https://easylist-downloads.adblockplus.org/antiadblockfilters.txt
wget -O i11.txt https://raw.githubusercontent.com/uniartisan/adblock_list/master/adblock.txt
wget -O i12.txt https://raw.githubusercontent.com/uniartisan/adblock_list/master/adblock_lite.txt
wget -O i13.txt https://raw.githubusercontent.com/uniartisan/adblock_list/master/adblock_plus.txt
wget -O i14.txt https://raw.githubusercontent.com/uniartisan/adblock_list/master/adblock_privacy.txt
wget -O i15.txt https://raw.githubusercontent.com/uBlockOrigin/uAssets/master/filters/annoyances.txt
wget -O i16.txt https://raw.githubusercontent.com/uBlockOrigin/uAssets/master/filters/badware.txt
wget -O i17.txt https://raw.githubusercontent.com/uBlockOrigin/uAssets/master/filters/filters.txt
wget -O i18.txt https://raw.githubusercontent.com/uBlockOrigin/uAssets/master/filters/privacy.txt


::add new rules
::wget -O i+number url

::end download

::no need to change
del /f /q *.html
del /f /q *hsts

::TheRuleMaker
::No need to change

::Merge
type frules.dd>mergd.txt
type i*.txt>>mergd.txt

::nore
gawk "!a[$0]++" mergd.txt>nore.txt

::del comments
(FOR /F "eol=# delims=" %%i in (nore.txt) do (echo %%i))>ktmp.txt
(FOR /F "eol=[ delims=" %%i in (ktmp.txt) do (echo %%i))>stmp.txt
(FOR /F "eol=! delims=" %%i in (stmp.txt) do (echo %%i))>nord.txt

::add title and date
echo ! Version: %date%>>tpdate.txt
echo ! Last modified: %date%T%time%Z>>tpdate.txt
copy title.dd+tpdate.txt+nord.txt+brules.dd final.txt

::end
copy /y final.txt ..\..\AdKillRules.txt
del /f /q *.txt&exit
