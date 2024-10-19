#!/bin/bash

PASSWORD=$(date +%s)${RANDOM}${RANDOM} | sha1sum
echo $PASSWORD


