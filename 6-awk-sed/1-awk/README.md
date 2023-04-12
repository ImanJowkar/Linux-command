# awk command
`awk` is a powerful text processing tool that is available in most Linux distributions. It is a command-line utility that can be used to search and manipulate text data in files or streams.

The name "awk" is derived from the initials of its authors – Aho, Weinberger, and Kernighan.

`awk` operates on one line of input at a time, and applies patterns and actions to process the input. Patterns are used to select the lines that match a certain criteria, while actions are used to perform specific operations on the selected lines.

Here are some examples of how `awk` can be used:

1. Searching for text: You can use `awk` to search for specific text in a file. For example, to search for lines that contain the word "error" in a log file, you can use the following 
```
awk '/error/' logfile.txt
```
This will print all the lines that contain the word "error".

2. Extracting columns: You can use `awk` to extract specific columns from a file. For example, to extract the first and third columns from a comma-separated file, you can use the following command:
```
awk -F, '{print $1, $3}' data.csv
```
This will print the first and third columns of each line in the file.

3. Performing calculations: You can use `awk` to perform calculations on data in a file. For example, to calculate the average of a column in a file, you can use the following command:
```
awk '{sum += $1} END {print sum/NR}' data.txt
```
This will calculate the average of the first column in the file.

`awk` has many more features and options that make it a versatile tool for text processing. With a little practice, you can use `awk` to process and manipulate text data in a variety of ways.


## Lets begin
```
awk '{print $0 }' file-name
awk 'BEGIN{printf "hello world\n\n"} {print $2}' file-name
awk 'BEGIN{printf "hello world\n\n"} {print $2} END{printf "This is end"}' file-name


# command from a file
awk -f com date-temp

awk -v env_var=$HOME -f com date-temp




```

`awk` read line by line and execute commands on each line

