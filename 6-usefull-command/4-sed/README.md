# Sed Basic Command
```
sed 's/216.239.38.120/google.com/g' ping-log.log    # replace ip with domain.

sed '/^#/d' config.cfg                              # delete all line begins with # sgin. 

sed '/^#/d' config.cfg | grep '\S'                  # first remove all line begins with (#) and then remove all blank line 


sed '/^#/d' config.cfg | sed '/^$/d'                # the same above command for deleting epmty line in a file

time sed '/^#/d' longFile



```

# select line by pattern

```

sed -n '/Database/p' test   # print line which contains `Database in it`

```


# remove a spacefic line

```
sed '3d' test               # delete line 3
sed -e '5,7d' test          # delete line 5,6,7
sed '$d' test               # delete last line
sed '5,$d' test             # delet from line  5 to the end of file

```

# remove line by word

```
sed '/Online/d' test   # remove lines that contains `Online` word.
sed '/Online/,7d' test  # remove a line that have `Online` word, and remove until 7 line.
sed '2,/Online/d' test

```

# find a replace with sed
```
sed 's/linux/##/g' input1


```