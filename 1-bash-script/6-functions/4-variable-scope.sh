#!/bin/bash


var1="AA"
var2="BB"


echo "Before calling func1: var1=$var1, var2=$var2"

func1() {
	var1="XX"
	echo "Inside func1: var1=$var1, var2=$var2"
}

func1

echo "After calling func1: var1=$var1, var2=$var2"


echo "######################################################"

var1="AA"
var2="BB"


echo "Before calling func2: var1=$var1, var2=$var2"

func2() {
        local var1="XX"
        echo "Inside func2: var1=$var1, var2=$var2"
}

func2

echo "After calling func2: var1=$var1, var2=$var2"
