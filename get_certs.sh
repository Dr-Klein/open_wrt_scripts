#! /bin/bash

export LOG_OUT="out.log"; # File name with threads logs
MAIN_LOG="./main.log"; # File name with parents logs
#debug TIMESTAMP=`date`
JOBS_COUNTER=0
MAX_CHILDREN=10
MY_PID=$$
NAME_THREAD="get_ovpn.sh";
export LOG_PID="./other_program.pid";
#debug export MOGWIG_LOG="./mogwig.log"
#debug export PROGRESS_LOG="./Progress_bar.log"
export NUMB_COUNTRYS="35"; #all 36 countrys, max 35, iteration from zero

export COUNTRY_LIST=(Albania #200
Argentina #100
Australia #1000
Austria #200
Belgium #300
Brazil #200
Canada #1500
Chech_Republick #200
Denmark #300
Estonia #150
Finland #200
France #1500
Germany #1500
Greece #150
Hungary #150
Iceland #100
India #350
Indonesia #150
Ireland #350
Israel #100
Italy #350
Japan #1500
Luxemburg #150
New_Zeland #250
Niderlands #1000
Norway #200
Poland #600
Singapur #1000
South_Korea #300
Spain #1000
Sweeden #600
Switzerland #1500
Taiwan #1000
United_Kingdom #3500
USA #10000
Vietnam); #200

export COUNTRY_PREFIX=(al ar au at be br ca cz dk ee fi fr de gr hu is in id ie \
 il it jp lu nz nl no pl sg kr es se ch tw uk vn);
#DELTA_MIN=(1);

export DELTA_MAX=(200 100 1000 200 300 200 1500 200 300 150 200 1500 1500 150 \
150 100 350 150 350 100 350 1500 150 250 1000 200 600 1000 300 1000 600\
1500 1000 3500 10000 200);


for (( i=0; i <= NUMB_COUNTRYS  ; i++ ))
do
mkdir ${COUNTRY_LIST[ $i ]} # make dirs from all choises country
done

function cleaner {

NUMB_PID=$((`cat $LOG_PID  | wc -l`))
local line=${i}
#debug echo "Numb_pid $NUMB_PID"	
	while [ $NUMB_PID -gt $MAX_CHILDREN ]
	do
		for (( i=2; i <= $NUMB_PID ; i++ ))
			do
				#debug echo "iteration $i"
				TEMP_PID=$((`cat $LOG_PID | awk -v line="$i" 'NR == line'`));
				#debug echo "temp pid is $TEMP_PID"
				RUN_THREAD=$((`ps ax -A | grep $TEMP_PID | grep $NAME_THREAD | wc -l`));
				#debug echo "RUN_THREAD is $RUN_THREAD"
				if [ $RUN_THREAD -eq  0 ]
				then
					sed -i /"$TEMP_PID"/d $LOG_PID
					#debug echo "pid $TEMP_PID was cleared"
				fi
			done
		NUMB_PID=$((`cat $LOG_PID  | wc -l`))	
		return 0;
		break
		
		return -1;
	done
}

echo $MY_PID > $LOG_PID
#debug echo "mogwig start $TIMESTAMP " >> "$MOGWIG_LOG" 
./mogwig.sh & #debug >> "$MOGWIG_LOG" 2>&1
./ProgressData.sh & # debug>> "$PROGRESS_LOG" 2>&1

for (( i=0; i <= NUMB_COUNTRYS  ; i++ ))

do
    export SELECTED_COUNTRY=$i
    #debug echo "selected country = ${COUNTRY_LIST[ $i ]} "
    #debug echo Cycle counter: $i
    JOBS_COUNTER=$((`ps ax -Ao ppid | grep $MY_PID | wc -l`))
    cleaner
    while [ $JOBS_COUNTER -ge $MAX_CHILDREN ]
    do
        JOBS_COUNTER=$((`ps ax -Ao ppid | grep $MY_PID | wc -l`))
        #debug echo Jobs counter: $JOBS_COUNTER
        sleep 1
    done
    ./get_ovpn.sh &
    echo $! >> $LOG_PID
done
#debug echo Finishing children ...
#wait for children here
while [ $JOBS_COUNTER -gt 2 ]
do
    JOBS_COUNTER=$((`ps ax -Ao ppid | grep $MY_PID | wc -l`))
    #debug echo Jobs counter: $JOBS_COUNTER
    sleep 1
done
echo Done

exit 0;

echo "Done"

done
