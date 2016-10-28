if [ $# -lt 1 ]; then
    echo "Enter a iMessage account (email of phone number i.e +33616.....) "
fi
login=$1
    
sqlite3 ~/Library/Messages/chat.db "
select '[str][' as 'ph1',datetime(date + strftime('%s', '2001-01-01 00:00:00'), 'unixepoch', 'localtime') as date,']' as 'ph2','[' as 'ph2',is_from_me,']' as 'ph2',NULL as 'filename',text from message where handle_id=(
select handle_id from chat_handle_join where chat_id=(
select ROWID from chat where guid='iMessage;-;$1')
)
union all
select '[att][' as 'ph1',datetime(date + strftime('%s', '2001-01-01 00:00:00'), 'unixepoch', 'localtime') as date,']' as 'ph2','[' as 'ph3',is_from_me,']' as 'ph2',NULL as 'text',filename from attachment,message_attachment_join,message where attachment.rowid = message_attachment_join.attachment_id and message_attachment_join.message_id = message.rowid and message.cache_has_attachments=1 and message.handle_id=(
select handle_id from chat_handle_join where chat_id=(
select ROWID from chat where guid='iMessage;-;$1')
) order by date" | sed 's/\|1\|/H/g;s/\|0\|/N/g;s/\|//g' > iMessages$1.txt