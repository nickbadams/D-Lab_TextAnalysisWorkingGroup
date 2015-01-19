#Hello class!

#R can do simple math, see:
3+5

#R can also help you create variables
newvar <- c(3, 5, 6, 12, 19)
newervar <- 1:5

#then you can do things with the variables. 'print' is a function being performce on 'newvar', namely a function that displays the content of newvar
print(newvar)
newervar # also prints

#you can also put all these variables in a matrix or 'dataframe'
print(newdf)

#libraries/packages are incredibly useful in R. They give us extra commands
#allowing us to do a lot of cool stuff. 

library(tm)


#setwd("/home/laura/Desktop/My Documents/DigitalHumanities/ceos_textanalysis/ceo_sentiment/text_diff")

a <- Corpus(DirSource("~/D-Lab_TextAnalysisWorkingGroup/Diff_Prop")) #the directory should have two text files in it, the files you want to compare
summary(a)

a <- tm_map(a, tolower) # convert all text to lower case
a <- tm_map(a, removePunctuation) 
a <- tm_map(a, removeNumbers)
a <- tm_map(a, removeWords, stopwords("english"))

library(SnowballC) # also needed for stemming function
a <- tm_map(a, stemDocument, language = "english") # converts terms to tokens
a.tdm <- TermDocumentMatrix(a) #puts tokens into a term document matrix
inspect(a.tdm[1:2,1:2]) # have a quick look at the term document matrix
findFreqTerms(a.tdm, lowfreq=100) # have a look at common words
nrow(a.tdm) #gives you the number of unique words
a.tdm.sp <- removeSparseTerms(a.tdm, sparse=0.50) #remove sparse terms, the sparse number should be higher with a large number of documents, smaller with small number of documents, always less than 1
nrow(a.tdm.sp) #compare the number of unique words after removing sparse terms
a.tdm.sp.df <- as.data.frame(inspect(a.tdm.sp)) # convert term document matrix to data frame
a.dtm.sp.df <- t(a.tdm.sp.df) #transpose matrix
rowTotals <- apply(a.dtm.sp.df, 1, sum) #create column with row totals, total number of words per document
rowTotals
head(rowTotals)
prop <- a.dtm.sp.df/rowTotals #change frequencies to proportions
prop <- t(prop)
head(prop)
data <- as.data.frame(prop)
data$diff <- data$men_nyt.txt - data$women_nyt.txt #creates new column (diff) which is the difference between columns 1 and 2, need to change the names to fit your file names
sorted <- data[with(data,order(data$diff)),] #sorts data by column diff
row.names(sorted)[1:40] #prints first row names, the top 40 words will define your first file
row.names(sorted)[2741:2782] #prints last row names, change the numbers to be the last 40 rows, the top 40 words definine your first file


first_rows <- cbind(row.names(sorted)[1:40], sorted[1:40,3]) #prints last row names
last_rows <- cbind(row.names(sorted)[2741:2782], sorted[2741:2782,3]) #prints last row names, change the numbers to fit your matrix

write.csv(first_rows, file = "diffprop_most_distinct_terms.csv") #writes csv file with the first rows and weights
write.csv(last_rows, file = "diffprop_least_distinct_terms.csv") #ditto with the last rows