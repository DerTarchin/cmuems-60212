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

#Retrieve the attached stored in the local cache

sqlite3 ~/Library/Messages/chat.db "
select '[' as 'ph1',datetime(date + strftime('%s', '2001-01-01 00:00:00'),'unixepoch', 'localtime') as date,']' as 'ph2',filename from attachment,message_attachment_join,message where attachment.rowid = message_attachment_join.attachment_id and message_attachment_join.message_id = message.rowid and message.cache_has_attachments=1 and message.handle_id=(
select handle_id from chat_handle_join where chat_id=(
select ROWID from chat where guid='iMessage;-;$1')
)" | sed 's/\|//g' > iMessage_attachments$1.txt

#cut -c 2- | awk -v home=$HOME '{print home $0}' | tr '\n' '\0' | xargs -0 -t -I fname cp fname .