  * [simple alias](#simple-alias)
      * [Synopsis](#synopsis)
      * [Description](#description)
      * [Examples](#examples)
      * [Other](#other)

# simple alias  

------

## Synopsis  

__Usage__:&emsp;spal&emsp;[OPTION]&emsp;[NAME]&emsp;[COMMAND]  

------

## Description  

Organize your alias easily.  

__Options:__  
- -e&emsp;[NAME]&emsp;Execute command associate with customized name. This is default option, when the option haven't given  
- -a&emsp;[NAME]&emsp;[COMMAND]&emsp;Add alias command with customized name  
- -c&emsp;clear all aliases  
- -r&emsp;[NAME]&emsp;remove alias by name  
- -l&emsp;list all aliases  
- -v&emsp;output version information  
- -h&emsp;output help information  

--------

## Examples  

`spal -a ll "ls -lh"` ,then enter `spal ll` to use `ls -lh`.  

## Other  

`source _autocomplete.sh` or add this to your ~/.bashrc, to use command auto complete.