#!/bin/bash
#Hyeongwan Seo

PS_RESULT=ps_result.txt
MAX_CORE=`cat /proc/cpuinfo | grep -c processor`

ps -eo psr,pcpu,comm | sort -k 1 > $PS_RESULT 	# 실행 결과를 txt 파일에 저장함.

for ((idx=0; idx < $MAX_CORE; idx++))
do
	cat $PS_RESULT| sort -k 1 | awk '$1=='"${idx}"' {print $2}' > core$idx.txt
	readarray -t core$idx < core$idx.txt
	
	total_per_core=`cat core$idx.txt | awk '{SUM += $1} END {print SUM}'`
	echo -e "core$idx total usage: $total_per_core%"
	total_per_core=0

done

#for ((i=0; i < ${#core1[@]}; i++))
#do
#	echo "${core1[$i]}"
#done

