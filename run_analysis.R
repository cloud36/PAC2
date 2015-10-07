#Instructions
#You should create one R script called run_analysis.R that does the following. 
#Merges the training and the test sets to create one data set.
#Extracts only the measurements on the mean and standard deviation for each measurement. 
#Uses descriptive activity names to name the activities in the data set
#Appropriately labels the data set with descriptive variable names. 
#From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

#https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip


#set working directory and download files to working directory if they don't exist.

#create data directory if it doesn't exist
if (!file.exists("data")) {
  dir.create("data")
}

#download data
url <- "http://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(url, destfile = './data/dataset.zip')
unzip("./data/dataset.zip", exdir = "data")

#load datasets
train <- read.csv("data/UCI HAR Dataset/train/X_train.txt", sep = "\t", header = FALSE, colClasses = "character")
#remove double spaces
t1 <- gsub(" ", " ", t1$V1)
#get maximum number of column. Not equal to do breaks
for (i in 1:nrow(train)){
  m <- 0
  l <- length(strsplit(as.character(train[i,]), " ")[[1]])
  if (l > m ){
    m <- l
  }
}
#break into m columns



#t1$V2 <- lapply(strsplit(as.character(t1$V1), " "), "[[", 1)
#df$newColumn2 <- lapply(strsplit(as.character(df$originalColumn), "and"), "[", 2)

test <- read.csv("data/UCI HAR Dataset/test/X_test.txt", , sep = "\t", header = FALSE)
