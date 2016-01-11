import re
import fileinput
import sys

def find_ngrams(input_list, n):
  return zip(*[input_list[i:] for i in range(n)])

if len(sys.argv)>1:
	ngrams = int(sys.argv[1])
	presuffix = ['<>']*(ngrams-1)
else:
	ngrams = 0

for t in fileinput.input('-'):
    if (len(t)>1):
        if (ngrams>0):
        	res = find_ngrams(presuffix+t.split()+presuffix, int(ngrams))
        	for i in res:
        		print ' '.join(i).lower()
        else:
        	print t

