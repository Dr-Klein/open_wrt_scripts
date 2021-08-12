#! /bin/bash

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


let temp_SC="$SELECTED_COUNTRY"

function GetVpn {

echo "Max value iteration ${DELTA_MAX[$temp_SC]}" >> ./${COUNTRY_LIST[$temp_SC]}/$LOG_OUT 2>&1

for (( j=0; j <= ${DELTA_MAX[$temp_SC]} ; j++ ))
	do
	wget -P ./${COUNTRY_LIST[$temp_SC]} https://downloads.nordcdn.com/configs/files/ovpn_tcp/servers/"${COUNTRY_PREFIX[$temp_SC]}"${j}.nordvpn.com.tcp.ovpn >> ./${COUNTRY_LIST[$temp_SC]}/$LOG_OUT 2>&1 
	echo "Get certificate, Iterace number $j" >> ./${COUNTRY_LIST[$temp_SC]}/$LOG_OUT 2>&1
	done
echo "Done..."	>> ./${COUNTRY_LIST[$temp_SC]}/$LOG_OUT 2>&1
ALL_CERT=( $(ls ./${COUNTRY_LIST[$temp_SC]}  | grep .ovpn | wc -l  ) )
#debug echo "Total certificates received: ${ALL_CERT}" 
#debug echo "${COUNTRY_LIST[$temp_SC]} is completed..Done"

}

GetVpn #debug >> ./DebugVpn.log 2>&1
