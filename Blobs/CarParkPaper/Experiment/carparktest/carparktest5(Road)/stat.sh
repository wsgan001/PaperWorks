#!/bin/sh
cat ${1}|grep "Sensor: ${2}\."|grep -v problem|sed 's/[a-zA-Z]\{1,\}: //g'|sed 's/\. /|/g'|awk -F'|' 'BEGIN{sum=0;count=0;minseq=maxseq=0;realminseq=realmaxseq=0;}\
{sum+=$2;count++;\
if($2<expectmin) {minseq++;if(minseq ealminseq)\
	{realminseq=minseq;printf("seq at row: %d\n",NR);}}\
else minseq=0;\
if($2>expectmax) {maxseq++;if(maxseq>realmaxseq)\
	{realmaxseq=maxseq;printf("seq at row: %d\n",NR);}}\
else maxseq=0;}\
END{printf("Average: %f, Minseq: %d, Maxseq: %d\n", sum/count,realminseq,realmaxseq);}'expectmin=${3} expectmax=${4}
