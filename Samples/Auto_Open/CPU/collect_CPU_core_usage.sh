#!/bin/bash
#Hyeongwan Seo

PS_RESULT=ps_result.txt
MAX_CORE=`cat /proc/cpuinfo | grep -c processor`

ps -eo psr,pcpu,comm | sort -k 1 > $PS_RESULT 	# 실행 결과를 txt 파일에 저장함.

for ((idx=0; idx < $MAX_CORE; idx++))
do
	cat $PS_RESULT| sort -k 1 | awk '$1=='"${idx}"' {print $1, $2, $3}' > core$idx.txt
	
	total_per_core=`cat core$idx.txt | awk '{SUM += $2} END {print SUM}'`

	: ' 
	<코어 사용률이 100% 이상이 되는 이유>
	하나의 프로세스가 여러 쓰레드로 되어있고, 각 쓰레드가 서로 다른 코어에 스케쥴링 되어
	동시에 실행하는 순간에 코어의 사용률이 100%이상이 된다.
	'

	#echo -e "core$idx total usage: $total_per_core% "
	printf "core %2d: %3.1f %%\n" "$idx" "$total_per_core"
	total_per_core=0	# 초기화

done
