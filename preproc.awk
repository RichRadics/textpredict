{
	gsub(//,"'")
	gsub(/[ø]/,"")
#	gsub(/(http|ftp)s?(\:\/\/)/,"")
	print $0
}