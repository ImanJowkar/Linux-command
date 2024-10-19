#!/bin/bash

for file in *.txt
do
	mv "$file" "rename_by_script_$file"
done

