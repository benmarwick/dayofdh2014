# clean up the text a bit to remove odd characters
# remove non-ASCII characters
Encoding(blogtext_f[,1]) <- "latin1" 
iconv(blogtext_f[,1], "latin1", "ASCII", sub="")
# remove newline character
blogtext_f[,1] <- gsub("\n"," ", blogtext_f[,1]) 