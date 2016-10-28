# -*- coding: utf-8 -*-
import glob
import os
import re
import string

from datetime import datetime,timedelta

filenames = []
texts = []
data = {}

metadata = {
	'total_N_str': 0,
	'total_N_att': 0,
	'total_N_str_len': 0,
	'max_N_len': 0,
	'total_H_str': 0,
	'total_H_att': 0,
	'total_H_str_len': 0,
	'max_H_len': 0
}

def getLogs():
	cwd = os.getcwd()
	os.system("cd '" + cwd + """'
./imbfull.sh +19084212107
./imbfull.sh nicole.hladick@gmail.com""")

def getFileNames():
	for filename in glob.glob('*.txt'):
		if "iMessage" in filename: filenames.append(filename)

def displayFileList():
	print len(filenames),"files found:"
	print '\n'.join(filenames)

def openFile(s):
	print "Openning file...",
	with open(s, 'r') as f: 
		readList = f.readlines()
	print "			File successfully open."
	return readList

def parseText(text):
	# search for [type][YYYY-MM-DD HH:MM:SS][FROM]
	pattern = re.compile('^\[[a-z]{3}\]\[\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2}\]\[[A-Z]\]')

	meta = re.search(pattern, text).group()
	t_type = meta[1:4]
	t_from = meta[-2:-1]
	t_date = datetime.strptime(meta[6:25], '%Y-%m-%d %H:%M:%S')
	t_str = text.replace(meta,"").rstrip()

	return t_type, t_from, t_date, t_str

def listTexts(file, filename):
	print "Listing messages...",

	# search for [type][YYYY-MM-DD HH:MM:SS][FROM]
	pattern = re.compile('^\[[a-z]{3}\]\[\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2}\]\[[A-Z]\]')

	for line in file:
		line = line.rstrip()
		if re.match(pattern, line):
			texts.append(line)
		else:
			texts[-1] += line

	print "		Messages successfully listed."

def runMessageExtractor(s):
	print "\nExtracting text IDs on %s:"%(s)
	listTexts(openFile(s), s)
	# H_att,N_att,H_txt,N_txt = countTexts(readList,s)
	# texts.append((H_att,N_att,H_txt,N_txt))

def analyze():
	global total_N_str, total_N_att, total_H_str, total_H_att

	print "Analyzing messages...",
	#initialize time range
	start_date = datetime.strptime("2014-05-02", '%Y-%m-%d')
	while start_date < datetime.strptime("2015-05-03", '%Y-%m-%d'): 
		data[start_date.strftime('%Y-%m-%d %H')] = { 
			'H': { 'txt_count':0, 'len':0, 'att_count':0 },
			'N': { 'txt_count':0, 'len':0, 'att_count':0 }
		}
		start_date += timedelta(hours=1)
	#populate data
	for text in texts:
		t_type, t_from, t_date, t_str = parseText(text)
		if t_type == "str":
			if t_from == "H":
				metadata['total_H_str'] += 1
				metadata['total_H_str_len'] += len(t_str)
				metadata['max_H_len'] = max(metadata['max_H_len'],len(t_str))
			else:
				metadata['total_N_str'] += 1
				metadata['total_N_str_len'] += len(t_str)
				metadata['max_N_len'] = max(metadata['max_N_len'],len(t_str))
		else:
			if t_from == "H":
				metadata['total_H_att'] += 1
			else:
				metadata['total_N_att'] += 1
		if t_date.strftime('%Y-%m-%d %H') in data:
			data[t_date.strftime('%Y-%m-%d %H')][t_from]['txt_count'] += 1
			if t_type == "att":
				data[t_date.strftime('%Y-%m-%d %H')][t_from]['att_count'] += 1
			else:
				data[t_date.strftime('%Y-%m-%d %H')][t_from]['len'] += len(t_str)
	print "		Analysis complete."
