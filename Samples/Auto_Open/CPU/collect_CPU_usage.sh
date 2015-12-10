#!/bin/bash
#Hyeongwan Seo

CPU_STATISTICS=cpu_statistics.csv
MPSTAT_RESULT=mpstat_result.txt
CPU_CORE_NUM=`cat /proc/cpuinfo | grep -c processor`
MAX_ITER=`expr $CPU_CORE_NUM - 1`

#시스템에 mpstat가 설치되었는지 확인함.
function mpstat_check()
{
    if [ -e "/usr/bin/mpstat" ]; then
        echo -e "mpstat 설치 확인:             [  \e[1;32mOK\e[0m  ]"
    else
        echo -e "mpstat 설치 확인:       	      [  \e[1;31mFAIL\e[0m  ]"
        echo "\e[1;31mmpstat를 설치해야 데이터 수집이 가능합니다.\e[0m"
		echo "\e[1;31m(apt-get install sysstat OR yum install sysstat)\e[0m"
        exit
    fi  
}


function get_data()
{
	#날짜 및 시간 정보를 수집함
	WEEK=`date +%W`
    YEAR=`date +%Y`
    MONTH=`date +%m`
    DAY=`date +%d`
    HOUR=`date +%H`
    MINUTE=`date +%M`
    SECOND=`date +%S`

	#CPU 정보를 수집함
	mpstat -P ALL > $MPSTAT_RESULT

	for ((idx=1; idx <= $CPU_CORE_NUM; idx++))
	do
		core_usage[$idx]=`cat $MPSTAT_RESULT | sed -e '1,4d' | awk '{print $4+$5+$6}' | head -n $idx | tail -n 1`	
	done

	for ((i=0; i < core_num; i++))
	do
		echo ${core_usage[$idx]},
	done
	
	


	rm -rf $SAR_RESULT
}

function print_data()
{
    for ((;;))
    do
        get_data
        echo "$DAY-$MONTH-$YEAR $HOUR:$MINUTE:$SECOND +0009,$USER,$NICE,$SYSTEM,$IOWAIT,$STEAL,$IDLE" >> $CPU_STATISTICS
		sleep 2s
    done
}

function init_document()
{
    if [ -e $CPU_STATISTICS ]; then
        :       #NOP (csv 파일이 존재하면 init_document 함수를 실행하지 않음)
    else
        #echo "Timestamp,User,Nice,System,Iowait,Steal,Idle" > $CPU_STATISTICS
		
		for ((idx=0; idx < 16; idx++))
		do
    
    		if [ $idx -eq 15 ]; then
        		printf "core$idx" >> $CPU_STATISTICS
    		else
        		printf "core$idx," >> $CPU_STATISTICS
    		fi  

		done
   
	 echo "" >> $CPU_STATISTICS

    fi
}

# 1개의 프로세스만 CPU 사용량을 수집하도록 함.
function process_check()
{
    PID_TXT=$CPU_STATISTICS-pid.txt
    pgrep collect_CPU_data.sh  > $PID_TXT
    PID_COUNT=`cat $PID_TXT | wc -l`
    
    if [ $PID_COUNT -ge 2 ]; then
        echo "이미 프로세스가 실행 중입니다. 데이터 수집은 1개의 프로세스만 실행해야 합니다."
            rm -rf $PID_TXT
        exit
	else
		rm -rf $PID_TXT
    fi
}

#mpstat_check
#process_check
init_document 

if [ "$1" == "stop" ];then
    pkill collect_CPU_usage.sh   # 데이터 수집을 중지함
else
    #print_data
	:
fi
