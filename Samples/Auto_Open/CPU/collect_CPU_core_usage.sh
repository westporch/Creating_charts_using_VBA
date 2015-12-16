#!/bin/bash
#Hyeongwan Seo

PS_RESULT=ps_result.txt
MAX_CORE=`cat /proc/cpuinfo | grep -c processor`

#출력 결과의 header 설정
function set_header()
{
	awk '
	BEGIN {
		printf("\n%2s %5s(%%) %10s \n", "Core", "Percent", "\tBar chart") 
		printf("=====================================================================================\n")
	}'
}

ps -eo psr,pcpu,comm | sort -k 1 > $PS_RESULT 	# 실행 결과를 txt 파일에 저장함.
set_header

for ((idx=0; idx < $MAX_CORE; idx++))
do
	cat $PS_RESULT| sort -k 1 | awk '$1=='"${idx}"' {print $1, $2, $3}' > core$idx.txt
	
	total_per_core=`cat core$idx.txt | awk '{SUM += $2} END {print SUM}'`

	: ' 
	<코어 사용률이 100% 이상이 되는 이유>
	하나의 프로세스가 여러 쓰레드로 되어있고, 각 쓰레드가 서로 다른 코어에 스케쥴링 되어
	동시에 실행하는 순간에 코어의 사용률이 100%이상이 된다.
	'
	#AWK로 출력 포맷을 설정함
	awk '
	BEGIN {
    	printf("%2d %5.1f%%", "'"$idx"'", "'"$total_per_core"'")  # core 번호 및 core 사용률을 출력함

    	printf("         ")
    
		# bar 차트를 출력함
    	for(i=0; i < int("'"$total_per_core"'"/10); i++)
    	{   
        	printf("■") 	# 10% -> ■ 1개
    	}; 
    	printf("\n") 

		#if ($2 > 0) { printf("%s (%d%%)\n", $3, $2) } 
		#get_ps_name
	}'  
done
