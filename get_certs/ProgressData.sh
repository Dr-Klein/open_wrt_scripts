#!/bin/bash

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

function ProgressBar {
 #Process data
    let _progress=(${1}*100/${2}*100)/100
    let _done=(${_progress}*4)/10
    let _left=40-$_done
 #Build progressbar string lengths
    _fill=$(printf "%${_done}s")
    _empty=$(printf "%${_left}s")

# 1.2 Build progressbar strings and print the ProgressBar line
# 1.2.1 Output example:                           
# 1.2.1.1 Progress : [########################################] 100%
printf "\rProgress : [${_fill// /#}${_empty// /-}] ${_progress}%%"
}

function GetProgressData {
_end=100
Progress=0;

while [[ $Progress -lt $_end ]]
	
	do
		for (( i=0; i <= ${NUMB_COUNTRYS} ; i++ ))
			do
			Max_value=$(cat ./"${COUNTRY_LIST[$i]}"/"$LOG_OUT" | grep Max | grep -o '[[:digit:]]*');
			#debug echo "Max value is $Max_value"
			Now_value=$(cat ./"${COUNTRY_LIST[$i]}"/"$LOG_OUT" | grep number | grep -o '[[:digit:]]*' | wc -l);
			#debug echo "Now value is $Now_value"
			
			let Sum_Max+=Max_value
			let Sum_Now+=Now_value

			#debug echo "Sum_max value is $Sum_Max"
			#debug echo "Sum_Now value is $Sum_Now"
		done
	
		Ratio_0=$(echo "scale=3; $Sum_Now/$Sum_Max" | bc )
		Ratio=$(echo "scale=0; $Ratio_0*$_end" | bc | column -tH2 -s. )
		let Progress=Ratio #

		#debug echo "Progress  is $Ratio"
		
		#clean
		Sum_Ratio=0;
		Ratio=0;
		Sum_Max=0;
		Sum_Now=0;
	
		for number in $(seq ${Progress} ${_end})
			do
			sleep 0.1
			ProgressBar ${Progress} ${_end}
		done
	done
	printf '\nFinished!\n'
}

sleep 5
GetProgressData 2> /dev/null # Temporary solution

exit 0;
