

#' Get URLs to blog post full text for all posts
#' by getting all members' ids from the members
#' directory
#' 


# load packages or download if not already
list.of.packages <- c("RCurl", "XML")
new.packages <- list.of.packages[!(list.of.packages %in% installed.packages()[,"Package"])]
if(length(new.packages)) install.packages(new.packages)
sapply(list.of.packages, function(i) library(i, character.only=TRUE))

n <- 22 # determined by inspecting 
# http://dayofdh2014.matrix.msu.edu/members/

# pre-allocate list to fill
links <- vector("list", length = n)

for(i in 1:n){
  # track progress by showing the iteration we're up to
  print(i)
  # get all content on the i+1 th page of the main blog list
  memberids <- htmlParse(getURI(paste0("http://dayofdh2014.matrix.msu.edu/members/?upage=", i)))
  # extract links for all posts
  links[[i]] <- unname(xpathSApply(memberids,"//div[@class = 'item-title']/a/@href"))
}
