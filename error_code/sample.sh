#!/bin/sh

input=$1
echo $input
if [ $input == "job1" ]
then
    echo "job failed"
    exit 128
elif [ $input == "job4" ]
then
    echo "job failed"
    echo "exit code 3 to 124 are tool error"
    exit 4
else
    echo "Job success"
fi 
