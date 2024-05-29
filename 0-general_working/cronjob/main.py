#!/usr/bin/python

with open('/home/iman/app/myfile', 'a') as f:
    f.write('hi there\n')  # python will convert \n to os.linesep