""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"                                 My Macros                                  "
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

"To record a macro, q<letter> (will say recording) type commands, then <ESC>
"for command mode, then q to stop recording. Typing @<letter> will invoke the
"series of commands.
"Check the file .viminfo to yank commands

"example:
"let @t='!!date "+\#@\%m/\%d/\%Y \%r"A - A'
"                                   |     |
"                                   ------|--is "Enter"
"                                         ------is "ESC"
"    €
"    |
"    ----- is "Backspace"
"      
"      |
"      ------is "Ctl"
"      CTL-o = Go to previous line position
"
"
"make comment (#) header
let @h='80a#Ypko##A '
"make comment (/*<comments>*/) header
let @p='i/80a*oo80a*a/kA** '

"One line date time stamp (replace existing line)
let @t='!!date "+\#@\%m/\%d/\%Y \%r"A - A'
"Date time stamp comment at end of file
let @l='Go25i#Ypko!!date "+\#@\%m/\%d/\%Y \%r"GoA'
"Indent
let @i=':s/^/   /:nohl'
"Del Indent
let @d=':s/^   //:nohl'
"Comment
let @c=':s/^/#/:nohl'
"Del Comment
let @u=':s/^#//:nohl'

"Calculator
let @m='!!var=$(cat - | sed "s/^/\"/;s/$/\"/"); echo "${var} = $(echo "${var}" | sed "s/\"//g" | bc -l)" | sed "s/\"//g"'
