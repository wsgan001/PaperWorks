#!/bin/awk -f
BEGIN{THRESHOLD=20;WINDOW_SIZE=1;sum=0;count=0;}
{if($1==THRESHOLD && $2==WINDOW_SIZE) {
	count++;
	sum = sum+$4+1;
 }
 else {
	printf("%d\t%d\t%f\n",THRESHOLD, WINDOW_SIZE, 1/(sum/count));
	THRESHOLD 1; WINDOW_SIZE=$2;
	sum=$4+1;count=1;
 }
}
END {
}
	
