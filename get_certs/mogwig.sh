#!/bin/bash

NUMB_PID=$((`cat $LOG_PID  | wc -l`))
MAIN_PID=$((`cat $LOG_PID | awk  'NR == 1'`));
NAME_THREAD="get_ovpn.sh";

function mogwig {
local line=${i}


	while [ $NUMB_PID -gt 0 ]
	do
		NAME_MAIN=$(ps ax -A | grep $MAIN_PID| head -n 1 | awk '{print $5}');
		RUN_MAIN=$((`ps ax -A | grep $MAIN_PID | grep $NAME_MAIN | wc -l`));
		if [ $RUN_MAIN -ne  0 ]
		then
			NUMB_PID=$((`cat $LOG_PID  | wc -l`))
			continue;
		fi	
		
		
		for (( i=2; i <= $NUMB_PID ; i++ ))
			do
				#debug echo "iteration $i"
				TEMP_PID=$((`cat $LOG_PID | awk -v line="$i" 'NR == line'`));
				NAME_TO_PID=$((`ps ax -A | grep $TEMP_PID | grep $NAME_THREAD | wc -l`));
				
				if [ $NAME_TO_PID -ne 0 ]
				then
				
					kill -9 $TEMP_PID
					#debug echo "pid $TEMP_PID was killed"
				fi
			done
		return_val_check=$(checker)
	
	if [[ $return_val_check -eq 0 ]]
	then
		break;
	else
		continue;
	fi	
	done
	
	return 0;
}

function checker {
	
local line=${i}
	for (( i=1; i <= $NUMB_PID ; i++ ))
		do
			TEMP_PID=$((`cat $LOG_PID | awk -v line="$i" 'NR == line'`));
			RUN_THREAD=$((`ps ax -A | grep $TEMP_PID | grep $NAME_THREAD | wc -l`));
			if [ $RUN_THREAD -eq  0 ]
			then
					#debug echo "checker -> continue"
				continue
			else
				#debug echo "checker -> return -1"
				return -1;
			fi
		done
		#debug echo "checker return -> return 0"
	return 0;
}


mogwig #debug >> "$MOGWIG_LOG" 2>&1
echo #debug "full completed..Done" >> "$MOGWIG_LOG" 2>&1

exit 0;
