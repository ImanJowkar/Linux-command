#!/bin/bash

NAME[0]="Iman"
NAME[1]="Jafar"
NAME[2]="Gheysar"

echo ${NAME[1]}


for n in ${NAME[@]}
do 
echo $n
done