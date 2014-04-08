# now we've got a list of URLs to the member's pages,
# we can edit the URLs to get to their blogs... we just
# need to get rid of the 'member' bit in the URL...

bloglinks <- lapply(links, function(i) gsub("members/", "", i))

# and since some bloggers have multiple posts, let's be
# sure we're only looking at the ones posted on the actual
# day of dh (or any other specific day)

dayof <- "2014/04/08/" # for now, just test on day before where
# there is some actual content

dayoflinks <- lapply(bloglinks, function(i) paste0(i, dayof))

# Now let's get all the text that people posted to their 
# day of dh blogs on that day

# make one big list of URLs
linksall <- unlist(dayoflinks)
# make a data.frame to store the full text in 
# and get date and author of full text also
blogtext <- data.frame(text =  vector(length = length(linksall)),                                     
                       monthdayear = vector(length = length(linksall)),
                       author = vector(length = length(linksall))
)

# make a list to store comments for each blog post
commenters <- vector("list", length = length(linksall))
# going to use this to simplify getting the author's id
toMatch <- c("http://dayofdh2014.matrix.msu.edu/", dayof, "/")

# loop over the URLs to pull full text, etc. from each URL
# includes error handling in case a field is empty, etc.
# don't worry about many error messages, those are just
# blogs that don't exist! We'll filter them out in a moment.

for(i in 1:length(linksall)){
  # track progress
  print(i)
  # get URL
  blogdata <- htmlParse(getURI(linksall[[i]]))
  # get text from URL
  result <- try(
    blogtext[i,1] <- xpathSApply(blogdata, "//*/div[@class='entry-content']", xmlValue)
  ); if(class(result) == "try-error") next;
  # get date of blog post
  # first month and day
  result <- try(
    blogtext[i,2] <- xpathSApply(blogdata, "//*/time[@class='entry-date']", xmlValue)
  ); if(class(result) == "try-error") next;
  # author name
  result <- try(
    blogtext[i,3] <-  gsub(paste(toMatch,collapse="|"), "",  linksall[[i]])
  ); if(class(result) == "try-error") next;
  # and the names of the commenters 
  result <- try(
    commenters[[i]] <- xpathSApply(blogdata, "//*/b[@class='fn']", xmlValue)
  ); if(class(result) == "try-error") next;
# little pause between each URL so we don't hurt the server
Sys.sleep(10)
}

# add columns of URLs to the fulltext post
blogtext$url <- linksall

# filter out blogs with no post for this day
blogtext_f <- blogtext[blogtext$monthdayear != "FALSE", ]