def writeData():
	print "Writing data...",
	with open("h_data.txt", 'w') as f:
		start_date = datetime.strptime("2014-05-02", '%Y-%m-%d')
		prev_day = -1
		while start_date < datetime.strptime("2015-05-03", '%Y-%m-%d'): 
			if prev_day != start_date.day:
				if prev_day >= 0:
					f.write("\n")
				f.write(start_date.strftime("%B %d").lstrip("0").replace(" 0", " "))
				prev_day = start_date.day
			txt_count = data[start_date.strftime('%Y-%m-%d %H')]['H']['txt_count']
			t_len = data[start_date.strftime('%Y-%m-%d %H')]['H']['len']
			att_count = data[start_date.strftime('%Y-%m-%d %H')]['H']['att_count']
			f.write("-%d&%d&%d"%(txt_count, t_len, att_count))
			start_date += timedelta(hours=1)
		f.close()
	with open("n_data.txt", 'w') as f:
		start_date = datetime.strptime("2014-05-02", '%Y-%m-%d')
		prev_day = -1
		while start_date < datetime.strptime("2015-05-03", '%Y-%m-%d'): 
			if prev_day != start_date.day:
				if prev_day >= 0:
					f.write("\n")
				f.write(start_date.strftime("%B %d").lstrip("0").replace(" 0", " "))
				prev_day = start_date.day
			txt_count = data[start_date.strftime('%Y-%m-%d %H')]['N']['txt_count']
			t_len = data[start_date.strftime('%Y-%m-%d %H')]['N']['len']
			att_count = data[start_date.strftime('%Y-%m-%d %H')]['N']['att_count']
			f.write("-%d&%d&%d"%(txt_count, t_len, att_count))
			start_date += timedelta(hours=1)
		f.close()
	print "			Write complete."

def writeDataTogether():
	print "Writing data...",
	with open("data.txt", 'w') as f:
		start_date = datetime.strptime("2014-05-02", '%Y-%m-%d')
		prev_day = -1
		while start_date < datetime.strptime("2015-05-03", '%Y-%m-%d'): 
			if prev_day != start_date.day:
				if prev_day >= 0:
					f.write("\n")
				f.write(start_date.strftime("%B %d, %Y").lstrip("0").replace(" 0", " "))
				prev_day = start_date.day
			txt_count = data[start_date.strftime('%Y-%m-%d %H')]['H']['txt_count'] + data[start_date.strftime('%Y-%m-%d %H')]['N']['txt_count']
			t_len = data[start_date.strftime('%Y-%m-%d %H')]['H']['len'] + data[start_date.strftime('%Y-%m-%d %H')]['N']['len']
			att_count = data[start_date.strftime('%Y-%m-%d %H')]['H']['att_count'] + data[start_date.strftime('%Y-%m-%d %H')]['N']['att_count']
			f.write("-%d&%d&%d"%(txt_count, t_len, att_count))
			start_date += timedelta(hours=1)
		f.close()
	print "			Write complete."

def runTextCounter():
	getLogs()
	getFileNames()
	displayFileList()
	print "\nBeginning chatlog indexing..."
	for chatlog in filenames:
		runMessageExtractor(chatlog)
	print ""

	analyze()
	writeDataTogether()

	# only within time range
	non0len_H = 0
	non0count_H = 0
	maxlen_H = 0
	non0len_N = 0
	non0count_N = 0
	maxlen_N = 0

	start_date = datetime.strptime("2014-05-02", '%Y-%m-%d')
	while start_date < datetime.strptime("2015-05-03", '%Y-%m-%d'):
		t_len = data[start_date.strftime('%Y-%m-%d %H')]['H']['len']
		if t_len > 0:
			non0len_H += t_len
			non0count_H += 1
			maxlen_H = max(maxlen_H, t_len)
		t_len = data[start_date.strftime('%Y-%m-%d %H')]['N']['len']
		if t_len > 0:
			non0len_N += t_len
			non0count_N += 1
			maxlen_N = max(maxlen_N, t_len)
		start_date += timedelta(hours=1)

	print "\nChatlog indexing is complete.\n"
	print "%d total messages: %d by Hizal and %d by Nicole."%(metadata['total_H_str']+metadata['total_N_str'], metadata['total_H_str'], metadata['total_N_str'])
	print "%d total attachments: %d by Hizal and %d by Nicole."%(metadata['total_H_att']+metadata['total_N_att'], metadata['total_H_att'], metadata['total_N_att'])
	print "%d ave characters: %d for Hizal (max %d) and %d for Nicole (max %d)"%((metadata['total_H_str_len']+metadata['total_N_str_len'])*1.0/(metadata['total_H_str']+metadata['total_N_str']), metadata['total_H_str_len']*1.0/metadata['total_H_str'], metadata['max_H_len'], metadata['total_N_str_len']*1.0/metadata['total_N_str'], metadata['max_N_len'])
	print "%d ave characters per hour: %d for Hizal (max %d) and %d for Nicole (max %d)"%((non0len_H + non0len_N)*1.0/(non0count_H + non0count_N), non0len_H*1.0/non0count_H, maxlen_H, non0len_N*1.0/non0count_N, maxlen_N)
	

runTextCounter()

