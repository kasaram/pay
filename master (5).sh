var=`ls -ltr test.txt 2> /dev/null |wc -l`
if [ "$var" -eq 0 ]; then
echo "Input File test.txt is missing, please add the test.txt to make it work"
else
cp -p test.txt test_bak.txt

sed -i -e '/WARNING:/w temp1.txt' -e '//d' test.txt
echo " ">> temp1.txt
sed  -i '1i WARNINGS :' temp1.txt
cat temp1.txt >> test.txt
line=$(grep -n 'WRAPPER INFO, WARNINGS, AND ERRORS BELOW' test.txt | cut -d ":" -f 1)
line1=1
sum=`expr $line - $line1`
cat test.txt | head -$sum >temp2.txt
sed '1i\\' temp2.txt > temp3.txt
cat temp3.txt >> test.txt

sed -i '1,/WRAPPER INFO, WARNINGS, AND ERRORS BELOW/d' test.txt

sed '/WARNINGS :/,$d' test.txt > temp1.txt

##########################################################################################################################
sed -i '/^$/d' temp1.txt

sed '/--/!d' temp1.txt > temp2.txt
cat temp2.txt > temp1.txt

cat temp1.txt | awk '{if(a!=$1) {a=$1; printf "\n%s%s",$0,FS} else {a=$1;$1="";printf $0 }} END {printf "\n" }' > temp2.txt

sed -i -- 's/\./,/g' temp2.txt
sed -i -- 's/ -- /,/g' temp2.txt

awk -F, -v OFS=, '{tmp=$1;$1=$2;$2=tmp;print}' temp2.txt > temp1.txt

cat temp1.txt | awk '{if(a!=$1) {a=$1; printf "\n%s%s",$0,FS} else {a=$1;$1="";printf $0 }} END {printf "\n" }' > temp2.txt

sed -i -- 's/table created  /table created,/g' temp2.txt
sed -i -- 's/table failed  /table failed,/g' temp2.txt


touch table.html
cat /dev/null > table.html

awk -F, '{print $1,$3,$4,$6,$5,$2,$7}' OFS=, "temp2.txt" > temp3.txt

sed -i -- 's/encrypted,,,/,,encrypted,/g' temp3.txt
sed -i -- 's/encrypted  ,,,/,,encrypted,/g' temp3.txt

sed '/,,,,,/d' ./temp3.txt > temp1.txt

cut -d, -f1-4,7 temp1.txt > temp2.txt

var=`grep -i "load_" test.txt|cut -d ' ' -f 2`


load=`cat $var | grep -i "error\|failed\|denied"`
load1=`echo "$load"`
load2=`echo $load1 "  "`
rload=`echo ${load2//, /}`

var=`grep -i "table_creator_" test.txt|cut -d ' ' -f 2`
table=`cat $var | grep -i "error\|failed\|denied"`
table1=`echo "$table"`
table2=`echo $table1 "  "`
rtable=`echo ${table2//, /}`


var=`grep -i "encrypt_" test.txt|cut -d ' ' -f 2`
encrypt=`cat $var | grep -i "error\|failed\|denied"`
encrypt1=`echo "$encrypt"`
encrypt2=`echo $encrypt1 "  "`
rencrypt=`echo ${encrypt2//, /}`



sed "/,file LOAD Failure/s/$/${rload}/" temp2.txt > temp1.txt
sed "/,encrypted failed/s/$/${rencrypt}/" temp1.txt > temp3.txt
sed "/,table failed/s/$/${rtable}/" temp3.txt > temp1.txt


print_header=false
echo "<table border="1" style="width:300px">" >>table.html
echo "<tr><th nowrap="nowrap">TABLE NAME</th><th nowrap="nowrap">LOAD STATUS</th><th nowrap="nowrap">NEW TABLE CREATION STATUS</th><th nowrap="nowrap">ENCRYPTION STATUS</th><th nowrap="nowrap">CHECK LOGS IN</th></tr>" >> table.html
while read INPUT ; do
  if $print_header;then
    echo "<tr><th>$INPUT" | sed -e 's/:[^,]*\(,\|$\)/<\/th><th>/g'
    print_header=false
  fi
  echo "<tr><td>${INPUT//,/</td><td>}</td></tr>" >> table.html;
done < temp1.txt ;
echo "</table>" >>table.html


##########################################################################################################################
echo "WARNINGS :" > temp1.txt

sed -n '/WARNINGS :$/ { s///; :a; n; p; ba; }' test.txt >> temp1.txt

sed '1i\\' temp1.txt > temp2.txt
awk '{print $0"<br>"}' temp2.txt > temp1.txt
echo "<table>" >> table.html
cat temp1.txt >> table.html
echo "</table>" >>table.html
sed -i -e 's/td>file LOAD Failure/td bgcolor="#FF0000">file Load Failure/g' table.html
sed -i -e 's/td>encrypted failed/td bgcolor="#FF0000">encrypted failed/g' table.html
sed -i -e 's/td>table failed/td bgcolor="#FF0000">table failed/g' table.html
sed -i -e 's/td>table created/td bgcolor="#008000">table created/g' table.html
sed -i -e 's/td>encrypted/td bgcolor="#008000">encrypted/g' table.html
sed -i -e 's/td>file LOAD Success/td bgcolor="#008000">file Load Success/g' table.html



rm temp1.txt temp2.txt temp3.txt
mv test_bak.txt test.txt
fi
