# tr command (tr == translate)

```
cat test | tr 'i' 'I'    # convert `i` to `I`
cat test | tr 'ip' 'IP'
cat test | tr 'x' 'y'   # convert x to y
tr 'x' 't' < test
tr '[a-z]' '[A-Z]' < test   # convert to upper case
tr ' ' '\n' < test    # replace space with \n
tr '{}' '()' < test

cat /etc/passwd | tr ':' '*'
cat test | tr [:lower:] [:upper:]   # this not work on zsh

tr -d 't' < test
cat test | tr 't' 'T' | tr -d 'T'
cat test | tr [:space:] '\n'

cat test | tr -d [:digit:] # remove all digits in a file

cat test | tr -d [:space:] # remove all spaces
cat test | tr -d [:blank:] # remove all blank

cat domain | tr -s ' '

cat domain | tr -s ' ' | tr -d ' '

cat test  | tr -s ' '   # delete multiple space and replace with one space

cat domain | tr -d ' ' | sed '/^$/d'  

```


