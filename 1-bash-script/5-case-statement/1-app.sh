#!/bin/bash

read -p "Enter your favorite pet: " PET

case "$PET" in 
	cat|Cat|CAT)
		echo "Your favorite pet is the cat"
		;;
	dog|Dog|DOG)
		echo "Your like Dogs."
		;;
	fish|"African Turtle")
		echo "fish or turtles are great"
		;;
	*)
		echo "Your favorite pet is unknown"
esac
