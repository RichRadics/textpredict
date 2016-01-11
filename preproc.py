import re
import fileinput
import sys

def find_ngrams(input_list, n):
  return zip(*[input_list[i:] for i in range(n)])

if len(sys.argv)>1:
	ngrams = int(sys.argv[1])
	presuffix = ['<SEN>']*(ngrams-1)
else:
	ngrams = 0

p_chevrons = re.compile(ur'[\<\>]')
p_phone = re.compile(ur'[0-9][0-9\s\-\.\,]{5,}[0-9]', re.IGNORECASE)
p_url = re.compile(ur'([\S]+\.[A-Za-z0-9]+(/[\S]*))|([\S]+\.[a-z0-9]+[\S]+\.[A-Za-z0-9]+(/[\S]*)?)', re.IGNORECASE)
p_hashtag = re.compile(ur'#\w\w+', re.IGNORECASE)
p_year = re.compile(ur'(1[5-9][0-9]\d|2[01][01]\d)(\W|$)', re.IGNORECASE)
p_quotes = re.compile(ur"(\'(?![a-z]))|((?<![a-z])\')", re.IGNORECASE)
p_number = re.compile(ur'[0-9]{2,}(st|th)?', re.IGNORECASE)
p_remove = re.compile(ur"[^A-Za-z0-9\s\<\>']")
p_numberseries = re.compile(ur'<n>[\s<n>]+')
p_hashtagseries = re.compile(ur'<h>[\s<h>]+')
p_replacespace = re.compile(ur'\-')
for line in fileinput.input('-'):
    t = re.sub(p_chevrons, ' ', line)
    t = re.sub(p_phone, ' <p> ', t)
    t = re.sub(p_year, ' <y> ', t)
    t = re.sub(p_url, ' <u> ', t)
    t = re.sub(p_hashtag, ' <h> ', t)
    t = re.sub(p_number, ' <n> ', t)
    t = re.sub(p_replacespace, ' ', t)
    t = re.sub(p_quotes, '', t)
    t = re.sub(p_remove, ' ', t)
    t = re.sub(p_numberseries, '<ns>', t)
    t = re.sub(p_hashtagseries, '<hs>', t)
    print t
   # if (ngrams>0):
   # 	res = find_ngrams(presuffix+t.split()+presuffix, int(ngrams))
   # 	for i in res:
   # 		print ' '.join(i).lower()
   # else:
   # 	print t

