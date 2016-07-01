/*

 'codesend' hacked from 'send' by @justy
 
 - The provided rc_switch 'send' command uses the form systemCode, unitCode, command
   which is not suitable for our purposes.  Instead, we call 
   send(code, length); // where length is always 24 and code is simply the code
   we find using the RF_sniffer.ino Arduino sketch.

 Usage: ./codesend decimalcode
 (Use RF_Sniffer.ino to check that RF signals are being produced by the RPi's transmitter)
 */

#include "RCSwitch.h"
#include <stdlib.h>
#include <stdio.h>
#include <time.h>     

int main(int argc, char *argv[]) {
    
    // This pin is not the first pin on the RPi GPIO header!
    // Consult https://projects.drogon.net/raspberry-pi/wiringpi/pins/
    // for more information.
    int PIN = 7;
    time_t rawtime;
    struct tm * timeinfo;
    // Parse the firt parameter to this command as an integer
    int code = atoi(argv[1]);
    
    if (wiringPiSetup () == -1) return 1;
	printf("sending code[%i]\n", code);
	RCSwitch mySwitch = RCSwitch();
	mySwitch.enableTransmit(PIN);
    
    mySwitch.send(code, 24);
    DIR* dir = opendir("log");
    if (dir)
    {
    	/* Directory exists. */
	FILE *fp = fopen("./log/historyCodeSend.txt", "a+");
    	if (fp) {
        	time ( &rawtime );
        	timeinfo = localtime ( &rawtime );
        	fprintf(fp, "%s currentMode : %d \n",asctime(timeinfo),code);
        	fclose(fp);
	}
    	closedir(dir);
    }
    else if (ENOENT == errno)
    {
    	/* Directory does not exist. */
        FILE *fp = fopen("historyCodeSend.txt", "a+");
        if (fp) {
                time ( &rawtime );
                timeinfo = localtime ( &rawtime );
                fprintf(fp, "%s currentMode : %d \n",asctime(timeinfo),code);
                fclose(fp);
        }
    }
    else
    {
    	/* opendir() failed for some other reason. */
    }
	return 0;

}
