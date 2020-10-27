 * [move_to_parrent_directory](#move_to_parrent_directory)
      * [Synopsis](#synopsis)
      * [Description](#description)
      * [Examples](#examples)


# move_to_parrent_directory
------

## Synopsis
mtpd&emsp;[OPTION]&emsp;[DIRECTORY]

------

## Description

Go back to the parrent directory in bash.

- -l&emsp;select the longest path match the pattern of directory.
- -s&emsp;select the shortest path match the pattern of directory.
- -v&emsp; output version information and exit. 


------

## Examples

If your path is __/home/goddog312/whatever/good/usr__,then type `mtpd -l go` ,you will go to __/home/goddog312/whatever/good/__. In fact the option `-l` is default.
If you type mtpd `-s` go, you will go to __/home/goddog312/__.
