#!/bin/bash
#Hyeongwan Seo

PS_RESULT=ps_result.txt
MAX_CORE=`cat /proc/cpuinfo | grep -c processor`

ps -eo psr,pcpu,comm | sort -k 1 > $PS_RESULT 	# 실행 결과를 txt 파일에 저장함.

for ((idx=0; idx < MAX_CORE; idx++))
do
	cat $PS_RESULT | sort -k 1 | awk '$1==5 {print $2}'
done
