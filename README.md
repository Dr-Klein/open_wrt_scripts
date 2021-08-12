Bash Script, which allows you to download part of the Nordvpn service certificates. 
The number of countries must be specified in the code of the script itself, the maximum is set to the default from the proposed list. 

Instruction:

1. Cloning repository:

	```git clone https://github.com/Dr-Klein/open_wrt_scripts/get_certs```
	
2. Set the user-friendly parameters in the get_certs.sh file. For example:
	
	MAX_CHILDREN - Sets the maximum number of streams, by default 10.
	NUMB_COUNTRYS - Sets the number of countries for which certificates. 
	will be downloaded, the default parameter is 35, which corresponds to all 36 countries.

3. Change the rights and run:	

	chmod +x *.sh 
	./get_certs

Notice:

To interrupt work, use Ctrl+D
