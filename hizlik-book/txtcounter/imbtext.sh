# Bash Script By Matthieu Riegler - http://matthieu.riegler.fr
# Licence CC-BY 0 
#
# This script takes in input a iMessage account input and backs its conversations up as txt files. 
# It also saves its pictures that are cached localy 

#Parameter is a iMessage account (email or phone number i.e. +33616.... )
if [ $# -lt 1 ]; then
    echo "Enter a iMessage account (email of phone number i.e +33616.....) "
fi
login=$1

#Retrieve the text messages 
    
sqlite3 ~/Library/Messages/chat.db "
select '[' as 'ph1',datetime(date + strftime('%s', '2001-01-01 00:00:00'), 'unixepoch', 'localtime') as date,']' as 'ph2','[' as 'ph3',is_from_me,']' as 'ph4',text from message where handle_id=(
select handle_id from chat_handle_join where chat_id=(
select ROWID from chat where guid='iMessage;-;$1')
)" | sed 's/\|1\|/H/g;s/\|0\|/N/g;s/\|//g' > iMessages$1.txt