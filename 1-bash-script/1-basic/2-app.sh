#!/bin/bash
filename="/etc/passwd"

echo "Number of line in The $filename file"
wc -l $filename



echo "########################"
echo "First 10 line in $filename"
head -n 10 $filename




echo "########################"
echo "Last 7 Lines: "
tail -n 7 $filename
