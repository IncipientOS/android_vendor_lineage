#!/bin/bash

Changelog=Changelog.txt

DEVICE=$(echo $TARGET_PRODUCT | cut -d "_" -f2)

if [ -f $Changelog ];
then
	rm -f $Changelog
fi

touch $Changelog

# Print something to build output
echo ${bldppl}"Generating changelog..."${txtrst}

for i in $(seq 15);
do
export After_Date=`/bin/date --date="$i days ago" +%m-%d-%Y`
k=$(expr $i - 1)
	export Until_Date=`/bin/date --date="$k days ago" +%m-%d-%Y`

	# Line with after --- until was too long for a small ListView
	echo '====================' >> $Changelog;
	echo  "     "$Until_Date       >> $Changelog;
	echo '===================='	>> $Changelog;

while read path;
do
    Git_log=`git --git-dir ./${path}/.git log --after=$After_Date --until=$Until_Date --pretty=tformat:"%h  %s  [%an]" --abbrev-commit --abbrev=7`
    if [ ! -z "${Git_log}" ]; then
        echo "\n* ${path}\n${Git_log}\n" >> $Changelog;
    fi
done < ./.repo/project.list;

done
sed -i 's/project/   */g' $Changelog

cp $Changelog ./out/target/product/$DEVICE/system/etc/
mv $Changelog ./out/target/product/$DEVICE/
