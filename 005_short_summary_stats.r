# a few quick summary statistics

# How many posts in total?
(total_posts <- nrow(blogtext_f))

# How many words in total?
(total_words <- length(unlist(lapply(blogtext_f$text, function(i) strsplit(i, " ")[[1]]))))

# how many authors in total?
(total_authors <- length(unique(blogtext_f$author)))
