#!/bin/sh
cat ${1}|grep "Sensor: ${2}\. "|grep -v problem|sed 's/[a-zA-Z]\{1,\}: //g'|sed 's/\. /|/g'|awk -F'|' 'BEGIN{sum=0;count=0;min=max=0;}\
{sum+=$2;count++;\
#if($2==0)\
#print NR;\
#print $0;\
if(NR==1)\
{min=max=$ }\
else{\
if($2<min) {min=$2;}\
if($2>max) max=$2;}}\
END{printf("Average: %f, Min: %d, Max %d\n", sum/count,min,max);}'
