#!/bin/awk -f
BEGIN{THRESHOLD=20;WINDOW_SIZE=1;sum=0;count=0;}
{if($2==THRESHOLD && $3==WINDOW_SIZE) {
	if ($5!=65535) {
		count++;
		sum+=$5;
	}
 }
 else {
	printf("%d\t%d\t%f\n",THRESHOLD, WINDOW_SIZE, sum/count);
	THRES LD=$2; WINDOW_SIZE=$3;
	sum=$5;count=1;
 }
}
END {
#printf("%d\t%d\t%f\n",THRESHOLD, WINDOW_SIZE, sum/count);
#sum=0;count=0;
}
	
