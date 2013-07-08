#!/bin/sh
#Usage: data.sh <filename> <id> 
cat ${1}|grep "^${2}|"|sort -n -t'|' +3 -4|awk -F'|' '
BEGIN{switchCount=SWITCH_NUMBER;lastSwitched=0;seq=-1;switchAver=0;lastReading=0;switchDirection=0;eventCount=0;}
{
 if ($4==seq+1) {
	seq=$4;
 currentAver=$2;
 if (currentAver>lastReading && currentAver-lastReading>SWITCH_THRESHOLD) { # Significant increase
	if (switchDirection==1 && lastSwitched!=1) {
		switchCount--;
		switchAver+=currentAver;
		if (switchCount==0) { # Enough significant increase to report a change
			reportData=TRUE;
			lastReading=gSensorData=switchAver/SWITCH_NUMBER;
			switchCount=SWITCH_NUMBER;
			switchDirection = 0;
			lastSwitched=1;
			printf("%d\t%d\t%d:%d:%d\n",$1,$2,$6/3600,$6%3600/60,$6%60);
			eventCount++;
			#print $0;
		}
	} else {
		switchCount=SWITCH_NUMBER-1;
		switchAver=currentAver;
		switchDirection = 1;
		if (switchCount==0) { # Enough significant increase to report a change
			reportData=TRUE;
			lastReading=gSensorData=switchAver/SWITCH_NUMBER;
			switchCount=SWITCH_NUMBER;
			switchDirection = 0;
			lastSwitched=1;
			printf("%d\t%d\t%d:%d:%d\n",$1,$2,$6/3600,$6%3600/60,$6%60);
			eventCount++;
			#print $0;
		}
	}
 } else if (currentAver<lastReading && lastReading-currentAver>SWITCH_THRESHOLD) { # Significant decrease
	if (switchDirection==2 && lastSwitched!=2) {
		switchCount--;
		switchAver+=currentAver;
		if (switchCount==0) { # Enough significant decrease to report a change
			reportData=TRUE;
			lastReading=gSensorData=switchAver/SWITCH_NUMBER;
			switchCount=SWITCH_NUMBER;
			switchDirection = 0;
			lastSwitched=2;
			printf("%d\t%d\t%d:%d:%d\n",$1,$2,$6/3600,$6%3600/60,$6%60);
			eventCount++;
			#print $0;
		}
	} else {
		switchCount=SWITCH_NUMBER-1;
		switchAver=currentAver;
		switchDirection = 2;
		if (switchCount==0) { # Enough significant decrease to report a change
			reportData=TRUE;
			lastReading=gSensorData=switchAver/SWITCH_NUMBER;
			switchCount=SWITCH_NUMBER;
			switchDirection = 0;
			lastSwitched=2;
			printf("%d\t%d\t%d:%d:%d\n",$1,$2,$6/3600,$6%3600/60,$6%60);
			eventCount++;
			#print $0;
		}
	}
 } else { # No significant change
	switchDirection = 0;
	switchCount = SWITCH_NUMBER;
 }
 }
 else if ($4>seq+1) {
	printf("Seq no: %d is missing?\n",seq+1);
	seq=$4;
 }

}
END{
 if (eventCount-1==0)
	printf("Event not detected for sensor: %d!\n", $1);
 else {
	printf("EVENT:\t%d\t%d\t%d\t%d\n", SWITCH_THRESHOLD, SWITCH_NUMBER, $1, eventCount-4);
	#printf("EVENT:\t%d\t%d\t%d\t%d\n", SWITCH_THRESHOLD, SWITCH_NUMBER, $1, eventCount-4);
	printf("Events detected for sensor %d as %d, false rate %f\n", $1, eventCount-1, (eventCount-2)/(eventCount-1));
}}' SWITCH_NUMBER=${3} SWITCH_THRESHOLD=${4} REAL_EVENT=${5} EVENT_TYPE=${6}