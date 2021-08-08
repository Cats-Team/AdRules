cd /d %~dp0
cd aa
@echo off

::start download

wget -O i1.txt https://filters.adtidy.org/android/filters/2_optimized.txt
wget -O i2.txt https://filters.adtidy.org/android/filters/11_optimized.txt
wget -O i3.txt https://filters.adtidy.org/android/filters/3_optimized.txt
wget -O i4.txt https://filters.adtidy.org/android/filters/224_optimized.txt
wget -O i5.txt https://filters.adtidy.org/android/filters/14_optimized.txt
wget -O i6.txt https://filters.adtidy.org/android/filters/5_optimized.txt
wget -O i7.txt https://filters.adtidy.org/android/filters/4_optimized.txt

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

::count rules
for /f "tokens=2 delims=:" %%a in ('find /c /v "" nord.txt')do set/a rnum=%%a
::error
set/a rnum+=1

::add title and date
echo ! Version: %date%>>tpdate.txt
echo ! Last modified: %date%T%time%Z>>tpdate.txt
echo ! Total count: %rnum%>>tpdate.txt
copy title.dd+tpdate.txt+nord.txt+brules.dd final.txt

::end
copy /y final.txt ..\..\adguard.txt
del /f /q *.txt&exit
