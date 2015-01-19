#We're going to use a library called 'tm', and another called 'topic models'
#install.packages("tm")
#install.packages("topicmodels")
library(tm)

#### instead of using 'setwd()' function, start by finding the file in the bottom right quadrant of R Studio
#under 'Files' tab, find "D-Lab_TextAnalysisWorkingGroup" folder and click on it
#click 'More' icon, and then click 'Set as Working Directory'

## FUTURE REFERENCE: setwd("[whatever path gets R to the files you want on your computer, e.g.-- /home/My Documents/D-Lab/textanalysis_workshop/R/")

#####################
#### READING IN DATA
#####################
newspaper_text <-read.csv("ceos_newyorktimes_data.csv", header=TRUE) #read in CSV file
#create a list object 'm' of just the column of text
m <- list(Content="TEXT")
myReader <- readTabular(mapping=m)
(a <- Corpus(DataframeSource(newspaper_text), readerControl = list(reader = myReader))) #create corpus containing the text column, one line per document

######Alternative way to create corpus if you have separate documents. Put them all in one folder, then point to that directory:
## a <- Corpus(DirSource("/home/My Documents/D-Lab/[whatever your path to the file folder is]/textfilefolder"))
########

##################
#PRE-PROCESSING
##################

summary(a) #should tell you how many documents are in your corpus
a[[1]] #check the content of the first document in the corpus
a <- tm_map(a, tolower) # convert all text to lower case
a <- tm_map(a, removePunctuation) 
a <- tm_map(a, removeNumbers)
a <- tm_map(a, removeWords, stopwords("english"))

library(SnowballC) # needed for stemming function
a <- tm_map(a, stemDocument, language = "english") # converts terms to tokens
a.tdm <- TermDocumentMatrix(a, control=list(minDocFreq = 2)) #convert to term document matrix, words have to be in at least minDocFreq to appear, I set it to 2 (must appear in at least 2 documents), but you can change this.
inspect(a.tdm[1:10,1:10]) # have a quick look at the term document matrix
findFreqTerms(a.tdm, lowfreq=200) # have a look at common words... play around with this
nrow(a.tdm) #number of unique words in corpus
findAssocs(a.tdm, 'includ', 0.25) # find associated words and strength of the common words.play around with this
a.tdm.sp <- removeSparseTerms(a.tdm, sparse=0.987) #remove sparse terms, maybe not necessary, sometimes is. Play around with this if you're not getting good output.
a.tdm.sp.df <- as.data.frame(inspect(a.tdm.sp)) # convert term document matrix to data frame
nrow(a.tdm.sp.df) # check to see how many words we're left

require(slam)
a.dtm.sp.t <- t(a.tdm.sp) # transpose term document matrix into document term matrix


require(topicmodels)

#############################
#TO TOPIC MODELING!!
#############################
lda10 <- LDA(a.dtm.sp.t,10) # generate a LDA model with 10 topics
## lda5 <- LDA(a.tdm.sp.df,5) # generate a LDA model with 10 topics
## lda50 <- LDA(a.tdm.sp.df,50) # generate a LDA model with 10 topics

#############################
#BEGIN INTERPRETATION
#############################

get_terms(lda10, 10) # get keywords for each topic, just for a quick look

#write these to a csv file you can view in Excel and easily convert to a table, this time with top 50 terms
lda_terms <- get_terms(lda10, 50)
write.csv(lda_terms, file = "lda10_terms.csv")

###########################
#STOP, Let's interpret what we have
###########################


get_topics(lda10, 5) # gets topic numbers per document
lda_topics<-get_topics(lda10, 5) #creat object with top 5 topics per document
lda_topics <- t(lda_topics) #transpose this output so you can see what documents most represent which topics
write.csv(lda_topics, file = "lda10_topics.csv")



beta <- lda10@beta # create object containing parameters of the word distribution for each topic
gamma <- lda10@gamma # create object containing posterior topic distribution for each document
terms <- lda10@terms # create object containing terms (words) that can be used to line up with beta and gamma
colnames(beta) <- terms # puts the terms (or words) as the column names for the topic weights.
id <- t(apply(beta, 1, order)) # order the beta values
beta_ranked <- lapply(1:nrow(id), function(i) beta[i,id[i,]])  # gives table of words per topic with words ranked in order of
beta_ranked
gamma
terms
#######################
#Put output into various csv files

top50 <- lapply(beta_ranked, function (el1) {el1[3484:3534]}) #change based on the number of rows you have

top50t <- t(top50)

top50t
lda_topics<-get_topics(lda10, 5) 





 

###################
#Output terms with weights, by topic (top 50 terms)
term_list <- lapply(beta_ranked,function(x) exp(x[3500:3534]))
term_list <- lapply(term_list,function(x) cbind(names(x),x))
output <- c()
for (i in 1:length(term_list)){
    output <- cbind(output,term_list[[i]])
}
write.csv(output, file = "lda10_terms_weight.csv", row.names=F, col.names=F)










#####Alternative: use tf-idf scores to choose which words to keep

require(slam)
a.dtm.sp.t <- t(a.dtm.sp) # transpose document term matrix
summary(col_sums(a.dtm.sp.t)) # check median...
term_tfidf <- tapply(a.dtm.sp.t$v/row_sums(a.dtm.sp.t)[a.dtm.sp.t$i], a.dtm.sp.t$j,mean) * log2(nDocs(a.dtm.sp.t)/col_sums(a.dtm.sp.t>0)) # calculate tf-idf values
summary(term_tfidf) # check median... note value for next line... 
a.dtm.sp.t.tdif <- a.dtm.sp.t[,term_tfidf>=0.014] # keep only those terms that are slightly less frequent that the median
a.dtm.sp.t.tdif <- a.dtm.sp.t[row_sums(a.dtm.sp.t) > 0, ]
summary(col_sums(a.dtm.sp.t.tdif)) # have a look
ncol(a.dtm.sp.t.tdif) #number of terms you're left with

######

a.dtm.t <- t(a.dtm) #try with all of the words, not removing sparse terms

