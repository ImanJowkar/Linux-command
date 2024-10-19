#!/bin/bash

PS3="Choose fruits: "
select fruit in Apple Benana x y "this is " Quit
do
	echo "fruit is $fruit"
	echo "Reply is $REPLY"

	case $REPLY in
		1)
			echo "You love Apple"
			;;
		2)
			echo "You love Benana"
			;;
		3)
			echo "you love x"
			;;
		4)
			echo "you love y"
			;;
		5)
			echo "you love sdf"
			;;
		6)
			echo "Quitting"
			sleep 1
			break
			;;
		*)
			echo "bad input!!!"
			;;
	esac
done 
