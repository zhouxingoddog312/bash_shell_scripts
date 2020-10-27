   * [collect file by suffix](#collect-file-by-suffix)
      * [Synopsis](#synopsis)
      * [Description](#description)
      * [Examples](#examples)

# collect file by suffix

------

## Synopsis


Usage: __cfbs__&emsp;[OPTIONS]&emsp;[DIRECTORY]&emsp;[SUFFIX]&emsp;[TARGET-DIRECTORY]

------


## Description  

&emsp;Collect the file from the directory you specified to the target directory. Or you can use the option -n to just list those files.  
&emsp;Multiple suffix can be accept, them must be separated by comma.  
&emsp;You can use absolute path or relative path as you well.  

- -c&emsp;copy those files to the specified directory
- -n&emsp;don't collect, but just list the files
- -m&emsp;move those files to the specified directory
- -v&emsp;output version information and exit
- -h&emsp;output help information and exit

------

## Examples  

`cfbs -c /home/goddog312 sh /tmp`  
&emsp;This command will create a directory named /tmp/sh.XXX to store the files with suffix sh from the directory /home/goddog312.

## Others
&emsp;The file __prompt.sh__ can be move to the directory /etc/bash_completion.d. It's used to auto complete command by `tab`. 
